//
//  URLSessionable.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

protocol URLSessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask
}

extension URLSession: URLSessionable {}
