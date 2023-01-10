//
//  ProfileReferenceCell.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/19.
//

import UIKit
import SnapKit
import Kingfisher

import RxSwift

extension ProfileReferenceCell {
    static let cellHorizontalInset: CGFloat = 10.0
    static let profileImageViewWidth: CGFloat = 50.0
    static let tagsVerticalSpacing: CGFloat = 6.0
    static let tagsHorizontalSpacing: CGFloat = 10.0
}

final class ProfileReferenceCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    // MARK: Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = ProfileReferenceCell.profileImageViewWidth / 2.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0, family: .Regular)
        label.textColor = .bappyBrown
        return label
    }()
    
    private let tagsView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = ProfileReferenceCell.tagsVerticalSpacing
        return stackView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0, family: .Regular)
        label.textColor = .bappyGray
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 10.0, family: .Regular)
        label.textColor = .bappyGray
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let frameView = UIView()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        frameView.backgroundColor = .white
        frameView.layer.cornerRadius = 9.0
        frameView.clipsToBounds = true
        
        profileImageView.isUserInteractionEnabled = true
    }
    
    private func layout() {
        contentView.addSubview(frameView)
        frameView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(9.0)
            $0.leading.trailing.equalToSuperview().inset(ProfileReferenceCell.cellHorizontalInset)
        }
        
        frameView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.leading.equalToSuperview().inset(ProfileReferenceCell.cellHorizontalInset)
            $0.width.height.equalTo(ProfileReferenceCell.profileImageViewWidth)
        }
        
        frameView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(ProfileReferenceCell.cellHorizontalInset)
        }
        
        frameView.addSubview(tagsView)
        tagsView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(ProfileReferenceCell.cellHorizontalInset)
        }
        
        frameView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(tagsView.snp.bottom).offset(10.0)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(21.0)
            $0.bottom.equalToSuperview().inset(15.0)
        }
        
        frameView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(21.0)
        }
    }
    
    private func addTags(_ tags: [String]) {
        tagsView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        var hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = ProfileReferenceCell.tagsHorizontalSpacing
        
        let maxWidth = ScreenUtil.width
                    - ProfileReferenceCell.cellHorizontalInset * 2.0
                    - ProfileReferenceCell.profileImageViewWidth
                    - ProfileReferenceCell.cellHorizontalInset * 3.0
        var hStackWidth: CGFloat = 0.0
        tags.map { ReferenceTag(tag: $0) }
            .forEach { tagView in
                let tagWidth = tagView.tagWidth
                
                hStackWidth += (tagWidth + ProfileReferenceCell.tagsHorizontalSpacing)
                
                if hStackWidth >= maxWidth {
                    hStack.addArrangedSubview(UIView())
                    hStackWidth = tagWidth
                    let temp = UIStackView()
                    tagsView.addArrangedSubview(temp)
                    temp.axis = .horizontal
                    temp.spacing = ProfileReferenceCell.tagsHorizontalSpacing
                    hStack = temp
                }
                hStack.addArrangedSubview(tagView)
            }
        hStack.addArrangedSubview(UIView())
        tagsView.addArrangedSubview(hStack)
    }
}

// MARK: - Bind
extension ProfileReferenceCell {
    func bind(with referenceCellState: ReferenceCellState) {
        profileImageView.kf.setImage(with: referenceCellState.reference.writerProfileImageURL, placeholder: UIImage(named: "no_profile_l"))
        nameLabel.text = referenceCellState.reference.writerName
        
        addTags(referenceCellState.reference.tags)
        
        dateLabel.text = referenceCellState.reference.date
        contentLabel.text = referenceCellState.reference.contents
        
        if !referenceCellState.reference.isCanRead {
            frameView.bringSubviewToFront(nameLabel)
        }
        
        if referenceCellState.isExpanded {
            contentLabel.numberOfLines = 0
        } else {
            contentLabel.numberOfLines = 3
        }
        
        profileImageView.gestureRecognizers?.forEach({ recognizer in
            profileImageView.removeGestureRecognizer(recognizer)
        })
        let tapGesture = UITapGestureRecognizer()
        profileImageView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .map { _ in referenceCellState.reference.writerID}
            .flatMap(DefaultUserProfileRepository().fetchUserProfile)
            .observe(on: MainScheduler.asyncInstance)
            .compactMap(getValue)
            .subscribe(onNext: { [weak self] user in
                let dependency = ProfileViewModel.Dependency(
                    user: user,
                    authorization: .view)
                let viewController = ProfileViewController(viewModel: ProfileViewModel(dependency: dependency))
                self?.parentViewController?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
