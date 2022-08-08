//
//  SettingSwitch.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/08.
//

import UIKit
import RxSwift

final class SettingSwitch: UIButton {
    
    // MARK: Properties
    var isOn: Bool = false {
        didSet { updateState(isOn) }
    }
    
    // MARK: Helpers
    private func updateState(_ state: Bool) {
        let image = UIImage(named: "setting_switch_\(state ? "on" : "off")")
        setImage(image, for: .normal)
    }
}

extension Reactive where Base: SettingSwitch {
    var isOn: Binder<Bool> {
        return Binder(self.base) { base, isOn in
            base.isOn = isOn
        }
    }
}
