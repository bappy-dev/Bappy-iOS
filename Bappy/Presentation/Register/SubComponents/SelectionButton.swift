//
//  SelectionButton.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/11.
//

import UIKit

final class SelectionButton: UIButton {
    
    // MARK: Properties
    var isButtonSelected: Bool = false {
        didSet { updateButton() }
    }
    
    private let title: String
    
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
        updateButton()
    }
    
    private func updateButton() {
        if isButtonSelected {
            self.setAttributedTitle(
                NSAttributedString(
                    string: title,
                    attributes: [
                        .font: UIFont.roboto(size: 14.0),
                        .foregroundColor: UIColor(named: "bappy_brown")!
                    ]),
                for: .normal)
            self.backgroundColor = UIColor(named: "bappy_yellow")
            self.clipsToBounds = false
        } else {
            self.setAttributedTitle(
                NSAttributedString(
                    string: title,
                    attributes: [
                        .font: UIFont.roboto(size: 14.0),
                        .foregroundColor: UIColor(named: "bappy_gray")!
                    ]),
                for: .normal)
            self.backgroundColor = UIColor(named: "bappy_lightgray")
            self.clipsToBounds = true
        }
    }
}
