//
//  FetchReviewsResponseDTO+Mapping.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/25.
//

import Foundation

struct FetchReviewsResponseDTO: Decodable {
    let referenceDTO: ReferenceDTOWrapper
    let message: String
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case referenceDTO = "data"
    }
    
    struct ReferenceDTOWrapper: Decodable {
        let referenceDTO: [ReferenceDTO]
        
        private enum CodingKeys: String, CodingKey {
            case referenceDTO = "reviews"
        }
    }
    
    struct ReferenceDTO: Decodable {
        let hangoutId: String
        let writerName: String
        let writerProfileImageURL: String
        let tags: [String]
        let message: String
        let isCanRead: Bool
        let createTime: String
        
        func toDomain() -> Reference {
            Reference(writerName: writerName,
                      writerProfileImageURL: URL(string: "\(BAPPY_API_BASEURL)static-file/\(writerProfileImageURL)"),
                      tags: tags,
                      contents: message,
                      date: createTime.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")?.toString(dateFormat: "yyyy-MM-dd") ?? "",
                      isCanRead: isCanRead,
                      hangoutID: hangoutId)
        }
    }

}

extension FetchReviewsResponseDTO {
    func toDomain() -> [Reference] {
        return referenceDTO.referenceDTO.map { $0.toDomain() }
    }
}
