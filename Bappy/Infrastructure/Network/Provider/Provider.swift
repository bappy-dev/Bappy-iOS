//
//  Provider.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation
import RxSwift

protocol Provider {
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E, completion: @escaping(Result<R, Error>) -> Void) where E.Response == R
    func request<E: RequestResponsable>(_ endpoint: E, completion: @escaping(Result<Data, Error>) -> Void)
    func request(_ url: URL, completion: @escaping(Result<Data, Error>) -> ())
    func upload<R: Decodable, E: RequestResponsable>(with endpoint: E, completion: @escaping(Result<R, Error>) -> Void) where E.Response == R
}

extension Provider {
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Single<Result<R, Error>> where E.Response == R {
        return Single<Result<R, Error>>.create { single in
            request(with: endpoint) { (result: Result<R, Error>) in
                switch result {
                case .success(let data):
                    single(.success(.success(data)))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func request<E: RequestResponsable>(_ endpoint: E) -> Single<Result<Data, Error>> {
        return Single<Result<Data, Error>>.create { single in
            request(endpoint) { (result: Result<Data, Error>) in
                switch result {
                case .success(let data):
                    single(.success(.success(data)))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func request(_ url: URL) -> Single<Result<Data, Error>> {
        return Single<Result<Data, Error>>.create { single in
            request(url) { result in
                switch result {
                case .success(let data):
                    single(.success(.success(data)))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func upload<R: Decodable, E: RequestResponsable>(with endpoint: E) -> Single<Result<R, Error>> where E.Response == R {
        return Single<Result<R, Error>>.create { single in
            upload(with: endpoint) { (result: Result<R, Error>) in
                switch result {
                case .success(let data):
                    single(.success(.success(data)))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
