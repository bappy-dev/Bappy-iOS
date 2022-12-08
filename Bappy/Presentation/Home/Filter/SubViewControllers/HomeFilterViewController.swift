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
    var isNotSelected = false
    let tapGesture = UITapGestureRecognizer()
    private var imageLeading: Constraint!
    private let viewModel: HomeFilterViewModel
    private let disposeBag = DisposeBag()
    private var firstdateob = BehaviorSubject<Date?>(value: nil)
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date] = []
    
    private let travelButton = SelectionButton(title: "Travel")
    private let cafeButton = SelectionButton(title: "Cafe")
    private let hikingButton = SelectionButton(title: "Hiking")
    private let foodButton = SelectionButton(title: "Food")
    private let barButton = SelectionButton(title: "Bar")
    private let cookButton = SelectionButton(title: "Cook")
    private let shoppingButton = SelectionButton(title: "Shopping")
    private let volunteerButton = SelectionButton(title: "Volunteer")
    private let languageButton = SelectionButton(title: "Practice Language")
    private let craftingButton = SelectionButton(title: "Crafting")
    private let ballGameButton = SelectionButton(title: "Ball Game")
    private let runningButton = SelectionButton(title: "Running")
    private let concertsButton = SelectionButton(title: "Concerts")
    private let museumButton = SelectionButton(title: "Museum")
    private let veganButton = SelectionButton(title: "Vegan")
    private let boardgameButton = SelectionButton(title: "Boardgame")
    private let musicButton = SelectionButton(title: "Music")
    
    private let sundayButton = SelectionButton(title: "Sun")
    private let mondayButton = SelectionButton(title: "Mon")
    private let tuesdayButton = SelectionButton(title: "Tue")
    private let wedsdayButton = SelectionButton(title: "Wed")
    private let thursdayButton = SelectionButton(title: "Thu")
    private let fridayButton = SelectionButton(title: "Fri")
    private let satdayButton = SelectionButton(title: "Sat")
    
    private let englishButton = SelectionButton(title: "English")
    private let koreanButton = SelectionButton(title: "Korean")
    private let japaneseButton = SelectionButton(title: "Japanese")
    private let chineseButton = SelectionButton(title: "Chinese")
    
    private let scrollView = UIScrollView()
    private var year: [Int] = []
    private let month: [String] = ["January", "February", "March", "April", "May","June", "July", "August", "September", "October", "November", "December"]
    
    private let pickerView: UIPickerView = {
        let view = UIPickerView()
        view.isHidden = true
        view.backgroundColor = .white
        return view
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
        lbl.font = .roboto(size: 20, family: .Medium)
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    private let categoryInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Category"
        lbl.font = .roboto(size: 20, family: .Medium)
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    private let languageInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Language"
        lbl.font = .roboto(size: 20, family: .Medium)
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    private let moreBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("More", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .bappyBrown
        btn.setTitleColor(.bappyBrown, for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.titleLabel?.font = .roboto(size: 14, family: .Regular)
        btn.imageEdgeInsets = UIEdgeInsets(top: 4, left: 2, bottom: 4, right: 2)
        return btn
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
        let calendarSize = ScreenUtil.width - 58
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
        setAvailableDate()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("HomeFilterViewController deinit")
    }
    
    // MARK: Helpers
    private func configure() {
        //        self.isModalInPresentation = true
        view.backgroundColor = .white
        calendar.delegate = self
        calendar.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        
        for button in [
            travelButton, cafeButton, hikingButton,
            foodButton, barButton, cookButton,
            shoppingButton, volunteerButton,
            languageButton, craftingButton,
            mondayButton, tuesdayButton,
            wedsdayButton, thursdayButton,
            fridayButton, satdayButton, sundayButton,
            englishButton, koreanButton,
            japaneseButton, chineseButton,
            ballGameButton, runningButton, concertsButton,
            museumButton, veganButton,
            boardgameButton, musicButton
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
        
        let firstSubviews: [UIView] = [travelButton, cafeButton, volunteerButton, hikingButton]
        let firstHStackView = UIStackView(arrangedSubviews: firstSubviews)
        
        let secondSubviews: [UIView] = [foodButton, barButton, languageButton]
        let secondHStackView = UIStackView(arrangedSubviews: secondSubviews)
        
        let thirdSubviews: [UIView] = [shoppingButton, musicButton, cookButton, craftingButton]
        let thirdHStackView = UIStackView(arrangedSubviews: thirdSubviews)
        
        let fourthSubviews: [UIView] = [ballGameButton, veganButton, runningButton]
        let fourthHStackView = UIStackView(arrangedSubviews: fourthSubviews)
        
        let fifthSubviews: [UIView] = [concertsButton, museumButton,  boardgameButton]
        let fifthHStackView = UIStackView(arrangedSubviews: fifthSubviews)
        
        for stackView in [firstHStackView, secondHStackView, thirdHStackView, fourthHStackView, fifthHStackView] {
            stackView.axis = .horizontal
            stackView.spacing = 7.0
        }
        firstHStackView.distribution = .fillProportionally
        secondHStackView.distribution = .fillProportionally
        thirdHStackView.distribution = .fillProportionally
        fourthHStackView.distribution = .fillProportionally
        fifthHStackView.distribution = .fillProportionally
        
        let vStackSubviews: [UIView] = [firstHStackView, secondHStackView, thirdHStackView,  fourthHStackView, fifthHStackView]
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
        
        let languageVStackSubview: [UIView] = [englishButton, koreanButton, japaneseButton, chineseButton]
        let languageVStackView = UIStackView(arrangedSubviews: languageVStackSubview)
        languageVStackView.axis = .horizontal
        languageVStackView.distribution = .fillProportionally
        languageVStackView.spacing = 8
        
        let baseView = UIView()
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(baseView)
        baseView.addSubviews([dayInfoLbl, seperatView, calendar, imageView, previousCalendarPageBtn, nextCalendarPageBtn, seperatView2, pickerView, weekInfoLbl, weekDayScrollView, seperatView3, categoryInfoLbl, vStackView, seperatView4, languageInfoLbl, moreBtn, languageVStackView])
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        dayInfoLbl.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.top.equalToSuperview().inset(5)
            $0.height.equalTo(26)
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
            imageLeading = $0.leading.equalToSuperview().inset(20 + ScreenUtil.width / 3).constraint
            $0.centerY.equalTo(calendar.calendarHeaderView.collectionView.snp.centerY)
            $0.height.equalTo(14)
            $0.width.equalTo(8)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.bottom.equalTo(calendar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(29)
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
            $0.height.equalTo(23.67)
        }
        
        weekDayScrollView.snp.makeConstraints {
            $0.leading.width.equalToSuperview()
            $0.top.equalTo(weekInfoLbl.snp.bottom).offset(10)
            $0.height.equalTo(38)
        }
        
        weekVStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(37)
            $0.height.equalTo(36)
            $0.top.equalToSuperview()
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
            $0.height.equalTo(23.67)
        }
        
        vStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(33)
            $0.top.equalTo(categoryInfoLbl.snp.bottom).offset(6)
            $0.height.equalTo(39 * vStackSubviews.count + 12 * (vStackSubviews.count - 1))
        }
        
        seperatView4.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.bottom).offset(16)
            $0.leading.equalTo(dayInfoLbl.snp.leading)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        languageInfoLbl.snp.makeConstraints {
            $0.top.equalTo(seperatView4.snp.bottom).offset(21)
            $0.leading.equalTo(dayInfoLbl.snp.leading)
            $0.height.equalTo(23.67)
        }
        
        moreBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(29)
            $0.bottom.equalTo(languageInfoLbl.snp.bottom)
        }
        
        languageVStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(29)
            $0.height.equalTo(36)
            $0.top.equalTo(languageInfoLbl.snp.bottom).offset(13)
            $0.bottom.equalToSuperview().inset(26)
        }
    }
    
    func setAvailableDate() {
        /// 선택 가능한 연도 설정
        let formatterYear = DateFormatter()
        formatterYear.dateFormat = "yyyy"
        let todayYear = Int(formatterYear.string(from: Date()))!
        
        for y in (todayYear - 50)...(todayYear + 50) {
            year.append(y)
        }
        pickerView.selectRow(9, inComponent: 0, animated: false)
        pickerView.selectRow(50, inComponent: 1, animated: false)
    }
}

