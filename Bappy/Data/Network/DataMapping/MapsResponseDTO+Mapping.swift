//
//  MapsResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import UIKit

struct MapsResponseDTO: Decodable {
    
    let nextPageToken: String?
    let maps: [MapDTO]
    
    private enum CodingKeys: String, CodingKey {
        case nextPageToken = "next_page_token"
        case maps = "results"
    }
}

extension MapsResponseDTO {
    struct MapDTO: Decodable {
        let id: String
        let name: String
        let iconURL: String
        let address: String
        let geometry: GeometryDTO
        
        private enum CodingKeys: String, CodingKey {
            case id = "place_id"
            case name = "name"
            case iconURL = "icon"
            case address = "formatted_address"
            case geometry
        }
    }
    
    struct GeometryDTO: Decodable {
        let location: LocationDTO
        
        private enum CodingKeys: String, CodingKey {
            case location
        }
    }
    
    struct LocationDTO: Decodable {
        let latitude: CGFloat
        let longitude: CGFloat
        
        private enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
    }
}

extension MapsResponseDTO {
    func toDomain() -> MapPage {
        let maps = maps
            .map {
                Map(id: $0.id,
                   name: $0.name,
                   address: $0.address,
                   latitude: $0.geometry.location.latitude,
                   longitude: $0.geometry.location.longitude,
                   iconURL: URL(string: $0.iconURL))
            }
        return .init(nextPageToken: nextPageToken,
                     maps: maps)
    }
}
