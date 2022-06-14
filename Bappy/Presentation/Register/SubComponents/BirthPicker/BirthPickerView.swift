//
//  BirthPickerView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthPickerView: UIView {
    
    //MARK: Properties
    private let viewModel: BirthPickerViewModel
    private let disposeBag = DisposeBag()
    
    private let yearPickerView = UIPickerView()
    private let monthPickerView = UIPickerView()
    private let dayPickerView = UIPickerView()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Done",
                attributes: [
                    .font: UIFont.roboto(size: 18.0, family: .Medium),
                    .foregroundColor: UIColor(named: "bappy_brown")!
                ]), for: .normal)
        return button
    }()
    
    // MARK: Lifecycle
    init(viewModel: BirthPickerViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        layout()
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5.0
        self.addBappyShadow(shadowOffsetHeight: 3.5)
    }
    
    private func layout() {
        let selectView = UIView()
        selectView.layer.cornerRadius = 10.0
        selectView.backgroundColor = UIColor(red: 241.0/255.0, green: 209.0/255.0, blue: 83.0/255.0, alpha: 1.0)
        
        let birthStackView = UIStackView(arrangedSubviews: [
            yearPickerView, monthPickerView, dayPickerView
        ])
        birthStackView.axis = .horizontal
        birthStackView.spacing = 0
        birthStackView.distribution = .fillEqually
        
        self.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.height.equalTo(38.0)
            $0.leading.equalToSuperview().inset(15.0)
            $0.trailing.equalToSuperview().inset(7.0)
        }
        
        self.addSubview(birthStackView)
        birthStackView.snp.makeConstraints {
            $0.centerY.equalTo(selectView)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.top.equalTo(birthStackView.snp.bottom)
            $0.centerX.bottom.equalToSuperview()
            $0.height.equalTo(50.0)
        }
    }
}

// MARK: - Bind
extension BirthPickerView {
    private func bind() {
        doneButton.rx.tap
            .bind(to: viewModel.input.doneButtonTapped)
            .disposed(by: disposeBag)
        
        yearPickerView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.input.selectedYearRow)
            .disposed(by: disposeBag)
        
        monthPickerView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.input.selectedMonthRow)
            .disposed(by: disposeBag)
        
        dayPickerView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.input.selectedDayRow)
            .disposed(by: disposeBag)
        
        viewModel.output.yearList
            .drive(yearPickerView.rx.items) { [yearPickerView] _, title, _ in
                yearPickerView.subviews.forEach { $0.backgroundColor = .clear }
                return createTitleLabel(title: title)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.monthList
            .drive(monthPickerView.rx.items) { [monthPickerView] _, title, _ in
                monthPickerView.subviews.forEach { $0.backgroundColor = .clear }
                return createTitleLabel(title: title)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.dayList
            .drive(dayPickerView.rx.items) { [dayPickerView] _, title, _ in
                dayPickerView.subviews.forEach { $0.backgroundColor = .clear }
                return createTitleLabel(title: title)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.yearRow
            .bind(to: yearPickerView.rx.selectRow)
            .disposed(by: disposeBag)
        
        viewModel.output.monthRow
            .bind(to: monthPickerView.rx.selectRow)
            .disposed(by: disposeBag)
        
        viewModel.output.dayRow
            .bind(to: dayPickerView.rx.selectRow)
            .disposed(by: disposeBag)

        
        viewModel.output.shouldHide
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.transition(with: self,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve) {
                    self.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Binder
extension Reactive where Base: UIPickerView {
    var selectRow: Binder<(row: Int, component: Int)> {
        return Binder(self.base) { pickerView, index in
            pickerView.selectRow(index.row, inComponent: index.component, animated: true)
        }
    }
}

private func createTitleLabel(title: String) -> UILabel {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = title
        label.font = .roboto(size: 22.0, family: .Regular)
        label.textColor = .black.withAlphaComponent(0.95)
        return label
    }()
    return titleLabel
}
