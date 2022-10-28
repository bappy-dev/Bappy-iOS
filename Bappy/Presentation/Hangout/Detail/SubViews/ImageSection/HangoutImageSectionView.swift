//
//  HangoutImageSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class HangoutImageSectionView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutImageSectionViewModel
    private let disposeBag = DisposeBag()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.hangoutDefaultImages.randomElement() as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton = BappyLikeButton()
    
    // MARK: Lifecycle
    init(viewModel: HangoutImageSectionViewModel) {
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
    private func updateImageHeight(_ hegiht: CGFloat) {
        postImageView.snp.updateConstraints {
            $0.height.equalTo(hegiht)
        }
    }
    
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubviews([postImageView, likeButton])
        postImageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 239.0 / 390.0)
        }
        
        likeButton.snp.makeConstraints {
            $0.width.height.equalTo(44.0)
            $0.bottom.equalToSuperview().inset(5.8)
            $0.trailing.equalToSuperview().inset(9.8)
        }
    }
}

// MARK: - Bind
extension HangoutImageSectionView {
    private func bind() {
        likeButton.rx.tap
            .bind(to: viewModel.input.likeButtonTapped)
            .disposed(by: disposeBag)

        viewModel.output.imageURL
            .emit(onNext: { [weak self] url in
                self?.postImageView.kf.setImage(with: url, placeholder: Constant.hangoutDefaultImages.randomElement() as? UIImage)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.image
            .filter { $0 != nil }
            .emit(to: postImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.userHasLiked
            .drive(likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.imageHeight
            .emit(onNext: { [weak self] height in
                self?.updateImageHeight(height)
            })
            .disposed(by: disposeBag)
    }
}
