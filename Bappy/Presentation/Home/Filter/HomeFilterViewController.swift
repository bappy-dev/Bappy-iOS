//
//  HomeFilterViewController.swift
//  Bappy
//
//  Created by 이현욱 on 2022/10/09.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import FSCalendar

final class HomeFilterViewController: UIViewController {
    
    // MARK: Properties
    let tapGesture = UITapGestureRecognizer()
    private var imageLeading: Constraint!
    private let viewModel: HomeFilterViewModel
    private let disposeBag = DisposeBag()
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date] = []
    
    private let travelButton = SelectionButton(title: "Travel")
    private let studyButton = SelectionButton(title: "Study")
    private let sportsButton = SelectionButton(title: "Sports")
    private let foodButton = SelectionButton(title: "Food")
    private let drinksButton = SelectionButton(title: "Drinks")
    private let cookButton = SelectionButton(title: "Cook")
    private let cultureButton = SelectionButton(title: "Cultural Activities")
    private let volunteerButton = SelectionButton(title: "Volunteer")
    private let languageButton = SelectionButton(title: "Practice Language")
    private let craftingButton = SelectionButton(title: "Crafting")
    
    private let sundayButton = SelectionButton(title: "Sun")
    private let mondayButton = SelectionButton(title: "Mon")
    private let tuesdayButton = SelectionButton(title: "Tue")
    private let wedsdayButton = SelectionButton(title: "Wed")
    private let thursdayButton = SelectionButton(title: "Thu")
    private let fridayButton = SelectionButton(title: "Fri")
    private let satdayButton = SelectionButton(title: "Sat")
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .bappyBrown
        return button
    }()
    
    private let filterTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Filter"
        lbl.textColor = .bappyBrown
        lbl.font = .systemFont(ofSize: 27, weight: .semibold)
        return lbl
    }()
    
    private let dayInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Day"
        lbl.font = .roboto(size: 22, family: .Medium)
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    private let weekInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Week"
        lbl.font = .roboto(size: 22, family: .Medium)
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    private let categoryInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Category"
        lbl.font = .roboto(size: 22, family: .Medium)
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .bappyYellow
        return imageView
    }()
    
    private let nextCalendarPageBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .bappyYellow
        return btn
    }()
    
    private let previousCalendarPageBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .bappyYellow
        return btn
    }()
    
    private lazy var calendar: FSCalendar = {
        let view = FSCalendar()
        view.placeholderType = .none
        view.headerHeight = 46
        view.today = nil
        view.allowsMultipleSelection = true
        view.appearance.weekdayTextColor = .rgb(196, 196, 198, 1)
        view.appearance.weekdayFont = .systemFont(ofSize: 12, weight: .semibold)
        view.appearance.headerTitleFont = .systemFont(ofSize: 14, weight: .semibold)
        view.appearance.headerTitleColor = .black
        view.appearance.headerDateFormat = "MMMM yyyy"
        view.appearance.caseOptions = .weekdayUsesUpperCase
        let calendarSize = UIScreen.main.bounds.width - 58
        view.appearance.headerTitleOffset = CGPoint(x: -(calendarSize / 4) + calendarSize / 28 - 3, y: 0)
        view.appearance.headerTitleAlignment = .left
        view.appearance.headerMinimumDissolvedAlpha = 0
        view.register(CustomCalendarCell.self, forCellReuseIdentifier: CustomCalendarCell.id)
        view.calendarHeaderView.addGestureRecognizer(tapGesture)
        view.contentView.subviews.last?.removeFromSuperview()
        return view
    }()
    
    // MARK: Lifecycle
    init(viewModel: HomeFilterViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
        calendar.delegate = self
        calendar.dataSource = self
        
        for button in [
            travelButton, studyButton, sportsButton,
            foodButton, drinksButton, cookButton,
            cultureButton, volunteerButton,
            languageButton, craftingButton,
            mondayButton, tuesdayButton,
            wedsdayButton, thursdayButton,
            fridayButton, satdayButton, sundayButton
        ] { button.layer.cornerRadius = 19.5 }
    }
    
    private func layout() {
        let seperatView = UIView()
        seperatView.backgroundColor = .bappyGray
        let seperatView2 = UIView()
        seperatView2.backgroundColor = .bappyGray
        let seperatView3 = UIView()
        seperatView3.backgroundColor = .bappyGray
        let seperatView4 = UIView()
        seperatView4.backgroundColor = .bappyGray
        
        let firstSubviews: [UIView] = [travelButton, studyButton, volunteerButton, sportsButton]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [foodButton, drinksButton, languageButton]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        
        let thirdSubviews: [UIView] = [cultureButton, cookButton, craftingButton]
        let thirdHStackView = UIStackView(arrangedSubviews: thirdSubviews)
        
        for stackView in [firstHStackView, secondHStackView, thirdHStackView] {
            stackView.axis = .horizontal
            stackView.spacing = 7.0
        }
        firstHStackView.distribution = .fillProportionally
        secondHStackView.distribution = .fillProportionally
        thirdHStackView.distribution = .fillProportionally
        
        let vStackSubviews: [UIView] = [firstHStackView, secondHStackView, thirdHStackView]
        let vStackView = UIStackView(arrangedSubviews: vStackSubviews)
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 12.0
        
        let weekdayVStackSubviews: [UIView] = [sundayButton, mondayButton, tuesdayButton, wedsdayButton, thursdayButton, fridayButton, satdayButton]
        let weekDayScrollView = UIScrollView()
        weekDayScrollView.showsHorizontalScrollIndicator = false
        let weekVStackView = UIStackView(arrangedSubviews: weekdayVStackSubviews)
        weekVStackView.axis = .horizontal
        weekVStackView.distribution = .fillEqually
        weekVStackView.spacing = 8
        
        weekDayScrollView.addSubview(weekVStackView)
        
        self.view.addSubviews([backButton, filterTitleLbl, dayInfoLbl, seperatView, calendar, imageView, previousCalendarPageBtn, nextCalendarPageBtn, seperatView2, weekInfoLbl, weekDayScrollView, seperatView3, categoryInfoLbl, vStackView])
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15.0)
            $0.leading.equalToSuperview().inset(5.5)
            $0.width.height.equalTo(44.0)
        }
        
        filterTitleLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        dayInfoLbl.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.top.equalTo(filterTitleLbl.snp.bottom).offset(38)
        }
        
        seperatView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(dayInfoLbl.snp.bottom).offset(7)
            $0.leading.equalTo(dayInfoLbl.snp.leading)
            $0.centerX.equalToSuperview()
        }
        
        calendar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().inset(29)
            $0.top.equalTo(seperatView.snp.bottom)
            $0.height.equalTo(calendar.snp.width).multipliedBy(0.84)
        }
        
        imageView.snp.makeConstraints {
            imageLeading = $0.leading.equalToSuperview().inset(20 + UIScreen.main.bounds.width / 3).constraint
            $0.centerY.equalTo(calendar.calendarHeaderView.collectionView.snp.centerY)
            $0.height.equalTo(14)
            $0.width.equalTo(8)
        }
        
        nextCalendarPageBtn.snp.makeConstraints {
            $0.centerY.equalTo(imageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(31)
            $0.width.height.equalTo(30)
        }
        
        previousCalendarPageBtn.snp.makeConstraints {
            $0.trailing.equalTo(nextCalendarPageBtn.snp.leading).offset(-20)
            $0.centerY.equalTo(nextCalendarPageBtn.snp.centerY)
            $0.width.height.equalTo(30)
        }
        
        seperatView2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(calendar.snp.bottom).offset(14)
            $0.leading.equalTo(dayInfoLbl.snp.leading)
            $0.centerX.equalToSuperview()
        }
        
        weekInfoLbl.snp.makeConstraints {
            $0.leading.equalTo(dayInfoLbl.snp.leading)
            $0.top.equalTo(seperatView2.snp.bottom).offset(16)
        }
        
        weekDayScrollView.snp.makeConstraints {
            $0.leading.width.equalToSuperview()
            $0.top.equalTo(weekInfoLbl.snp.bottom).offset(10)
            $0.height.equalTo(32)
        }
        
        weekVStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(1.3)
        }
        
        seperatView3.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(weekDayScrollView.snp.bottom).offset(17)
            $0.leading.equalTo(dayInfoLbl.snp.leading)
            $0.centerX.equalToSuperview()
        }
        
        categoryInfoLbl.snp.makeConstraints {
            $0.leading.equalTo(dayInfoLbl.snp.leading)
            $0.top.equalTo(seperatView3.snp.bottom).offset(16)
        }
        
        vStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(33)
            $0.top.equalTo(categoryInfoLbl.snp.bottom).offset(6)
            $0.height.equalTo(132)
        }
    }
}

