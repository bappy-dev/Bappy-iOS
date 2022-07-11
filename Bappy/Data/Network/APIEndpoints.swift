//
//  APIEndpoints.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import UIKit

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
    
    static func getGoogleMapImage(with mapImageRequestDTO: MapImageRequestDTO) -> Endpoint<Data> {
        return Endpoint(
            baseURL: "https://maps.googleapis.com/",
            path: "maps/api/staticmap?",
            method: .get,
            queryParameters: mapImageRequestDTO)
    }
    
    static func getCurrentUser(token: String) -> Endpoint<CurrentUserResponseDTO> {
        return Endpoint(
            baseURL: "SERVER", // 임시
            path: "auth/login",
            method: .get,
            headers: ["authorization": token]
        )
    }
    
    static func getBappyUser(with userProfileRequestDTO: BappyUserRequestDTO, token: String) -> Endpoint<BappyUserResponseDTO> {
        return Endpoint(
            baseURL: "SERVER", // 임시
            path: "auth/login",
            method: .get,
            queryParameters: userProfileRequestDTO,
            headers: ["authorization": token]
        )
    }
    
    static func createUser(with createUserRequestDTO: CreateUserRequestDTO, token: String) -> Endpoint<CreateUserResponseDTO> {
        return Endpoint(
            baseURL: "SERVER", // 임시
            path: "user",
            method: .post,
            bodyParameters: createUserRequestDTO,
            headers: ["authorization": token]
        )
    }
    
    static func getHangouts(with hangoutsRequestDTO: HangoutsRequestDTO, token: String) -> Endpoint<HangoutsResponseDTO> {
        return Endpoint(
            baseURL: "SERVER", // 임시
            path: "hangouts",
            method: .get,
            queryParameters: hangoutsRequestDTO,
            headers: ["authorization": token]
        )
    }
}
