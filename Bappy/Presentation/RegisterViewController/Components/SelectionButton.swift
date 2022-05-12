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
                        .foregroundColor: UIColor(red: 86.0/255.0, green: 69.0/255.0, blue: 8.0/255.0, alpha: 1.0)
                    ]),
                for: .normal)
            self.backgroundColor = UIColor(red: 245.0/255.0, green: 213.0/255.0, blue: 84.0/255.0, alpha: 1.0)
            self.clipsToBounds = false
        } else {
            self.setAttributedTitle(
                NSAttributedString(
                    string: title,
                    attributes: [
                        .font: UIFont.roboto(size: 14.0),
                        .foregroundColor: UIColor(red: 134.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1.0)
                    ]),
                for: .normal)
            self.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1.0)
            self.clipsToBounds = true
        }
    }
}
