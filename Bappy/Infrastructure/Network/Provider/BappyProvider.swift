//
//  BappyProvider.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/11.
//

import UIKit
import RxSwift

final class BappyProvider {
    private let session: URLSessionable
    private let firebaseRepository: FirebaseRepository
    private let disposeBag = DisposeBag()
    
    private var token: String? = nil
    
    init(session: URLSessionable = URLSession.shared, firebaseRepository: FirebaseRepository = DefaultFirebaseRepository.shared) {
        self.session = session
        self.firebaseRepository = firebaseRepository
        
        firebaseRepository.token
            .bind(onNext: { self.token = $0 })
            .disposed(by: disposeBag)
    }
    
    private func showConnectionAlert() {
        DispatchQueue.main.async {
            if let viewController = UIWindow.keyWindow?.visibleViewConroller {
                let alert = Alert(
                    title: "Problem Occurred",
                    message: "\nThere was a problem\nwith the Bappy\'s server.\n\nWe are very sorry\nfor the inconvenience.",
                    bappyStyle: .sad,
                    canDismissByTouch: false,
                    actionTitle: "Exit App") {
                        // 강제종료
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
                    }
                viewController.showAlert(alert)
            }
        }
    }
    
    private func checkServerConnection(_ error: Error?,
                                       completion: @escaping(Bool) -> Void) {
        guard let error = error as? NSError else {
            completion(true)
            return
        }
        
        if error.domain == NSURLErrorDomain {
            showConnectionAlert()
            completion(false)
        } else {
            completion(true)
        }
    }
    
    private func checkError(with data: Data?,
                            _ response: URLResponse?,
                            _ error: Error?,
                            completion: @escaping(Result<Data, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknownError))
            return
        }
        
        guard response.statusCode != 401 else {
            completion(.failure(NetworkError.expiredToken))
            return
        }
        
        guard response.statusCode != 403 else {
            completion(.failure(NetworkError.invalidToken))
            return
        }
        
        guard (200...299).contains(response.statusCode) else {
            completion(.failure(NetworkError.invalidHttpStatusCode(response.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.emptyData))
            return
        }
        
        completion(.success(data))
    }
    
    private func decode<T: Decodable>(data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.emptyData)
        }
    }
    
    private func getToken(completion: @escaping(Result<String, Error>) -> Void) {
        if let token = token { completion(.success(token)) }
        else { getNewToken { completion($0) } }
    }
    
    private func getNewToken(completion: @escaping(Result<String, Error>) -> Void) {
        firebaseRepository.getIDTokenForcingRefresh { result in
            switch result {
            case .success(let token):
                if let token = token { completion(.success(token)) }
                else { completion(.failure(FirebaseError.emptyToken)) }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func retry<R: Decodable,
                       E: RequestResponsable>(with endpoint: E,
                                              completion: @escaping(Result<R, Error>) -> Void) where E.Response == R {
        self.getNewToken { [weak self] result in
            switch result {
            case .success(let token):
                do {
                    var urlRequest = try endpoint.getURLRequest()
                    urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
                    self?.session.dataTask(with: urlRequest) { data, response, error in
                        self?.checkError(with: data, response, error) { result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let data):
                                completion(self.decode(data: data))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }.resume()
                    
                } catch {
                    completion(.failure(NetworkError.urlRequest(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func retry<E: RequestResponsable>(_ endpoint: E,
                                              completion: @escaping(Result<Data, Error>) -> Void) {
        self.getNewToken { [weak self] result in
            switch result {
            case .success(let token):
                do {
                    var urlRequest = try endpoint.getURLRequest()
                    urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
                    self?.session.dataTask(with: urlRequest) { data, response, error in
                        self?.checkError(with: data, response, error) { result in
                            switch result {
                            case .success(let data):
                                completion(.success(data))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }.resume()
                    
                } catch {
                    completion(.failure(NetworkError.urlRequest(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension BappyProvider: Provider {
    func request<R: Decodable,
                 E: RequestResponsable>(with endpoint: E,
                                        completion: @escaping(Result<R, Error>) -> Void) where E.Response == R {
        self.getToken { [weak self] result in
            switch result {
            case .success(let token):
                print("DEBUG: token \(token)")
                do {
                    var urlRequest = try endpoint.getURLRequest()
                    urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
                    self?.session.dataTask(with: urlRequest) { data, response, error in
                        self?.checkError(with: data, response, error) { result in
                            guard let self = self else { return }
                            self.checkServerConnection(error) { connection in
                                guard connection else { return }
                                switch result {
                                case .success(let data):
                                    completion(self.decode(data: data))
                                case .failure(let error):
                                    if let error = error as? NetworkError {
                                        switch error {
                                        case .invalidToken, .expiredToken:
                                            self.retry(with: endpoint, completion: completion)
                                        default: completion(.failure(error))
                                        }
                                    } else { completion(.failure(error)) }
                                }
                            }
                        }
                    }.resume()
                    
                } catch {
                    completion(.failure(NetworkError.urlRequest(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request<E: RequestResponsable>(_ endpoint: E,
                                        completion: @escaping(Result<Data, Error>) -> Void) {
        self.getToken { [weak self] result in
            switch result {
            case .success(let token):
                do {
                    var urlRequest = try endpoint.getURLRequest()
                    urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
                    self?.session.dataTask(with: urlRequest) { data, response, error in
                        self?.checkError(with: data, response, error) { result in
                            switch result {
                            case .success(let data):
                                completion(.success(data))
                            case .failure(let error):
                                if let error = error as? NetworkError {
                                    switch error {
                                    case .invalidToken, .expiredToken:
                                        self?.retry(endpoint, completion: completion)
                                    default: completion(.failure(error))
                                    }
                                } else { completion(.failure(error)) }
                            }
                        }
                    }.resume()
                    
                } catch {
                    completion(.failure(NetworkError.urlRequest(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request(_ url: URL,
                 completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) { [weak self] data, response, error in
            self?.checkError(with: data, response, error) { result in
                completion(result)
            }
        }.resume()
    }
}
