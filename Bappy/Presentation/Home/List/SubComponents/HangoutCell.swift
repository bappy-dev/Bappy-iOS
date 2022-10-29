//
//  HangoutCell.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import Lottie

final class HangoutCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIdentifier = "HangoutCell"
    
    var state: Hangout.State = .closed {
        didSet { configureState(state) }
    }
    
    private var disposeBag = DisposeBag()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.hangoutDefaultImages.randomElement() as? UIImage
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .bappyLightgray
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 32.0, family: .Bold)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cell_time")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cell_location")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 17.0, family: .Medium)
        label.textColor = .white
        return label
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 17.0, family: .Medium)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let participantsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let participantsImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.isHidden = true
        return imageView
    }()
    
    private let participantsImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let participantsImageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Image 1")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var participantsImageViews: [UIImageView] = [participantsImageView, participantsImageView2, participantsImageView3, participantsImageView4]
    
    private let likeButton = BappyLikeButton()
    private let moreButton = UIButton()
    
    private let transparentView: UIView = {
        let transparentView = UIView()
        transparentView.backgroundColor = .black.withAlphaComponent(0.5)
        transparentView.layer.cornerRadius = 17.0
        return transparentView
    }()
    
    private let disabledImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return imageView
    }()
    
    private let doubleTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 2
        gesture.isEnabled = true
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "like")
        animationView.contentMode = .scaleAspectFit
        animationView.alpha = 0.5
        return animationView
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    // MARK: Animations
    private func playAnimation() {
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.animationView.stop()
        }
    }
    
    // MARK: Helpers
    private func configureState(_ state: Hangout.State) {
        disabledImageView.isHidden = (state == .available)
        if state != .available {
            disabledImageView.image = UIImage(named: "hangout_\(state.rawValue)")
        }
    }
    
    private func configure() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        moreButton.setImage(UIImage(named: "cell_more"), for: .normal)
        contentView.addGestureRecognizer(doubleTapGesture)
    }
    
    private func layout() {
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(11.0)
        }
        
        postImageView.addSubview(transparentView)
        transparentView.snp.makeConstraints {
            $0.bottom.equalTo(postImageView).offset(30.0)
            $0.top.equalTo(postImageView.snp.bottom).offset(-153.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        transparentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.0)
        }
        
        transparentView.addSubview(timeImageView)
        timeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56.3)
            $0.leading.equalToSuperview().inset(23.3)
            $0.width.height.equalTo(16.8)
        }
        
        transparentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImageView.snp.trailing).offset(5.0)
            $0.centerY.equalTo(timeImageView)
        }
        
        transparentView.addSubview(placeImageView)
        placeImageView.snp.makeConstraints {
            $0.top.equalTo(timeImageView.snp.bottom).offset(7.4)
            $0.centerX.equalTo(timeImageView)
            $0.width.equalTo(15.0)
            $0.height.equalTo(18.0)
        }
        
        var before: UIView = titleLabel
        participantsImageViews.forEach { imageView in
            transparentView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.isHidden = true
            imageView.layer.cornerRadius = 16.0
            imageView.clipsToBounds = true
            imageView.snp.makeConstraints {
                $0.bottom.equalTo(postImageView).offset(-13.8)
                $0.width.height.equalTo(32.0)
                if imageView != participantsImageView {
                    $0.leading.equalTo(before.snp.trailing).offset(12.0)
                }
            }
            before = imageView
        }
        
        participantsImageView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel).offset(6.0)
        }
        
        self.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.bottom.equalTo(postImageView).offset(-15.0)
            $0.trailing.equalToSuperview().inset(14.0)
            $0.width.equalTo(140.0)
            $0.height.equalTo(57.0)
        }
        
        transparentView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel)
            $0.trailing.equalTo(moreButton.snp.leading).offset(-8)
            $0.centerY.equalTo(placeImageView)
        }
        
        self.addSubview(likeButton)
        likeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5.0)
            $0.trailing.equalToSuperview().inset(4.0)
            $0.width.height.equalTo(44.0)
        }
        
        contentView.addSubview(disabledImageView)
        disabledImageView.snp.makeConstraints {
            $0.edges.equalTo(postImageView)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(600.0)
        }
    }
}

// MARK: - Methods
extension HangoutCell {
    func bind(_ viewModel: HangoutCellViewModel) {
        moreButton.rx.tap
            .bind(to: viewModel.input.moreButtonTapped)
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .bind(to: viewModel.input.likeButtonTapped)
            .disposed(by: disposeBag)
        
        doubleTapGesture.rx.event
            .map { _ in }
            .bind(to: viewModel.input.doubleTap)
            .disposed(by: disposeBag)
        
        viewModel.output.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.time
            .drive(timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.place
            .drive(placeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.userHasLiked
            .drive(likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.joinedUsers
            .drive(onNext: { [weak self] infos in
                for idx in 0..<4 {
                    self?.participantsImageViews[idx].isHidden = true
                }
                
                for idx in 0..<infos.count {
                    if idx == 3 {
                        self?.participantsImageView4.image = UIImage(named: "Image 1")
                        self?.participantsImageView4.isHidden = false
                        return
                    }
                    self?.participantsImageViews[idx].kf.setImage(with: infos[idx].imageURL, placeholder: UIImage(named: "profile_default"))
                    self?.participantsImageViews[idx].isHidden = false
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.state
            .compactMap { $0 }
            .drive(self.rx.state)
            .disposed(by: disposeBag)
        
        viewModel.output.postImageURL
            .compactMap { $0 }
            .drive(onNext: { [weak self] url in
                self?.postImageView.kf.setImage(with: url, placeholder: Constant.hangoutDefaultImages.randomElement() as? UIImage)
            }).disposed(by: disposeBag)
        
        viewModel.output.showAnimation
            .emit(onNext: { [weak self] _ in
                self?.playAnimation()
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: HangoutCell {
    var state: Binder<Hangout.State> {
        return Binder(self.base) { base, state in
            base.state = state
        }
    }
}
