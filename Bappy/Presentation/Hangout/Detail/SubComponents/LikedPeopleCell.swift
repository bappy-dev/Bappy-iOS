//
//  LikedPeopleCell.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/01.
//

import UIKit

class LikedPeopleCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseIndentifier = "LikedPeopleCell"
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 23.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userIDLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .roboto(size: 20, family: .Medium)
        lbl.lineBreakMode = .byTruncatingTail
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.forward")
        return imageView
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        setBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.selectionStyle = .none
    }
    
    private func setBackgroundView() {
        self.addSubviews([userImageView, userIDLbl, nextImageView])
        
        userImageView.snp.makeConstraints {
            $0.height.width.equalTo(47)
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        userIDLbl.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(9)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(nextImageView.snp.leading).offset(-20)
        }
        
        nextImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
    
    func bind(_ info: Hangout.Info) {
        userImageView.kf.setImage(with: info.imageURL, placeholder: UIImage(named: "hangout_no_profile"))
        userIDLbl.text = info.id
    }
}
