//
//  Endpoint.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

protocol RequestResponsable: Requestable, Responsable {}

final class Endpoint<R>: RequestResponsable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HttpMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String : String]?
    var sampleData: Data?
    
    init(baseURL: String, path: String = "", method: HttpMethod = .get, queryParameters: Encodable? = nil, bodyParameters: Encodable? = nil, headers: [String: String]? = [:], sampleData: Data? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
        self.sampleData = sampleData
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
