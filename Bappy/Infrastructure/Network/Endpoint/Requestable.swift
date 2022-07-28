//
//  Requestable.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation
import UIKit.UIImage

enum ContentType {
    case applicationJSON, multipart, none
}

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var images: [UIImage]? { get }
    var headers: [String: String]? { get }
    var contentType: ContentType { get }
    var sampleData: Data? { get }
}

extension Requestable {
    func getURLRequest() throws -> URLRequest {
        let url = try url()
        var urlRequest = URLRequest(url: url)
        
        // httpMethod
        urlRequest.httpMethod = method.rawValue
        
        // header
        headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        switch contentType {
        case .applicationJSON, .none:
            // header
            if contentType == .applicationJSON {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            // httpBody
            if let bodyParameters = try bodyParameters?.toDictionary() {
                if !bodyParameters.isEmpty {
                    urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
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
                    data.append(convertFormField(key: key, value: "\(value)", boundary: boundary))
                }
            }
        }
        
        if let images = images, !images.isEmpty {
            for image in images {
                guard let imageData = image.jpegData(compressionQuality: 1.0) else { continue }
                data.append(convertFileData(fieldName: "file",
                                            fileName: "\(UUID().uuidString).jpg",
                                            mimeType: "image/jpg",
                                            fileData: imageData,
                                            boundary: boundary))
            }
        }
        
        data.append("--\(boundary)--".data(using: .utf8)!)
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
