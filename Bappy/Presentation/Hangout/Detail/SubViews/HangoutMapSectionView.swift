//
//  HangoutMapSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import Kingfisher

protocol HangoutMapSectionViewDelegate: AnyObject {
    func showOpenURLView()
}

final class HangoutMapSectionView: UIView {
    
    // MARK: Properties
    weak var delegate: HangoutMapSectionViewDelegate?
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 14.0
        button.clipsToBounds = true
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(openMapURL), for: .touchUpInside)
        return button
    }()
    
//    private let mapImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 14.0
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 12.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.textAlignment = .center
        return label
    }()
    
    private let backgroundView = UIView()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func openMapURL(_ button: UIButton) {
        delegate?.showOpenURLView()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        mapButton.kf.setImage(with: URL(string: example_map_url), for: .normal)
        placeLabel.text = "PNU maingate"
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 15.0
        backgroundView.addBappyShadow(shadowOffsetHeight: 1.0)
    }
    
    private func layout() {
        self.addSubview(mapButton)
        mapButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10.0)
            $0.leading.trailing.equalToSuperview().inset(27.0)
            $0.height.equalTo(mapButton.snp.width).multipliedBy(142.0/336.0)
        }
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-26.0)
            $0.centerX.equalToSuperview()
        }
        
        backgroundView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5.0)
            $0.leading.trailing.equalToSuperview().inset(10.0)
        }
    }
}
