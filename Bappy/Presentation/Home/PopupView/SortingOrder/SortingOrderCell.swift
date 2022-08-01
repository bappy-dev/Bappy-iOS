//
//  SortingOrderCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import SnapKit

final class SortingOrderCell: UITableViewCell {
    
    // MARK: Properties
    var text: String = "" {
        didSet { self.textLabel?.text = text }
    }
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setBackgroundView()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    private func setBackgroundView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear

        let tintedView = UIView()
        tintedView.backgroundColor = .bappyYellow
        tintedView.layer.cornerRadius = 15.5
        tintedView.addBappyShadow(shadowOffsetHeight: 1.0)

        backgroundView.addSubview(tintedView)
        tintedView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2.8)
            $0.bottom.equalToSuperview().inset(3.8)
            $0.leading.trailing.equalToSuperview().inset(10.0)
        }
        
        self.selectedBackgroundView = backgroundView
    }

    private func configure() {
        self.backgroundColor = .clear
        self.textLabel?.textColor = .bappyBrown
        self.textLabel?.textAlignment = .center
    }
}
