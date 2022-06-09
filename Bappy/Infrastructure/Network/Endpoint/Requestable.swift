//
//  Requestable.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String]? { get }
    var sampleData: Data? { get }
}

extension Requestable {
    func getURLRequest() throws -> URLRequest {
        let url = try url()
        var urlRequest = URLRequest(url: url)
        
        // httpBody
        if let bodyParameters = try bodyParameters?.toDictionary() {
            if !bodyParameters.isEmpty {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
            }
        }
        
        // httpMethod
        urlRequest.httpMethod = method.rawValue
        
        // header
        headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    func url() throws -> URL {
        // baseURL + path
        let fullPath = "\(baseURL)\(path)"
        guard var urlComponents = URLComponents(string: fullPath) else { throw NetworkError.components }
        
        // (baseURL + path) + queryParameters
        var urlQueryItems = [URLQueryItem]()
        if let queryParameters = try queryParameters?.toDictionary() {
            queryParameters.forEach {
                let queryItem = URLQueryItem(name: $0.key, value: "\($0.value)")
                urlQueryItems.append(queryItem)
            }
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else { throw NetworkError.components }
        return url
    }
}
