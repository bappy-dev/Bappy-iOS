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
    func isTimeValid(_ valid: Bool)
}

final class HangoutMakeTimeView: UIView {
    
    // MARK: Properties
    weak var delegate: HangoutMakeTimeViewDelegate?
    
    private var shouldShowDateView: Bool = false {
        didSet {
            dateDoneButton.isHidden = !shouldShowDateView
            if shouldShowDateView { showDateView() }
            else { hideDateView() }
        }
    }
    private var shouldShowTimeView: Bool = false {
        didSet {
            timeDoneButton.isHidden = !shouldShowTimeView
            if shouldShowTimeView { showTimeView() }
            else { hideTimeView() }
        }
    }
    
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
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 16.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.addTarget(self, action: #selector(dateTextFieldDidBeginEditing), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var dateDoneButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Done",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_yellow")!,
                    .font: UIFont.roboto(size: 14.0, family: .Medium)
                ]), for: .normal)
        button.addTarget(self, action: #selector(dateDoneButtonHandler), for: .touchUpInside)
        button.isHidden = true
        button.backgroundColor = .white
        return button
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "make_time_off")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(size: 16.0)
        textField.textColor = UIColor(named: "bappy_brown")
        textField.addTarget(self, action: #selector(timeTextFieldDidBeginEditing), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var timeDoneButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Done",
                attributes: [
                    .foregroundColor: UIColor(named: "bappy_yellow")!,
                    .font: UIFont.roboto(size: 14.0, family: .Medium)
                ]), for: .normal)
        button.addTarget(self, action: #selector(timeDoneButtonHandler), for: .touchUpInside)
        button.isHidden = true
        button.backgroundColor = .white
        return button
    }()
    
    private let calendarView = BappyCalendarView()
    private let timeView = BappyTimeView()
    private let dividingView = UIView()
    
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
    private func dateTextFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        guard !shouldShowDateView else { return }
        shouldShowDateView = true
        if shouldShowTimeView {
            shouldShowTimeView = false
        }
        timeTextField.text = ""
        timeImageView.image = UIImage(named: "make_time_off")
        delegate?.isTimeValid(false)
    }
    
    @objc
    private func timeTextFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        guard !shouldShowTimeView, let text = dateTextField.text, !text.isEmpty else { return }
        shouldShowTimeView = true
        if shouldShowDateView {
            shouldShowDateView = false
        }
    }
    
    @objc
    private func dateDoneButtonHandler() {
        guard shouldShowDateView else { return }
        shouldShowDateView = false
        shouldShowTimeView = true
        if let text = dateTextField.text, text.isEmpty {
            dateImageView.image = UIImage(named: "make_date_on")
        }

        dateTextField.text = calendarView.date.toString(dateFormat: "M.d (E)")
        timeView.date = calendarView.date
    }
    
    @objc
    private func timeDoneButtonHandler() {
        guard shouldShowTimeView else { return }
        shouldShowTimeView = false
        if let text = timeTextField.text, text.isEmpty {
            timeImageView.image = UIImage(named: "make_time_on")
            delegate?.isTimeValid(true)
        }
        timeTextField.text = timeView.selectedTime
    }

    // MARK: Helpers
    private func showDateView() {
        let topOffset: CGFloat = (scrollView.frame.height + bottomPadding - (dividingView.frame.width * 295.0 / 292.0) - 95.0 - 60.0) / 2.0
        UIView.animate(withDuration: 0.4) {
            self.dateImageView.snp.remakeConstraints {
                $0.top.equalTo(self.contentView).offset(topOffset)
                $0.width.height.equalTo(15.0)
                $0.leading.equalTo(self.contentView).offset(51.0)
            }
            
            self.calendarView.snp.remakeConstraints {
                $0.top.equalTo(self.dateImageView.snp.bottom).offset(14.5)
                $0.height.equalTo(self.calendarView.snp.width)
                    .multipliedBy(295.0/292.0)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func hideDateView() {
        UIView.animate(withDuration: 0.4) {
            self.dateImageView.snp.remakeConstraints {
                $0.top.equalTo(self.contentView).offset(92.0)
                $0.width.height.equalTo(15.0)
                $0.leading.equalTo(self.contentView).offset(51.0)
            }
            
            self.calendarView.snp.remakeConstraints {
                $0.top.equalTo(self.dateImageView.snp.bottom).offset(14.5)
                $0.height.equalTo(0)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func showTimeView() {
        let topOffset: CGFloat = (scrollView.frame.height + bottomPadding - (dividingView.frame.width * 216.0 / 292.0) - 95.0 - 60.0) / 2.0
        UIView.animate(withDuration: 0.4) {
            self.dateImageView.snp.remakeConstraints {
                $0.top.equalTo(self.contentView).offset(topOffset)
                $0.width.height.equalTo(15.0)
                $0.leading.equalTo(self.contentView).offset(51.0)
            }
            
            self.timeView.snp.remakeConstraints {
                $0.top.equalTo(self.timeImageView.snp.bottom).offset(10.0)
                $0.leading.trailing.equalTo(self.dividingView)
                $0.height.equalTo(self.timeView.snp.width).multipliedBy(216.0/292.0).offset(20.0)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func hideTimeView() {
        UIView.animate(withDuration: 0.4) {
            self.dateImageView.snp.remakeConstraints {
                $0.top.equalTo(self.contentView).offset(92.0)
                $0.width.height.equalTo(15.0)
                $0.leading.equalTo(self.contentView).offset(51.0)
            }
            
            self.timeView.snp.remakeConstraints {
                $0.top.equalTo(self.timeImageView.snp.bottom).offset(10.0)
                $0.leading.trailing.equalTo(self.dividingView)
                $0.height.equalTo(0)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func configure() {
        self.backgroundColor = .white
        dividingView.backgroundColor = UIColor(named: "bappy_yellow")
        scrollView.isScrollEnabled = false
        
        let date = Date() + 60 * 70
        let datePlaceholder = date.toString(dateFormat: "M.d (E)")
        var timePlaceholder = date.toString(dateFormat: "a h:mm")
        let startIndex = timePlaceholder.startIndex
        timePlaceholder.insert(".", at: timePlaceholder.index(startIndex, offsetBy: 1))
        timePlaceholder.insert(".", at: timePlaceholder.index(startIndex, offsetBy: 3))
        _ = timePlaceholder.removeLast()
        timePlaceholder.append("0")
        dateTextField.attributedPlaceholder = NSAttributedString(
            string: datePlaceholder,
            attributes: [
                .foregroundColor: UIColor(red: 140.0/255.0, green: 136.0/255.0, blue: 119.0/255.0, alpha: 1.0),
                .font: UIFont.roboto(size: 16.0)])
        timeTextField.attributedPlaceholder = NSAttributedString(
            string: timePlaceholder,
            attributes: [
                .foregroundColor: UIColor(red: 140.0/255.0, green: 136.0/255.0, blue: 119.0/255.0, alpha: 1.0),
                .font: UIFont.roboto(size: 16.0)])
    }
    
    private func layout() {
        let dateTextFieldRightView = UIImageView(image: UIImage(named: "make_chevron_down"))
        let timeTextFieldRightView = UIImageView(image: UIImage(named: "make_chevron_down"))
        
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
        
        self.addSubview(dateImageView)
        dateImageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(92.0)
            $0.width.height.equalTo(15.0)
            $0.leading.equalTo(contentView).offset(51.0)
        }
        
        self.addSubview(dateTextField)
        dateTextField.snp.makeConstraints {
            $0.centerY.equalTo(dateImageView)
            $0.leading.equalTo(dateImageView.snp.trailing).offset(10.0)
            $0.trailing.equalTo(contentView).offset(-49.0)
        }
        
        dateTextField.addSubview(dateTextFieldRightView)
        dateTextFieldRightView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        self.addSubview(dateDoneButton)
        dateDoneButton.snp.makeConstraints {
            $0.centerY.trailing.equalTo(dateTextField)
            $0.height.equalTo(36.0)
        }

        self.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(dateImageView.snp.bottom).offset(14.5)
            $0.height.equalTo(0)
        }
        
        self.addSubview(dividingView)
        dividingView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.equalTo(contentView).offset(42.0)
            $0.trailing.equalTo(contentView).offset(-41.0)
            $0.leading.trailing.equalTo(calendarView)
            $0.height.equalTo(1.0)
        }
        
        self.addSubview(timeImageView)
        timeImageView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(13.5)
            $0.width.height.equalTo(17.0)
            $0.centerX.equalTo(dateImageView)
        }
        
        self.addSubview(timeTextField)
        timeTextField.snp.makeConstraints {
            $0.centerY.equalTo(timeImageView)
            $0.leading.equalTo(timeImageView.snp.trailing).offset(10.0)
            $0.trailing.equalTo(contentView).offset(-49.0)
        }
        
        timeTextField.addSubview(timeTextFieldRightView)
        timeTextFieldRightView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        self.addSubview(timeDoneButton)
        timeDoneButton.snp.makeConstraints {
            $0.centerY.trailing.equalTo(timeTextField)
            $0.height.equalTo(36.0)
        }
        
        self.addSubview(timeView)
        timeView.snp.makeConstraints {
            $0.top.equalTo(timeImageView.snp.bottom).offset(10.0)
            $0.leading.trailing.equalTo(dividingView)
            $0.height.equalTo(0)
        }
    }
}