extension HomeFilterViewController {
    private func bind() {
        tapGesture.rx.event.bind { [weak self] _ in
            let isNotSelected = self?.isNotSelected ?? true
            
            self?.calendar.appearance.headerTitleColor = isNotSelected ? .black : .bappyYellow
            self?.pickerView.isHidden = isNotSelected
            self?.previousCalendarPageBtn.isHidden = !isNotSelected
            self?.nextCalendarPageBtn.isHidden = !isNotSelected
            UIView.animate(withDuration: 0.5, delay: 0) {
                self?.imageView.transform = CGAffineTransform(rotationAngle: isNotSelected ? 0 :  1.57)
            }
            
            self?.isNotSelected.toggle()
        }.disposed(by: disposeBag)
        
        Observable.merge(previousCalendarPageBtn.rx.tap.map { -1 }, nextCalendarPageBtn.rx.tap.map { 1 })
            .bind { [weak self] value in
                guard let `self` = self else { return }
                let date = self.calendar.gregorian.date(byAdding: .month, value: value, to: self.calendar.currentPage)!
                self.calendar.setCurrentPage(date, animated: true)
            }.disposed(by: disposeBag)
        
        let subViewModel = viewModel.subViewModels.hangoutMakeCategoryViewModel
        
        self.rx.viewWillAppear
            .take(1)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let startDate = Date().startOfMonth()
                let lastDate = Date().endOfMonth()
                let range = self.datesRange(from: startDate, to: lastDate)
                
                for day in range {
                    self.calendar.select(day, scrollToDate: false)
                }
            
                self.firstDate = startDate
                self.lastDate = lastDate
                self.datesRange = range
                self.configureVisibleCells()
                self.viewModel.input.dateSelected.onNext((startDate, lastDate))
            }.disposed(by: disposeBag)

