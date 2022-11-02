//
//  Bappy++Bundle.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/05.
//

import Foundation

extension Bundle {
    var googleMapAPIKey: String {
        guard let file = self.path(forResource: "GoogleMap-Info", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("GoogleMap-Info.plist 파일에 API_KEY를 입력해주세요.") }
        return key
    }
    
    var kakaoAPIKey: String {
        guard let file = self.path(forResource: "Info", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["KAKAO_APP_KEY"] as? String else { fatalError("Info.plist 파일에 KAKAO_APP_KEY를 입력해주세요.") }
        return key
    }
}
