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

protocol HangoutMakePictureViewDelegate: AnyObject {
    func addPhoto()
}

private let reuseIdentifier = "HangoutPictureCell"
final class HangoutMakePictureView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakePictureViewModel
    private let disposeBag = DisposeBag()
    
    weak var delegate: HangoutMakePictureViewDelegate?
    
    var selectedImage: UIImage? {
        didSet {
            guard let selectedImage = selectedImage else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.addPictureImageView.isHidden = true
                self.pictureButton.setImage(selectedImage, for: .normal)
            }
        }
    }
    
    private let pictureCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a picture\nof the place"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var pictureButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .bappyLightgray
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(pictureButtonHandler), for: .touchUpInside)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func pictureButtonHandler() {
        delegate?.addPhoto()
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
