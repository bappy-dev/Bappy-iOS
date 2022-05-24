//
//  SortingHeaderView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/20.
//

import UIKit
import SnapKit

final class SortingHeaderView: UIView {
    
    // MARK: Properties
    private let sortingButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Newest",
                attributes: [
                    .font: UIFont.roboto(size: 12.0),
                    .foregroundColor: UIColor(named: "bappy_brown")!
                ]),
            for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = UIColor(named: "bappy_lightgray")
    }
    
    private func layout() {
        self.addSubview(sortingButton)
        sortingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(29.0)
        }
        
        let sortingButtonImage = UIImage(systemName: "arrowtriangle.down.fill")
        let sortingButtonImageView = UIImageView(image: sortingButtonImage)
        sortingButtonImageView.tintColor = UIColor(named: "bappy_yellow")
        sortingButton.addSubview(sortingButtonImageView)
        sortingButtonImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(7.0)
            $0.width.equalTo(8.0)
            $0.height.equalTo(10.0)
            $0.trailing.equalToSuperview().inset(-12.0)
        }
    }
}
