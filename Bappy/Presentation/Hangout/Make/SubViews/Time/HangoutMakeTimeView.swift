//
//  HangoutMakeTimeView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HangoutMakeTimeView: UIView {
    
    // MARK: Properties
    private let viewModel: HangoutMakeTimeViewModel
    private let disposeBag = DisposeBag()
    
    private let timeCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a time\nto meet"
        label.font = .roboto(size: 36.0, family: .Bold)
        label.textColor = .bappyBrown
        label.numberOfLines = 2
        return label
    }()
    
    private let dateDoneButton: UIButton = {
        let button = UIButton()
        button.setBappyTitle(
            title: "Done",
            font: .roboto(size: 18.0, family: .Black),
            color: .bappyYellow)
        button.isHidden = true
        button.backgroundColor = .white
        return button
    }()
    
    private let timeDoneButton: UIButton = {
        let button = UIButton()
        button.setBappyTitle(
            title: "Done",
            font: .roboto(size: 18.0, family: .Black),
            color: .bappyYellow)
        button.isHidden = true
        button.backgroundColor = .white
        return button
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dateImageView = UIImageView()
    private let dateTextField = UITextField()
    private let timeImageView = UIImageView()
    private let timeTextField = UITextField()
    private let calendarView: HangoutMakeCalendarPickerView
    private let timeView: HangoutMakeTimePickerView
    private let dividingView = UIView()
    
    // MARK: Lifecycle
    init(viewModel: HangoutMakeTimeViewModel) {
        let calendarViewModel = viewModel.subViewModels.calendarPickerViewModel
        let timeViewModel = viewModel.subViewModels.timePickerViewModel
        
        self.viewModel = viewModel
        self.calendarView = HangoutMakeCalendarPickerView(viewModel: calendarViewModel)
        self.timeView = HangoutMakeTimePickerView(viewModel: timeViewModel)
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    private func showDateView() {
        let topOffset: CGFloat = (scrollView.frame.height + bottomPadding - (dividingView.frame.width * 295.0 / 292.0) - 95.0 - 60.0) / 2.0
        UIView.animate(withDuration: 0.4) {
            self.dateImageView.snp.updateConstraints {
                $0.top.equalTo(self.contentView).offset(topOffset)
            }
            
            self.calendarView.snp.updateConstraints {
                $0.height.equalTo(self.calendarView.frame.width * 295.0/292.0)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    private func hideDateView() {
        UIView.animate(withDuration: 0.4) {
            self.dateImageView.snp.updateConstraints {
                $0.top.equalTo(self.contentView).offset(92.0)
            }
            
            self.calendarView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    private func showTimeView() {
        let topOffset: CGFloat = (scrollView.frame.height + bottomPadding - (dividingView.frame.width * 216.0 / 292.0) - 95.0 - 60.0) / 2.0
        UIView.animate(withDuration: 0.4) {
            self.dateImageView.snp.updateConstraints {
                $0.top.equalTo(self.contentView).offset(topOffset)
            }
            
            self.timeView.snp.updateConstraints {
                $0.top.equalTo(self.timeImageView.snp.bottom).offset(10.0)
                $0.leading.trailing.equalTo(self.dividingView)
                $0.height.equalTo(self.timeView.frame.width * 216.0/292.0 + 20.0)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    private func hideTimeView() {
        UIView.animate(withDuration: 0.4) {
            self.dateImageView.snp.updateConstraints {
                $0.top.equalTo(self.contentView).offset(92.0)
            }
            
            self.timeView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    private func initCalendarDate(_ date: String) {
        dateTextField.text = date
        dateTextField.textColor = .rgb(140, 136, 119, 1)
        dateImageView.image = UIImage(named: "make_date_off")
    }
    
    private func initTimeDate(_ date: String) {
        timeTextField.text = date
        timeTextField.textColor = .rgb(140, 136, 119, 1)
        timeImageView.image = UIImage(named: "make_time_off")
    }
    
    private func setValidCalendarState() {
        dateTextField.textColor = .bappyBrown
        dateImageView.image = UIImage(named: "make_date_on")
    }
    
    private func setValidTimeState() {
        timeTextField.textColor = .bappyBrown
        timeImageView.image = UIImage(named: "make_time_on")
    }
    
    private func configure() {
        self.backgroundColor = .white
        dividingView.backgroundColor = .bappyYellow
        scrollView.isScrollEnabled = false
        dateTextField.font = .roboto(size: 16.0)
        timeTextField.font = .roboto(size: 16.0)
        dateImageView.contentMode = .scaleAspectFit
        timeImageView.contentMode = .scaleAspectFit
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

// MARK: - Bind
extension HangoutMakeTimeView {
    private func bind() {
        dateTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.dateEditingDidBegin)
            .disposed(by: disposeBag)
        
        timeTextField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.timeEditingDidBegin)
            .disposed(by: disposeBag)
        
        dateDoneButton.rx.tap
            .bind(to: viewModel.input.dateDoneButtonTapped)
            .disposed(by: disposeBag)
        
        timeDoneButton.rx.tap
            .bind(to: viewModel.input.timeDoneButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.dateDoneButtonTapped
            .emit(onNext: { [weak self] _ in self?.setValidCalendarState() })
            .disposed(by: disposeBag)
        
        viewModel.output.timeDoneButtonTapped
            .emit(onNext: { [weak self] _ in self?.setValidTimeState() })
            .disposed(by: disposeBag)
        
        viewModel.output.dismissKeyboardFromDate
            .emit(to: dateTextField.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.dismissKeyboardFormTime
            .emit(to: timeTextField.rx.endEditing)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldShowDateView
            .distinctUntilChanged()
            .drive(onNext: { [weak self] shouldShow in
                self?.dateDoneButton.isHidden = !shouldShow
                if shouldShow { self?.showDateView() }
                else { self?.hideDateView() }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.shouldShowTimeView
            .distinctUntilChanged()
            .drive(onNext: { [weak self] shouldShow in
                self?.timeDoneButton.isHidden = !shouldShow
                if shouldShow { self?.showTimeView() }
                else { self?.hideTimeView() }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.initCalendarDate
            .drive(onNext: { [weak self] date in
                self?.initCalendarDate(date) })
            .disposed(by: disposeBag)
        
        viewModel.output.initTimeDate
            .drive(onNext: { [weak self] date in
                self?.initTimeDate(date) })
            .disposed(by: disposeBag)
        
        viewModel.output.calendarText
            .drive(dateTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.timeText
            .drive(timeTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
