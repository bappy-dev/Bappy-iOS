//
//  FilterViewModel.swift
//  Bappy
//
//  Created by 이현욱 on 2022/10/09.
//

import Foundation

import RxSwift
import RxCocoa

enum Weekday: String {
    case Monday = "Mon"
    case Tuesday = "Tue"
    case Wedsday = "Wed"
    case Thursday = "Thr"
    case Friday = "Fri"
    case Saturday = "Sat"
    case Sunday = "Sun"
}

final class HomeFilterViewModel: ViewModelType {
    struct Dependency {}
    
    struct SubViewModels {
        let hangoutMakeCategoryViewModel: HangoutMakeCategoryViewModel
        let languageViewModel: HangoutMakeLanguageViewModel
    }
    
    struct Input {
        var applyButtonTapped: AnyObserver<Void>
        var dateSelected: AnyObserver<(Date?, Date?)>
        var sundayButtonTapped: AnyObserver<Void> // <-> View
        var mondayButtonTapped: AnyObserver<Void> // <-> View
        var tuesdayButtonTapped: AnyObserver<Void> // <-> View
        var wedsdayButtonTapped: AnyObserver<Void> // <-> View
        var thursdayButtonTapped: AnyObserver<Void> // <-> View
        var fridayButtonTapped: AnyObserver<Void> // <-> View
        var satdayButtonTapped: AnyObserver<Void> // <-> View
        var moreButtonTapped: AnyObserver<Void>
        var koreanButtonTapped: AnyObserver<Void>
        var englishButtonTapped: AnyObserver<Void>
        var japaneseButtonTapped: AnyObserver<Void>
        var chineseButtonTapped: AnyObserver<Void>
    }
    
    struct Output {
        var isValid: Driver<Bool> // <-> Parent
        var isSundayButtonEnabled: Driver<Bool> // <-> View
        var isMondayButtonEnabled: Driver<Bool> // <-> View
        var isTuesdayButtonEnabled: Driver<Bool> // <-> View
        var isWedsdayButtonEnabled: Driver<Bool> // <-> View
        var isThursdayButtonEnabled: Driver<Bool> // <-> View
        var isFridayButtonEnabled: Driver<Bool> // <-> View
        var isSaturdayButtonEnabled: Driver<Bool> // <-> View
        var showSelectLanguageView: Signal<SelectLanguageViewModel?>
        var isChineseButtonEnabled: Driver<Bool> // <-> View
        var isEnglishButtonEnabled: Driver<Bool> // <-> View
        var isKoreanButtonEnabled: Driver<Bool> // <-> View
        var isJapaneseButtonEnabled: Driver<Bool> // <-> View
        var filterForm: Signal<(week: [Weekday], language: [String], hangoutCategory: [Hangout.Category], date: (Date?, Date?))>
    }
    
    
    private let weekdays: BehaviorSubject<[Weekday: Bool]>
    private let sundayButtonTapped$ = PublishSubject<Void>()
    private let mondayButtonTapped$ = PublishSubject<Void>()
    private let tuesdayButtonTapped$ = PublishSubject<Void>()
    private let wedsdayButtonTapped$ = PublishSubject<Void>()
    private let thursdayButtonTapped$ = PublishSubject<Void>()
    private let fridayButtonTapped$ = PublishSubject<Void>()
    private let satdayButtonTapped$ = PublishSubject<Void>()
    private let moreButtonTapped$ = PublishSubject<Void>()
    private let koreanButtonTapped$ = PublishSubject<Void>()
    private let englishButtonTapped$ = PublishSubject<Void>()
    private let japaneseButtonTapped$ = PublishSubject<Void>()
    private let chineseButtonTapped$ = PublishSubject<Void>()
    private let applyButtonTapped$ = PublishSubject<Void>()
    private let language$ = BehaviorSubject<[Language]>(value: [])
    private let dateSelected$ = BehaviorSubject<(Date?, Date?)>(value: (nil,nil) )
    private let isSundayButtonEnabled$ = BehaviorSubject<Bool>(value: true)
    private let isMondayButtonEnabled$ = BehaviorSubject<Bool>(value: true)
    private let isTuesdayButtonEnabled$ = BehaviorSubject<Bool>(value: true)
    private let isWedsdayButtonEnabled$ = BehaviorSubject<Bool>(value: true)
    private let isThursdayButtonEnabled$ = BehaviorSubject<Bool>(value: true)
    private let isFridayButtonEnabled$ = BehaviorSubject<Bool>(value: true)
    private let isSaturdayButtonEnabled$ = BehaviorSubject<Bool>(value: true)
    private let isEnglishButtonEnabled$ = BehaviorSubject<Bool>(value: true)
    private let isChineseButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isKoreanButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let isJapaneseButtonEnabled$ = BehaviorSubject<Bool>(value: false)
    private let showSelectLanguageView$ = PublishSubject<SelectLanguageViewModel?>()
    private let filterForm = BehaviorSubject<(week: [Weekday], language: [String], hangoutCategory: [Hangout.Category], date: (Date?, Date?))>(value: ([],[],[],(nil,nil)))
    
