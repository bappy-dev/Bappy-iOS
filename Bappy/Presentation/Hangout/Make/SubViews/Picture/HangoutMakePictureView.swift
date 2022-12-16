//
//  HangoutMakePictureView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "HangoutPictureCell"
final class HangoutMakePictureView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakePictureViewModel
    private let disposeBag = DisposeBag()
    
    private let pictureCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a picture\nof the place"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let pictureButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .bappyLightgray
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let addPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "make_photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakePictureViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubview(pictureCaptionLabel)
        pictureCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(pictureButton)
        pictureButton.snp.makeConstraints {
            $0.top.equalTo(pictureCaptionLabel.snp.bottom).offset(38.0)
            $0.leading.equalToSuperview().inset(31.0)
            $0.trailing.equalToSuperview().inset(26.0)
            $0.height.equalTo(pictureButton.snp.width).multipliedBy(333.0/390.0)
        }
        
        pictureButton.addSubview(addPictureImageView)
        addPictureImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(28.0)
            $0.height.equalTo(22.0)
        }
    }
}

// MARK: - Bind
extension HangoutMakePictureView {
    private func bind() {
        pictureButton.rx.tap
            .bind(to: viewModel.input.pictureButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.pictureURL
            .emit { [weak self] in
                if $0 != nil {
                    self?.addPictureImageView.isHidden = true
                    self?.pictureButton.kf.setImage(with: $0, for: .normal)
                }
            }.disposed(by: disposeBag)
        
        viewModel.output.picture
            .compactMap { $0 }
            .emit(to: pictureButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.output.hideDefaultImage
            .emit(to: addPictureImageView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
