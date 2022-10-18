//
//  Requestable.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

enum ContentType {
    case urlencoded, multipart, none
}

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var imageDatas: [Data]? { get }
    var headers: [String: String]? { get }
    var contentType: ContentType { get }
    var sampleData: Data? { get }
}

extension Requestable {
    func getURLRequest() throws -> URLRequest {
        let url = try url()
        var urlRequest = URLRequest(url: url)
        
        // request timeoutInterval
        urlRequest.timeoutInterval = 10
        
        // httpMethod
        urlRequest.httpMethod = method.rawValue
        
        // header
        headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        switch contentType {
        case .none:
            // httpBody
            if let bodyParameters = try bodyParameters?.toDictionary() {
                if !bodyParameters.isEmpty {
                    urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
                }
            }
            
        case .urlencoded:
            // header
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            // httpBody
            if let bodyParameters = try bodyParameters?.toDictionary() {
                if !bodyParameters.isEmpty {
                    let httpBody = bodyParameters
                        .map { "\($0.key)=\($0.value)" }
                        .joined(separator: "&")
                        .data(using: .utf8)
                    urlRequest.httpBody = httpBody
                }
            }
            
        case .multipart:
            let boundary = "Boundary-\(UUID().uuidString)"
            // header
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // httpBody
            let httpBody = try getMultipartFormData(boundary: boundary)
            urlRequest.httpBody = httpBody
        }
        
        return urlRequest
    }
}

extension Requestable {
    private func url() throws -> URL {
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
    
    private func getMultipartFormData(boundary: String) throws -> Data {
        var data = Data()
        
        if let bodyParameters = try bodyParameters?.toDictionary() {
            if !bodyParameters.isEmpty {
                for (key, value) in bodyParameters {
                    if let arr = value as? Array<Any> {
                        arr.forEach { elem in
                            data.append(convertFormField(key: key, value: "\(elem)", boundary: boundary))
                        }
                    } else {
                        data.append(convertFormField(key: key, value: "\(value)", boundary: boundary))
                    }
                }
            }
        }
        
        if let imageDatas = imageDatas {
            for imageData in imageDatas {
                if !imageData.isEmpty {
                    data.append(convertFileData(fieldName: "file",
                                                fileName: "\(UUID().uuidString).jpg",
                                                mimeType: "image/jpg",
                                                fileData: imageData,
                                                boundary: boundary))
                }
            }
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return data
    }
    
    private func convertFormField(key: String,
                                  value: String,
                                  boundary: String) -> Data {
        var data = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        data.append(boundaryPrefix.data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        data.append("\(value)\r\n".data(using: .utf8)!)
        
        return data
    }

    private func convertFileData(fieldName: String,
                                fileName: String,
                                mimeType: String,
                                fileData: Data,
                                boundary: String) -> Data {
        var data = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        data.append(boundaryPrefix.data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        
        return data
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
