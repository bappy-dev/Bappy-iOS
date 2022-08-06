//
//  NoHangoutsView.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/06.
//

import UIKit
import SnapKit
import RxSwift

final class NoHangoutsView: UIView {
    
    // MARK: Properties
    private let bappyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bappy_sad")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No related hangout results.."
        label.textColor = .bappyBrown
        label.font = .roboto(size: 16.0)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
    }
    
    private func layout() {
        self.addSubview(bappyImageView)
        bappyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(70.0)
            $0.leading.trailing.lessThanOrEqualToSuperview().inset(70.0)
        }
        
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(bappyImageView.snp.bottom).offset(18.0)
            $0.centerX.equalToSuperview()
        }
    }
}

extension NoHangoutsView {
    func shouldHideBappy(_ hide: Bool) {
        bappyImageView.isHidden = hide
        messageLabel.isHidden = hide
    }
}

extension Reactive where Base: NoHangoutsView {
    var hide: Binder<Bool> {
        return Binder(self.base) { base, hide in
            base.shouldHideBappy(hide)
        }
    }
}
