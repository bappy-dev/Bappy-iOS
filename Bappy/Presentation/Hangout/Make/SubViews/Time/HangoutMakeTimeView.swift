//
//  HangoutMakeTimeView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/27.
//

import UIKit
import SnapKit
import MapKit

final class HangoutMakeTimeView: UIView {
    
    // MARK: Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let timeCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "When do you wanna meet up?"
        label.font = .roboto(size: 18.0, family: .Medium)
        label.textColor = UIColor(named: "bappy_brown")
        return label
    }()

    private let asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = .roboto(size: 18.0)
        label.textColor = UIColor(named: "bappy_yellow")
        return label
    }()

    private let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "make_date_off")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "5.25 (Wed)"
        label.textColor = UIColor(red: 140.0/255.0, green: 136.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        label.font = .roboto(size: 14.0)
        return label
    }()
    
    private let dateButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 10.0, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "make_time_off")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "P.M. 6:00"
        label.textColor = UIColor(red: 140.0/255.0, green: 136.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        label.font = .roboto(size: 14.0)
        return label
    }()
    
    private let timeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 10.0, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let calendarView = BappyCalendarView()
    private let timeView = BappyTimeView()

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
        self.backgroundColor = .white
    }
    
    private func layout() {
        let vStackView = UIStackView(arrangedSubviews: [asteriskLabel])
        vStackView.alignment = .top
        let hStackView = UIStackView(arrangedSubviews: [timeCaptionLabel, vStackView])
        hStackView.spacing = 3.0
        hStackView.alignment = .fill
        hStackView.axis = .horizontal
        
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(named: "bappy_yellow")

        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1000.0)
        }

        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(39.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30.0)
        }
        
        contentView.addSubview(dateImageView)
        dateImageView.snp.makeConstraints {
            $0.top.equalTo(hStackView.snp.bottom).offset(37.0)
            $0.width.height.equalTo(15.0)
            $0.leading.equalToSuperview().inset(51.0)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateImageView)
            $0.leading.equalTo(dateImageView.snp.trailing).offset(10.0)
        }
        
        contentView.addSubview(dateButton)
        dateButton.snp.makeConstraints {
            $0.centerY.equalTo(dateImageView)
            $0.width.height.equalTo(44.0)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(10.0)
            $0.trailing.equalToSuperview().inset(34.0)
        }
        
        contentView.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(dateImageView.snp.bottom).offset(14.5)
        }
        
        contentView.addSubview(dividingView)
        dividingView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.equalToSuperview().inset(42.0)
            $0.trailing.equalToSuperview().inset(41.0)
            $0.leading.trailing.equalTo(calendarView)
            $0.height.equalTo(1.0)
        }
        
        contentView.addSubview(timeImageView)
        timeImageView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(13.5)
            $0.width.height.equalTo(17.0)
            $0.centerX.equalTo(dateImageView)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeImageView)
            $0.leading.equalTo(timeImageView.snp.trailing).offset(10.0)
        }
        
        contentView.addSubview(timeButton)
        timeButton.snp.makeConstraints {
            $0.centerY.equalTo(timeImageView)
            $0.width.height.equalTo(44.0)
            $0.leading.equalTo(timeLabel.snp.trailing).offset(10.0)
            $0.trailing.equalToSuperview().inset(34.0)
        }
        
        contentView.addSubview(timeView)
        timeView.snp.makeConstraints {
            $0.top.equalTo(timeImageView.snp.bottom).offset(10.0)
            $0.leading.trailing.equalTo(dividingView)
        }
    }
}
