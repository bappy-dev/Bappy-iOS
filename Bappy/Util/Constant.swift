//
//  Constant.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit

public var topPadding: CGFloat {
    return UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .first(where: { $0 is UIWindowScene })
        .flatMap({ $0 as? UIWindowScene })?.windows
        .first(where: \.isKeyWindow)
        .map { $0.safeAreaInsets.top } ?? 0
}

public var bottomPadding: CGFloat {
    return UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .first(where: { $0 is UIWindowScene })
        .flatMap({ $0 as? UIWindowScene })?.windows
        .first(where: \.isKeyWindow)
        .map { $0.safeAreaInsets.bottom } ?? 0
}
