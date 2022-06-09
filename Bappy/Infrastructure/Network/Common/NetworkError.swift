//
//  NetworkError.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknownError
    case invalidHttpStatusCode(Int)
    case components
    case urlRequest(Error)
    case parsing(Error)
    case emptyData
    case decodeError
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return "알 수 없는 에러가 발생했습니다."
        case .invalidHttpStatusCode: return "상태코드가 200~299에 해당하지 않습니다."
        case .components: return "components 생성 과정에서 에러가 발생했습니다."
        case .urlRequest: return "URL request 과정에서 에러가 발생했습니다."
        case .parsing: return "데이터를 파싱하는 과정에서 에러가 발생했습니다."
        case .emptyData: return "비어있는 data 입니다."
        case .decodeError: return "decode 과정에서 에러가 발생했습니다."
        }
    }
}
