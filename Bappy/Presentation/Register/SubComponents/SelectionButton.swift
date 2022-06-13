//
//  SelectionButton.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectionButton: UIButton {
    
    // MARK: Properties
    let title: String
    
    // MARK: Lifecycle
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.layer.cornerRadius = 3.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
    }
}

// MARK: - Binder
// MainScheduler에서 수행, Observer only -> 값을 주입할 수 있지만, 값을 관찰할 수 없음
extension Reactive where Base: SelectionButton {
    var isSelected: Binder<Bool> {
        return Binder(self.base) { button, isSelected in
            print("DEBUG: \(isSelected)")
            if isSelected {
                button.setAttributedTitle(
                    NSAttributedString(
                        string: base.title,
                        attributes: [
                            .font: UIFont.roboto(size: 14.0),
                            .foregroundColor: UIColor(named: "bappy_brown")!
                        ]), for: .normal)
                button.backgroundColor = UIColor(named: "bappy_yellow")
                button.clipsToBounds = false
            } else {
                button.setAttributedTitle(
                    NSAttributedString(
                        string: base.title,
                        attributes: [
                            .font: UIFont.roboto(size: 14.0),
                            .foregroundColor: UIColor(named: "bappy_gray")!
                        ]), for: .normal)
                button.backgroundColor = UIColor(named: "bappy_lightgray")
                button.clipsToBounds = true
            }
        }
    }
}