    var dependency: Dependency
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        let categoryDependency = HangoutMakeCategoryViewModel.Dependency(isStartWith: true)
        self.subViewModels = SubViewModels(hangoutMakeCategoryViewModel: HangoutMakeCategoryViewModel(dependency: categoryDependency),
                                           languageViewModel: HangoutMakeLanguageViewModel())
        
        
        let weekdays$ = BehaviorSubject<[Weekday: Bool]>(value: [:])
        
        let weekdays = weekdays$
            .map { $0.filter { $0.value } }
            .map { $0.map { $0.key } }
            .asSignal(onErrorJustReturn: [])
        
        let isSundayButtonEnabled = sundayButtonTapped$
            .withLatestFrom(isSundayButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(true)
        let isMondayButtonEnabled = mondayButtonTapped$
            .withLatestFrom(isMondayButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(true)
        let isTuesdayButtonEnabled = tuesdayButtonTapped$
            .withLatestFrom(isTuesdayButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(true)
        let isWedsdayButtonEnabled = wedsdayButtonTapped$
            .withLatestFrom(isWedsdayButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(true)
        let isThursdayButtonEnabled = thursdayButtonTapped$
            .withLatestFrom(isThursdayButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(true)
        let isFridayButtonEnabled = fridayButtonTapped$
            .withLatestFrom(isFridayButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(true)
        let isSaturdayButtonEnabled = satdayButtonTapped$
            .withLatestFrom(isSaturdayButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(true)
        let isKoreanButtonEnabled = koreanButtonTapped$
            .withLatestFrom(isKoreanButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isEnglishButtonEnabled = englishButtonTapped$
            .withLatestFrom(isEnglishButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(true)
        let isChineseButtonEnabled = chineseButtonTapped$
            .withLatestFrom(isChineseButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        let isJapaneseButtonEnabled = japaneseButtonTapped$
            .withLatestFrom(isJapaneseButtonEnabled$)
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
        
        let isWeekdaysValid = weekdays.map { !$0.isEmpty }.asObservable().startWith(true)
        let isLanguageValid = language$.map { !$0.isEmpty }.startWith(true)
        let isCateValid = subViewModels.hangoutMakeCategoryViewModel.output.isValid.asObservable().startWith(true)
        let isSelectedDateValid = dateSelected$.map { $0.0 != nil }.startWith(true)

        let isValid = Observable.combineLatest(isWeekdaysValid, isLanguageValid, isCateValid, isSelectedDateValid)
            .map { $0 || $1 || $2 || $3 }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
        
        let showSelectLanguageView = showSelectLanguageView$
            .asSignal(onErrorJustReturn: nil)

        self.input = Input(applyButtonTapped: applyButtonTapped$.asObserver(),
                           dateSelected: dateSelected$.asObserver(),
                           sundayButtonTapped: sundayButtonTapped$.asObserver(),
                           mondayButtonTapped: mondayButtonTapped$.asObserver(),
                           tuesdayButtonTapped: tuesdayButtonTapped$.asObserver(),
                           wedsdayButtonTapped: wedsdayButtonTapped$.asObserver(),
                           thursdayButtonTapped: thursdayButtonTapped$.asObserver(),
                           fridayButtonTapped: fridayButtonTapped$.asObserver(),
                           satdayButtonTapped: satdayButtonTapped$.asObserver(),
                           moreButtonTapped: moreButtonTapped$.asObserver(),
                           koreanButtonTapped: koreanButtonTapped$.asObserver(),
                           englishButtonTapped: englishButtonTapped$.asObserver(),
                           japaneseButtonTapped: japaneseButtonTapped$.asObserver(),
                           chineseButtonTapped: chineseButtonTapped$.asObserver())
        
        self.output = Output(isValid: isValid,
                             isSundayButtonEnabled: isSundayButtonEnabled,
                             isMondayButtonEnabled: isMondayButtonEnabled,
                             isTuesdayButtonEnabled: isTuesdayButtonEnabled,
                             isWedsdayButtonEnabled: isWedsdayButtonEnabled,
                             isThursdayButtonEnabled: isThursdayButtonEnabled,
                             isFridayButtonEnabled: isFridayButtonEnabled,
                             isSaturdayButtonEnabled: isSaturdayButtonEnabled,
                             showSelectLanguageView: showSelectLanguageView,
                             isChineseButtonEnabled: isChineseButtonEnabled,
                             isEnglishButtonEnabled: isEnglishButtonEnabled,
                             isKoreanButtonEnabled: isKoreanButtonEnabled,
                             isJapaneseButtonEnabled: isJapaneseButtonEnabled,
                             filterForm: filterForm.asSignal(onErrorJustReturn: ([],[],[],(nil,nil))))
        
        // MARK: Binding
        self.weekdays = weekdays$
        
        isSundayButtonEnabled
            .drive(isSundayButtonEnabled$)
            .disposed(by: disposeBag)
        isMondayButtonEnabled
            .drive(isMondayButtonEnabled$)
            .disposed(by: disposeBag)
        isTuesdayButtonEnabled
            .drive(isTuesdayButtonEnabled$)
            .disposed(by: disposeBag)
        isWedsdayButtonEnabled
            .drive(isWedsdayButtonEnabled$)
            .disposed(by: disposeBag)
        isThursdayButtonEnabled
            .drive(isThursdayButtonEnabled$)
            .disposed(by: disposeBag)
        isFridayButtonEnabled
            .drive(isFridayButtonEnabled$)
            .disposed(by: disposeBag)
        isSaturdayButtonEnabled
            .drive(isSaturdayButtonEnabled$)
            .disposed(by: disposeBag)
        isKoreanButtonEnabled
            .drive(isKoreanButtonEnabled$)
            .disposed(by: disposeBag)
        isChineseButtonEnabled
            .drive(isChineseButtonEnabled$)
            .disposed(by: disposeBag)
        isJapaneseButtonEnabled
            .drive(isJapaneseButtonEnabled$)
            .disposed(by: disposeBag)
        isEnglishButtonEnabled
            .drive(isEnglishButtonEnabled$)
            .disposed(by: disposeBag)
        
        isSundayButtonEnabled$
            .withLatestFrom(weekdays$) { isEnabled, dict -> [Weekday: Bool] in
                var newDict = dict
                newDict[.Sunday] = isEnabled
                return newDict
            }
            .bind(to: weekdays$)
            .disposed(by: disposeBag)
        isMondayButtonEnabled$
            .withLatestFrom(weekdays$) { isEnabled, dict -> [Weekday: Bool] in
                var newDict = dict
                newDict[.Monday] = isEnabled
                return newDict
            }
            .bind(to: weekdays$)
            .disposed(by: disposeBag)
        isTuesdayButtonEnabled$
            .withLatestFrom(weekdays$) { isEnabled, dict -> [Weekday: Bool] in
                var newDict = dict
                newDict[.Tuesday] = isEnabled
                return newDict
            }
            .bind(to: weekdays$)
            .disposed(by: disposeBag)
        isWedsdayButtonEnabled$
            .withLatestFrom(weekdays$) { isEnabled, dict -> [Weekday: Bool] in
                var newDict = dict
                newDict[.Wedsday] = isEnabled
                return newDict
            }
            .bind(to: weekdays$)
            .disposed(by: disposeBag)
        isThursdayButtonEnabled$
            .withLatestFrom(weekdays$) { isEnabled, dict -> [Weekday: Bool] in
                var newDict = dict
                newDict[.Thursday] = isEnabled
                return newDict
            }
            .bind(to: weekdays$)
            .disposed(by: disposeBag)
        
        isFridayButtonEnabled$
            .withLatestFrom(weekdays$) { isEnabled, dict -> [Weekday: Bool] in
                var newDict = dict
                newDict[.Friday] = isEnabled
                return newDict
            }
            .bind(to: weekdays$)
            .disposed(by: disposeBag)
        isSaturdayButtonEnabled$
            .withLatestFrom(weekdays$) { isEnabled, dict -> [Weekday: Bool] in
                var newDict = dict
                newDict[.Saturday] = isEnabled
                return newDict
            }
            .bind(to: weekdays$)
            .disposed(by: disposeBag)
        
        applyButtonTapped$
            .withLatestFrom(
                Observable.combineLatest(weekdays.asObservable(),
                                         language$,
                                         subViewModels.hangoutMakeCategoryViewModel.output.categories.asObservable(),
                                         dateSelected$))
            .map { ($0, $1, $2, $3) }
            .bind(to: filterForm)
            .disposed(by: disposeBag)
        
        isKoreanButtonEnabled$
            .skip(1)
            .withLatestFrom(language$) { isEnabled, language -> [String] in
                var arr = try? self.language$.value()
                if isEnabled {
                    arr?.append("Korean")
                } else {
                    let index = arr?.firstIndex(where: { value in
                        return value == "Korean"
                    })
                    arr?.remove(at: index ?? 0)
                }
                return arr ?? []
            }
            .bind(to: language$)
            .disposed(by: disposeBag)
        
        isEnglishButtonEnabled$
            .skip(1)
            .withLatestFrom(language$) { isEnabled, language -> [String] in
                var arr = try? self.language$.value()
                if isEnabled {
                    arr?.append("English")
                } else {
                    let index = arr?.firstIndex(where: { value in
                        return value == "English"
                    })
                    arr?.remove(at: index ?? 0)
                }
                return arr ?? []
            }
            .bind(to: language$)
            .disposed(by: disposeBag)
        
        isChineseButtonEnabled$
            .skip(1)
            .withLatestFrom(language$) { isEnabled, language -> [String] in
                var arr = try? self.language$.value()
                if isEnabled {
                    arr?.append("Chinese")
                } else {
                    let index = arr?.firstIndex(where: { value in
                        return value == "Chinese"
                    })
                    arr?.remove(at: index ?? 0)
                }
                return arr ?? []
            }
            .bind(to: language$)
            .disposed(by: disposeBag)
        
        isJapaneseButtonEnabled$
            .skip(1)
            .withLatestFrom(language$) { isEnabled, language -> [String] in
                var arr = try? self.language$.value()
                if isEnabled {
                    arr?.append("Japanese")
                } else {
                    let index = arr?.firstIndex(where: { value in
                        return value == "Japanese"
                    })
                    arr?.remove(at: index ?? 0)
                }
                return arr ?? []
            }
            .bind(to: language$)
            .disposed(by: disposeBag)
        
        moreButtonTapped$
            .map { _ -> SelectLanguageViewModel in
                let viewModel = SelectLanguageViewModel()
                viewModel.delegate = self
                return viewModel
            }
            .bind(to: showSelectLanguageView$)
            .disposed(by: disposeBag)
    }
}

extension HomeFilterViewModel: SelectLanguageViewModelDelegate {
    func languageSelected(language: Language) {
        var arr = try? language$.value()
        arr?.append(language)
        language$.onNext(arr ?? [])
    }
}
