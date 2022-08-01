//
//  LanguageSettingCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/02.
//

import UIKit
import SnapKit

final class LanguageSettingCell: UITableViewCell {
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.imageView?.image = UIImage(named: "detail_language")
        self.textLabel?.textColor = .bappyBrown
        self.textLabel?.font = .roboto(size: 18.0, family: .Medium)
        self.selectionStyle = .none
    }
}

// MARK: Bind
extension LanguageSettingCell {
    func bind(with language: Language) {
        self.textLabel?.text = language
    }
}
