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
            baseURL: GOOGLE_MAP_API_BASEURL,
            path: "maps/api/place/textsearch/json?",
            method: .get,
            queryParameters: mapsRequestDTO)
    }
    
    static func searchGoogleMapNextList(with mapsRequestDTO: MapsNextRequestDTO) -> Endpoint<MapsResponseDTO> {
        return Endpoint(
            baseURL: GOOGLE_MAP_API_BASEURL,
            path: "maps/api/place/textsearch/json?",
            method: .get,
            queryParameters: mapsRequestDTO)
    }
    
    static func getGoogleMapImage(with mapImageRequestDTO: MapImageRequestDTO) -> Endpoint<Data> {
        return Endpoint(
            baseURL: GOOGLE_MAP_API_BASEURL,
            path: "maps/api/staticmap?",
            method: .get,
            queryParameters: mapImageRequestDTO)
    }
    
    static func getCurrentUser() -> Endpoint<CurrentUserResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "auth/login",
            method: .get)
    }
    
    static func getBappyUser(with userProfileRequestDTO: BappyUserRequestDTO) -> Endpoint<BappyUserResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "auth/login",
            method: .get,
            queryParameters: userProfileRequestDTO)
    }
    
    static func createUser(with createUserRequestDTO: CreateUserRequestDTO) -> Endpoint<CreateUserResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "user/",
            method: .post,
            bodyParameters: createUserRequestDTO,
            contentType: .multipart)
    }
    
    static func getHangouts(with hangoutsRequestDTO: HangoutsRequestDTO) -> Endpoint<HangoutsResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "hangouts",
            method: .get,
            queryParameters: hangoutsRequestDTO)
    }
    
    static func updateGPSSetting(with gpsSettingRequestDTO: GPSSettingRequestDTO) -> Endpoint<GPSSettingResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "place/gps",
            method: .put,
            bodyParameters: gpsSettingRequestDTO,
            contentType: .urlencoded)
    }
}
