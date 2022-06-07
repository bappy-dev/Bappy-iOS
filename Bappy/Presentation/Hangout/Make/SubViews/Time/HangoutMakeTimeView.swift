//
//  HangoutMakeTimeView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/27.
//

import UIKit
import SnapKit
import MapKit

protocol HangoutMakeTimeViewDelegate: AnyObject {
    
}

final class HangoutMakeTimeView: UIView {
    
    // MARK: Properties
    weak var delegate: HangoutMakeTimeViewDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let timeCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a time\nto meet"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = UIColor(named: "bappy_brown")
        label.numberOfLines = 2
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
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 10.0, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dateButtonHandler), for: .touchUpInside)
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
    
    private lazy var timeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 10.0, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(timeButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let calendarView = BappyCalendarView()
    private let timeView = BappyTimeView()
    private let dividingView: UIView = {
        let dividingView = UIView()
        dividingView.backgroundColor = UIColor(named: "bappy_yellow")
        return dividingView
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
    
    // MARK: Actions
    @objc
    private func dateButtonHandler() {
        UIView.animate(withDuration: 0.4) {
            if !self.dateButton.isSelected {
                self.calendarView.snp.removeConstraints()
                self.calendarView.snp.makeConstraints {
                    $0.top.equalTo(self.dateImageView.snp.bottom).offset(14.5)
                    $0.height.equalTo(self.calendarView.snp.width)
                        .multipliedBy(295.0/292.0)
                }
            } else {
                self.calendarView.snp.removeConstraints()
                self.calendarView.snp.makeConstraints {
                    $0.top.equalTo(self.dateImageView.snp.bottom).offset(14.5)
                    $0.height.equalTo(0)
                }
            }
            self.layoutIfNeeded()
        }
        
        dateButton.isSelected = !dateButton.isSelected
    }
    
    @objc
    private func timeButtonHandler() {
        UIView.animate(withDuration: 0.4) {
            if !self.timeButton.isSelected {
                self.timeView.snp.removeConstraints()
                self.timeView.snp.makeConstraints {
                    $0.top.equalTo(self.timeImageView.snp.bottom).offset(10.0)
                    $0.leading.trailing.equalTo(self.dividingView)
                    $0.height.equalTo(self.timeView.snp.width).multipliedBy(216.0/292.0).offset(20.0)
                }
            } else {
                self.timeView.snp.removeConstraints()
                self.timeView.snp.makeConstraints {
                    $0.top.equalTo(self.timeImageView.snp.bottom).offset(10.0)
                    $0.leading.trailing.equalTo(self.dividingView)
                    $0.height.equalTo(0)
                }
            }
            self.layoutIfNeeded()
        }
        
        timeButton.isSelected = !timeButton.isSelected
    }

    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        self.addSubview(timeCaptionLabel)
        timeCaptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(43.0)
        }
        
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(timeCaptionLabel.snp.bottom).offset(5.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1000.0)
        }
        
        contentView.addSubview(dateImageView)
        dateImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(92.0)
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
            $0.height.equalTo(0)
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
            $0.height.equalTo(0)
//            $0.height.equalTo(timeView.snp.width)
//                .multipliedBy(216.0/292.0).offset(20.0)
            
        }
    }
}
