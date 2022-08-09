//
//  BappyDropdownCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit

final class BappyDropdownCell: UITableViewCell {
    
    // MARK: Properties
    var text: String = "" {
        didSet { setText(self.text) }
    }
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setBackgroundView()
    }

    // MARK: Helpers
    private func setBackgroundView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear

        let tintedView = UIView()
        tintedView.backgroundColor = .bappyYellow
        tintedView.layer.cornerRadius = 7.0
        tintedView.addBappyShadow(shadowOffsetHeight: 1.0)

        backgroundView.addSubview(tintedView)
        tintedView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2.8)
            $0.bottom.equalToSuperview().inset(3.8)
            $0.leading.trailing.equalToSuperview().inset(1.0)
        }

        self.selectedBackgroundView = backgroundView
    }

    private func configure() {
        self.backgroundColor = .clear
    }
    
    private func setText(_ text: String) {
        self.textLabel?.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.bappyBrown,
                .font: UIFont.roboto(size: 12.0)
            ])
    }
}