extension HomeFilterViewController {
    private func bind() {
        tapGesture.rx.event.bind { _ in
            print("touched")
        }.disposed(by: disposeBag)
        
        Observable.merge(previousCalendarPageBtn.rx.tap.map { -1 }, nextCalendarPageBtn.rx.tap.map { 1 })
            .bind {
                let date = self.calendar.gregorian.date(byAdding: .month, value: $0, to: self.calendar.currentPage)!
                self.calendar.setCurrentPage(date, animated: true)
            }.disposed(by: disposeBag)
        
        let subViewModel = viewModel.subViewModels.calendarViewModel
        
        travelButton.rx.tap
            .bind(to: subViewModel.input.travelButtonTapped)
            .disposed(by: disposeBag)
        studyButton.rx.tap
            .bind(to: subViewModel.input.studyButtonTapped)
            .disposed(by: disposeBag)
        sportsButton.rx.tap
            .bind(to: subViewModel.input.sportsButtonTapped)
            .disposed(by: disposeBag)
        foodButton.rx.tap
            .bind(to: subViewModel.input.foodButtonTapped)
            .disposed(by: disposeBag)
        drinksButton.rx.tap
            .bind(to: subViewModel.input.drinksButtonTapped)
            .disposed(by: disposeBag)
        cookButton.rx.tap
            .bind(to: subViewModel.input.cookButtonTapped)
            .disposed(by: disposeBag)
        cultureButton.rx.tap
            .bind(to: subViewModel.input.cultureButtonTapped)
            .disposed(by: disposeBag)
        volunteerButton.rx.tap
            .bind(to: subViewModel.input.volunteerButtonTapped)
            .disposed(by: disposeBag)
        languageButton.rx.tap
            .bind(to: subViewModel.input.languageButtonTapped)
            .disposed(by: disposeBag)
        craftingButton.rx.tap
            .bind(to: subViewModel.input.craftingButtonTapped)
            .disposed(by: disposeBag)
        
        subViewModel.output.isTravelButtonEnabled
            .drive(travelButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isStudyButtonEnabled
            .drive(studyButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isSportsButtonEnabled
            .drive(sportsButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isFoodButtonEnabled
            .drive(foodButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isDrinksButtonEnabled
            .drive(drinksButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isCookButtonEnabled
            .drive(cookButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isCultureButtonEnabled
            .drive(cultureButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isVolunteerButtonEnabled
            .drive(volunteerButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isLanguageButtonEnabled
            .drive(languageButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isCraftingButtonEnabled
            .drive(craftingButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    
    private func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    private func configureVisibleCells() {
        self.calendar.visibleCells().forEach { (cell) in
            let date = self.calendar.date(for: cell)
            let position = self.calendar.monthPosition(for: cell)
            self.configureCell(cell, for: date, at: position)
        }
    }
    
    private func configureCell(_ cell: FSCalendarCell, for date: Date?, at position: FSCalendarMonthPosition) {
        if let cell = cell as? CustomCalendarCell {
            if position == .current {
                var selectionType = SelectionType.none
                
                if let dateToUse = date, calendar.selectedDates.contains(dateToUse) {
                    let previousDate = calendar.gregorian.date(byAdding: .day, value: -1, to: dateToUse)!
                    let nextDate = calendar.gregorian.date(byAdding: .day, value: 1, to: dateToUse)!
                    
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    } else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(dateToUse) {
                        selectionType = .rightBorder
                    } else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                        
                    } else  {
                        selectionType = .single
                    }
                } else {
                    selectionType = .none
                }
                cell.selectionType = selectionType
            }
        }
    }
}

extension HomeFilterViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let text = calendar.currentPage.toString(dateFormat: "MMMM yyyy")
        UIView.animate(withDuration: 1, delay: 0) {
            self.imageLeading.update(offset: 33 + UILabel.getSize(text).width)
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CustomCalendarCell.id, for: date, at: position) as? CustomCalendarCell else { return FSCalendarCell() }
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureCell(cell, for: date, at: monthPosition)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate == nil { // 아무것도 선택된게 없다
            firstDate = date
            datesRange = [firstDate!]
        } else if firstDate != nil && lastDate == nil { // 처음만 선택되어있다
            if date <= firstDate! { // 나중에 선택한 날짜가 더 앞에 있을 때 -> 처음 선택한 날짜가 lastDate가 되어야 함
                lastDate = firstDate
                firstDate = date
            } else {
                lastDate = date
            }
            
            let range = datesRange(from: firstDate!, to: lastDate!)
            
            for day in range {
                calendar.select(day, scrollToDate: false)
            }
            
            datesRange = range
        } else {
            for day in calendar.selectedDates {
                calendar.deselect(day)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
        }
        
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 3)
    }
}
