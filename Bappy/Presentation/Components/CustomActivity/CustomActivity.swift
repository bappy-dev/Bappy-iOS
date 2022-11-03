//
//  CustomActivity.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/03.
//

import UIKit

import KakaoSDKShare

protocol CustomActivityDelegate: AnyObject {
    func performActionCompletion(actvity: CustomActivity)
}

class CustomActivity: UIActivity {
    weak var delegate: CustomActivityDelegate?
    
    private let title: String
    private let desc: String
//    private let imageURL: URL
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
//        self.imageURL = imageURL
    }
    
    override class var activityCategory: UIActivity.Category {
        return .action//default
    }

    override var activityType: UIActivity.ActivityType? {
        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
        return UIActivity.ActivityType(rawValue: bundleId + "\(self.classForCoder)")
    }

    override var activityTitle: String? {
        return "카톡으로 공유"
    }

    override var activityImage: UIImage? {
        return UIImage(named: "icons8-safari-50")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        ShareApi.shared.shareCustom(templateId:85131, templateArgs: ["TITLE":title, "DESC": desc]) { (sharingResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("shareCustom() success.")
                    if let sharingResult = sharingResult {
                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
    }
    
    override func perform() {
        self.delegate?.performActionCompletion(actvity: self)
        activityDidFinish(true)
    }
}
