//
//  ProfileReferenceCell.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/19.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileReferenceCell: UITableViewCell {
    
    // MARK: Properties
    var blurEffectView: UIVisualEffectView?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25.0
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
        stackView.spacing = 10.0
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
    }
    
    private func layout() {
        contentView.addSubview(frameView)
        frameView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(9.0)
            $0.leading.equalToSuperview().inset(7.0)
            $0.trailing.equalToSuperview().inset(13.0)
        }
        
        frameView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.leading.equalToSuperview().inset(10.0)
            $0.width.height.equalTo(50.0)
        }
        
        frameView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(7.0)
        }
        
        frameView.addSubview(tagsView)
        tagsView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(10.0)
        }
        
        frameView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(tagsView.snp.bottom).offset(10.0)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(10.0)
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
        
        tagsView.addArrangedSubview(hStack)
        hStack.axis = .horizontal
        hStack.spacing = 10.0
        
        var hStackWidth: CGFloat = 0.0
        tags.map { ReferenceTag(tag: $0) }
            .forEach { tagView in
                let tagWidth = tagView.tagWidth
                
                hStackWidth += (tagWidth + 10.0)
                
                if hStackWidth >= UIScreen.main.bounds.width - 20.0 - 50.0 - 20.0 {
                    hStack.addArrangedSubview(UIView())
                    hStackWidth = tagWidth
                    let temp = UIStackView()
                    tagsView.addArrangedSubview(temp)
                    temp.axis = .horizontal
                    temp.spacing = 10.0
                    hStack = temp
                }
                hStack.addArrangedSubview(tagView)
            }
        hStack.addArrangedSubview(UIView())
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
        
        if referenceCellState.reference.isCanRead {
            blurEffectView?.removeFromSuperview()
            blurEffectView = nil
        } else if blurEffectView == nil {
            var blurEffectView = CustomIntensityVisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.3)
            frameView.addSubview(blurEffectView)
            blurEffectView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.blurEffectView = blurEffectView
        }
        
        if referenceCellState.isExpanded {
            contentLabel.numberOfLines = 0
        } else {
            contentLabel.numberOfLines = 3
        }
    }
}

class CustomIntensityVisualEffectView: UIVisualEffectView {
    // MARK: Properties
    private var animator: UIViewPropertyAnimator!
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
        animator.fractionComplete = intensity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
