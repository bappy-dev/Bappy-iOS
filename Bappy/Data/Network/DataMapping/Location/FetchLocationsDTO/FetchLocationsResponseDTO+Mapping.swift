//
//  FetchLocationsResponseDTO+Mapping.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import Foundation

struct FetchLocationsResponseDTO: Decodable {
    
    let locationsDTO: [LocationsDTO]
    
    private enum CodingKeys: String, CodingKey {
        case locationsDTO = "data"
    }
}

extension FetchLocationsResponseDTO {
    struct LocationsDTO: Decodable {
        let id: String
        let name: String
        let address: String
        
        let latitude: Double
        let longitude: Double
        
        let isSelected: Bool
        
        private enum CodingKeys: String, CodingKey {
            case id = "locationID"
            case name = "locationName"
            case address = "locationAddress"
            case latitude = "latitude"
            case longitude = "longitude"
            case isSelected = "isSelected"
        }
    }
    
    func toDomain() -> [Location] {
        return locationsDTO.map {
            Location(
                identity: $0.id,
                name: $0.name,
                address: $0.address,
                coordinates: .init(latitude: $0.latitude, longitude: $0.longitude),
                isSelected: $0.isSelected
            )
        }
    }
}
