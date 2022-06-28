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
    case expiredToken
    case invalidToken
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return "알 수 없는 에러가 발생했습니다."
        case .invalidHttpStatusCode: return "상태코드가 200~299에 해당하지 않습니다."
        case .components: return "components 생성 과정에서 에러가 발생했습니다."
        case .urlRequest: return "URL request 과정에서 에러가 발생했습니다."
        case .parsing: return "데이터를 파싱하는 과정에서 에러가 발생했습니다."
        case .emptyData: return "비어있는 data 입니다."
        case .decodeError: return "decode 과정에서 에러가 발생했습니다."
        case .expiredToken: return "Token이 만료되었습니다."
        case .invalidToken: return "유효하지 않은 토큰입니다."
        }
    }
}

enum FirebaseError: LocalizedError {
    case signOutFailed
    
    var errorDescription: String? {
        switch self {
        case .signOutFailed: return "Firebase SignOut에 실패했습니다."
        }
    }
}

