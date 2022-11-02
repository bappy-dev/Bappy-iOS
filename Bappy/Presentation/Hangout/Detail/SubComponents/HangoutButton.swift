//
//  HangoutButton.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/25.
//

import UIKit
import SnapKit
import RxSwift

final class HangoutButton: UIButton {
    enum State: String {
        case create, join, cancel, expired, closed
    }
    
    // MARK: Properties
    var hangoutState: State = .closed {
        didSet { updateButtonState(hangoutState) }
    }
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func updateButtonState(_ state: State) {
        DispatchQueue.main.async {
            switch state {
            case .create, .join:
                self.backgroundColor = .bappyYellow
                self.setBappyTitle(
                    title: state.rawValue.uppercased(),
                    font: .roboto(size: 28.0, family: .Bold))
                self.addBappyShadow()
                self.isEnabled = true
                
            case .expired, .closed:
                self.backgroundColor = .bappyGray.withAlphaComponent(0.15)
                self.setBappyTitle(
                    title: state.rawValue.uppercased(),
                    font: .roboto(size: 28.0, family: .Bold),
                    color: .bappyGray)
                self.clipsToBounds = true
                self.isEnabled = false
                
            case .cancel:
                self.backgroundColor = .bappyCoral
                self.setBappyTitle(
                    title: state.rawValue.uppercased(),
                    font: .roboto(size: 28.0, family: .Bold),
                    color: .white)
                self.addBappyShadow()
                self.isEnabled = true
            }
        }
    }
    
    private func layout() {
        self.layer.cornerRadius = 29.5
        self.snp.makeConstraints {
            $0.width.equalTo(250.0)
            $0.height.equalTo(59.0)
        }
    }
}

// MARK: - Binder
extension Reactive where Base: HangoutButton {
    var hangoutState: Binder<HangoutButton.State> {
        return Binder(self.base) { button, state in
            button.hangoutState = state
        }
    }
}
