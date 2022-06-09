//
//  APIEndpoints.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

struct APIEndpoints {
    static func searchGoogleMapList(with mapsRequestDTO: MapsRequestDTO) -> Endpoint<MapsResponseDTO> {
        return Endpoint(
            baseURL: "https://maps.googleapis.com/",
            path: "maps/api/place/textsearch/json?",
            method: .get,
            queryParameters: mapsRequestDTO)
    }
    
    static func searchGoogleMapNextList(with mapsRequestDTO: MapsNextRequestDTO) -> Endpoint<MapsResponseDTO> {
        return Endpoint(
            baseURL: "https://maps.googleapis.com/",
            path: "maps/api/place/textsearch/json?",
            method: .get,
            queryParameters: mapsRequestDTO)
    }
}
