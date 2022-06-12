//
//  BirthPickerView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/12.
//

import UIKit
import SnapKit

protocol BirthPickerViewDelegate: AnyObject {
    func birthPickerViewDidSelect(birthDate: String)
}

final class BirthPickerView: UIView {
    
    //MARK: Properties
    weak var delegate: BirthPickerViewDelegate?
    
    private var year: String = "2000"
    private var month: String = "07"
    private var day: String = "15"
        
    private var yearList: [String] = Array(1970...2010)
        .map { String($0) }
    private var monthList: [String] = Array(1...12)
        .map { String($0) }
        .map { ($0.count == 1) ? "0\($0)" : $0 }
    private var dayList: [String] = Array(1...31)
        .map { String($0) }
        .map { ($0.count == 1) ? "0\($0)" : $0 }
    
    private lazy var yearPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var monthPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var dayPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(
            NSAttributedString(
                string: "Done",
                attributes: [
                    .font: UIFont.roboto(size: 18.0, family: .Medium),
                    .foregroundColor: UIColor(named: "bappy_brown")!
                ]), for: .normal)
        button.addTarget(self, action: #selector(doneButtonHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        configure()
        selectPickerViewRow(year: year, month: month, day: day, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc
    private func doneButtonHandler() {
        let birth = "\(year)-\(month)-\(day)"
        delegate?.birthPickerViewDidSelect(birthDate: birth)
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionCrossDissolve) {
            self.isHidden = true
        }
    }
    
    // MARK: Helpers
    private func selectPickerViewRow(year: String, month: String, day: String, animated: Bool = false) {
        guard let yearRow = yearList.firstIndex(of: year),
              let monthRow = monthList.firstIndex(of: month),
              let dayRow = dayList.firstIndex(of: day) else { return }
        yearPickerView.selectRow(yearRow, inComponent: 0, animated: animated)
        monthPickerView.selectRow(monthRow, inComponent: 0, animated: animated)
        dayPickerView.selectRow(dayRow, inComponent: 0, animated: animated)
    }
    
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
            $0.centerY.equalToSuperview().offset(-20.0)
            $0.height.equalTo(38.0)
            $0.leading.equalToSuperview().inset(15.0)
            $0.trailing.equalToSuperview().inset(7.0)
        }
        
        self.addSubview(birthStackView)
        birthStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.top.equalTo(birthStackView.snp.bottom)
            $0.centerX.bottom.equalToSuperview()
            $0.height.equalTo(60.0)
        }
    }
}

// MARK: UIPickerViewDataSource, UIPickerViewDelegate
extension BirthPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case yearPickerView: return yearList.count
        case monthPickerView: return monthList.count
        case dayPickerView: return dayList.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case yearPickerView: return yearList[row]
        case monthPickerView: return monthList[row]
        case dayPickerView: return dayList[row]
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews.forEach { $0.backgroundColor = .clear }
        
        let titleList: [String] = ((pickerView == yearPickerView) ? yearList
                                : (pickerView == monthPickerView) ? monthList : dayList)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.text = titleList[row]
            label.font = .roboto(size: 22.0, family: .Regular)
            label.textColor = .black.withAlphaComponent(0.95)
            return label
        }()
        return titleLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("DEBUG: dfasdfasdf")
        let year = yearList[yearPickerView.selectedRow(inComponent: 0)]
        let month = monthList[monthPickerView.selectedRow(inComponent: 0)]
        let day = dayList[dayPickerView.selectedRow(inComponent: 0)]
        let birth = "\(year)-\(month)-\(day)"
        if birth.isValidDateType() {
            self.year = year
            self.month = month
            self.day = day
        } else {
            selectPickerViewRow(year: self.year, month: self.month, day: self.day, animated: true)
        }
    }
}