        sundayButton.rx.tap
            .bind(to: viewModel.input.sundayButtonTapped)
            .disposed(by: disposeBag)
        mondayButton.rx.tap
            .bind(to: viewModel.input.mondayButtonTapped)
            .disposed(by: disposeBag)
        tuesdayButton.rx.tap
            .bind(to: viewModel.input.tuesdayButtonTapped)
            .disposed(by: disposeBag)
        wedsdayButton.rx.tap
            .bind(to: viewModel.input.wedsdayButtonTapped)
            .disposed(by: disposeBag)
        thursdayButton.rx.tap
            .bind(to: viewModel.input.thursdayButtonTapped)
            .disposed(by: disposeBag)
        fridayButton.rx.tap
            .bind(to: viewModel.input.fridayButtonTapped)
            .disposed(by: disposeBag)
        satdayButton.rx.tap
            .bind(to: viewModel.input.satdayButtonTapped)
            .disposed(by: disposeBag)
        koreanButton.rx.tap
            .bind(to: viewModel.input.koreanButtonTapped)
            .disposed(by: disposeBag)
        japaneseButton.rx.tap
            .bind(to: viewModel.input.japaneseButtonTapped)
            .disposed(by: disposeBag)
        chineseButton.rx.tap
            .bind(to: viewModel.input.chineseButtonTapped)
            .disposed(by: disposeBag)
        englishButton.rx.tap
            .bind(to: viewModel.input.englishButtonTapped)
            .disposed(by: disposeBag)
        moreBtn.rx.tap
            .bind(to: viewModel.input.moreButtonTapped)
            .disposed(by: disposeBag)
        travelButton.rx.tap
            .bind(to: subViewModel.input.travelButtonTapped)
            .disposed(by: disposeBag)
        cafeButton.rx.tap
            .bind(to: subViewModel.input.cafeButtonTapped)
            .disposed(by: disposeBag)
        hikingButton.rx.tap
            .bind(to: subViewModel.input.hikingButtonTapped)
            .disposed(by: disposeBag)
        foodButton.rx.tap
            .bind(to: subViewModel.input.foodButtonTapped)
            .disposed(by: disposeBag)
        barButton.rx.tap
            .bind(to: subViewModel.input.barButtonTapped)
            .disposed(by: disposeBag)
        cookButton.rx.tap
            .bind(to: subViewModel.input.cookButtonTapped)
            .disposed(by: disposeBag)
        shoppingButton.rx.tap
            .bind(to: subViewModel.input.shoppingButtonTapped)
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
        ballGameButton.rx.tap
            .bind(to: subViewModel.input.ballGameButtonTapped)
            .disposed(by: disposeBag)
        musicButton.rx.tap
            .bind(to: subViewModel.input.musicButtonTapped)
            .disposed(by: disposeBag)
        veganButton.rx.tap
            .bind(to: subViewModel.input.veganButtonTapped)
            .disposed(by: disposeBag)
        runningButton.rx.tap
            .bind(to: subViewModel.input.runningButtonTapped)
            .disposed(by: disposeBag)
        concertsButton.rx.tap
            .bind(to: subViewModel.input.concertsButtonTapped)
            .disposed(by: disposeBag)
        museumButton.rx.tap
            .bind(to: subViewModel.input.museumButtonTapped)
            .disposed(by: disposeBag)
        boardgameButton.rx.tap
            .bind(to: subViewModel.input.boardgameButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.showSelectLanguageView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                let viewController = SelectLanguageViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .overCurrentContext
                self?.present(viewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        viewModel.output.isSundayButtonEnabled
            .drive(sundayButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isMondayButtonEnabled
            .drive(mondayButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isTuesdayButtonEnabled
            .drive(tuesdayButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isWedsdayButtonEnabled
            .drive(wedsdayButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isThursdayButtonEnabled
            .drive(thursdayButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isFridayButtonEnabled
            .drive(fridayButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isSaturdayButtonEnabled
            .drive(satdayButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isKoreanButtonEnabled
            .drive(koreanButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isJapaneseButtonEnabled
            .drive(japaneseButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isEnglishButtonEnabled
            .drive(englishButton.rx.isSelected)
            .disposed(by: disposeBag)
        viewModel.output.isChineseButtonEnabled
            .drive(chineseButton.rx.isSelected)
            .disposed(by: disposeBag)
//        viewModel.output.isValid
//            .map { [weak self] isValid in
//                self?.applyBtn.isEnabled = isValid
//                self?.applyBtn.backgroundColor = isValid ? .bappyYellow : .rgb(238, 238, 234, 1)
//                return isValid
//            }
//            .drive(applyBtn.rx.isEnabled)
//            .disposed(by: disposeBag)
        subViewModel.output.isTravelButtonEnabled
            .drive(travelButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isCafeButtonEnabled
            .drive(cafeButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isHikingButtonEnabled
            .drive(hikingButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isFoodButtonEnabled
            .drive(foodButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isBarButtonEnabled
            .drive(barButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isCookButtonEnabled
            .drive(cookButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.isShoppingButtonEnabled
            .drive(shoppingButton.rx.isSelected)
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
        subViewModel.output.musicButtonEnabled
            .drive(musicButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.ballGameButtonEnabled
            .drive(ballGameButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.veganButtonEnabled
            .drive(veganButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.runningButtonEnabled
            .drive(runningButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.concertsButtonEnabled
            .drive(concertsButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.museumButtonEnabled
            .drive(museumButton.rx.isSelected)
            .disposed(by: disposeBag)
        subViewModel.output.boardgameButtonEnabled
            .drive(boardgameButton.rx.isSelected)
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
        
        viewModel.input.dateSelected.onNext((firstDate, lastDate))
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        for day in calendar.selectedDates {
            calendar.deselect(day)
        }
        
        lastDate = nil
        firstDate = nil
        
        datesRange = []
        
        viewModel.input.dateSelected.onNext((firstDate, lastDate))
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 3)
    }
}

extension HomeFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        default:
            return year.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return month[row]
        default:
            return String(year[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dateComponenet = Calendar.current.dateComponents(in: TimeZone(identifier: TimeZone.current.identifier)!, from: Date())
        
        if component == 1 {
            dateComponenet.year = year[row]
            dateComponenet.yearForWeekOfYear = year[row]
        } else {
            dateComponenet.month = row + 1
        }
        
        let date = Calendar.current.date(from: dateComponenet) ?? Date()
        self.calendar.setCurrentPage(date, animated: false)
    }
}

extension HomeFilterViewController: BappyPresentDelegate {
    func leftButtonTapped() { }
    
    func rightButtonTapped() {
        
        viewModel.input.applyButtonTapped.onNext(())
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
