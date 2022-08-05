//
//  ReportViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class ReportViewModel: ViewModelType {
    
    struct Dependency {
        let hangoutRepository: HangoutRepository
        var hangoutID: String
        var dropdownList: [String]
        var maxNumOfImages: Int { 5 }
        
        init(hangoutRepository: HangoutRepository = DefaultHangoutRepository(),
             hangoutID: String,
             dropdownList: [String]) {
            self.hangoutRepository = hangoutRepository
            self.hangoutID = hangoutID
            self.dropdownList = dropdownList
        }
    }
    
    struct SubViewModels {
        let writingViewModel: ReportWritingSectionViewModel
        let imageViewModel: ReportImageSectionViewModel
        let dropdownViewModel: BappyDropdownViewModel
    }
    
    struct Input {
        var touchesBegan: AnyObserver<Void> // <-> View
        var tapGestureEvent: AnyObserver<Void> // <-> View
        var backButtonTapped: AnyObserver<Void> // <-> View
        var reportButtonTapped: AnyObserver<Void> // <-> View
        var addedImage: AnyObserver<UIImage> // <-> View
        var openDropdownView: AnyObserver<Void> // <-> Child(Writing)
        var reportingDetail: AnyObserver<String?> // <-> Child(Writing)
        var addPhoto: AnyObserver<Void> // <-> Child(Image)
        var removePhoto: AnyObserver<Int> // <-> Child(Image)
        var reportingType: AnyObserver<String?> // <-> Child(Dropdown)
    }
    
    struct Output {
        var endEditing: Signal<Void> // <-> View
        var popView: Signal<Void> // <-> View
        var showPHPickerView: Signal<Int?> // <-> View
        var showSuccessView: Signal<Void> // <-> View
        var isReportButtonEnabled: Driver<Bool> // <-> View
        var openDropdownView: Signal<Void> // <-> View
        var closeDropdownView: Signal<Void> // <-> View
        var showLoader: Signal<Bool> // <-> View
        var reportingType: Signal<String?> // <-> Child(Writing)
        var selectedImages: Signal<[UIImage]> // <-> Child(Image)
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let hangoutID$: BehaviorSubject<String>
    private let maxNumOfImages$: BehaviorSubject<Int>
    
    private let touchesBegan$ = PublishSubject<Void>()
    private let tapGestureEvent$ = PublishSubject<Void>()
    private let backButtonTapped$ = PublishSubject<Void>()
    private let reportButtonTapped$ = PublishSubject<Void>()
    private let addedImage$ = PublishSubject<UIImage>()
    private let openDropdownView$ = PublishSubject<Void>()
    private let reportingDetail$ = BehaviorSubject<String?>(value: nil)
    private let addPhoto$ = PublishSubject<Void>()
    private let removePhoto$ = PublishSubject<Int>()
    private let reportingType$ = BehaviorSubject<String?>(value: nil)
    
    private let showSuccessView$ = PublishSubject<Void>()
    private let showLoader$ = PublishSubject<Bool>()
    private let selectedImages$ = BehaviorSubject<[UIImage]>(value: [])
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            writingViewModel: ReportWritingSectionViewModel(
                dependency: .init()),
            imageViewModel: ReportImageSectionViewModel(
                dependency: .init(maxNumOfImages: dependency.maxNumOfImages)),
            dropdownViewModel: BappyDropdownViewModel(
                dependency: .init(dropdownList: dependency.dropdownList))
        )
        
        // MARK: Streams
        let hangoutID$ = BehaviorSubject<String>(value: dependency.hangoutID)
        let maxNumOfImages$ = BehaviorSubject<Int>(value: dependency.maxNumOfImages)
        
        let endEditing = Observable
            .merge(touchesBegan$, tapGestureEvent$)
            .asSignal(onErrorJustReturn: Void())
        let popView = backButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let showPHPickerView = addPhoto$
            .withLatestFrom(maxNumOfImages$)
            .withLatestFrom(selectedImages$) { $0 - $1.count }
            .filter { ($0 ?? 0) > 0 }
            .asSignal(onErrorJustReturn: nil)
        let showSuccessView = showSuccessView$
            .asSignal(onErrorJustReturn: Void())
        let isReportButtonEnabled = Observable
            .combineLatest(reportingType$, reportingDetail$)
            .map { !($0 ?? "").isEmpty && !($1 ?? "").isEmpty }
            .asDriver(onErrorJustReturn: false)
        let openDropdownView = openDropdownView$
            .asSignal(onErrorJustReturn: Void())
        let closeDropdownView = Observable
            .merge(
                reportingType$.compactMap { _ in }.skip(1),
                tapGestureEvent$
            )
            .asSignal(onErrorJustReturn: Void())
        let showLoader = showLoader$
            .asSignal(onErrorJustReturn: false)
        let reportingType = reportingType$
            .asSignal(onErrorJustReturn: nil)
        let selectedImages = selectedImages$
            .asSignal(onErrorJustReturn: [])
          
        // MARK: Input & Output
        self.input = Input(
            touchesBegan: touchesBegan$.asObserver(),
            tapGestureEvent: tapGestureEvent$.asObserver(),
            backButtonTapped: backButtonTapped$.asObserver(),
            reportButtonTapped: reportButtonTapped$.asObserver(),
            addedImage: addedImage$.asObserver(),
            openDropdownView: openDropdownView$.asObserver(),
            reportingDetail: reportingDetail$.asObserver(),
            addPhoto: addPhoto$.asObserver(),
            removePhoto: removePhoto$.asObserver(),
            reportingType: reportingType$.asObserver()
        )
        
        self.output = Output(
            endEditing: endEditing,
            popView: popView,
            showPHPickerView: showPHPickerView,
            showSuccessView: showSuccessView,
            isReportButtonEnabled: isReportButtonEnabled,
            openDropdownView: openDropdownView,
            closeDropdownView: closeDropdownView,
            showLoader: showLoader,
            reportingType: reportingType,
            selectedImages: selectedImages
        )
        
        // MARK: Bindind
        self.hangoutID$ = hangoutID$
        self.maxNumOfImages$ = maxNumOfImages$
        
        addedImage$
            .withLatestFrom(selectedImages$) { $1 + [$0] }
            .filter { $0.count <= 5 }
            .bind(to: selectedImages$)
            .disposed(by: disposeBag)
        
        removePhoto$
            .withLatestFrom(selectedImages$) { row, images in
                var images = images
                images.remove(at: row)
                return images
            }
            .bind(to: selectedImages$)
            .disposed(by: disposeBag)
        
        // Hangout Report API
        let reportResult = reportButtonTapped$
            .withLatestFrom(Observable.combineLatest(
                hangoutID$,
                reportingType$.compactMap { $0 },
                reportingDetail$.compactMap { $0 },
                selectedImages$.map { images -> [Data]? in
                    guard images.isEmpty else { return nil }
                    return images.compactMap { $0.jpegData(compressionQuality: 1.0) }
                }
            ))
            .do { [weak self] _ in self?.showLoader$.onNext(true) }
            .flatMap(dependency.hangoutRepository.reportHangout)
            .do { [weak self] _ in self?.showLoader$.onNext(false) }
            .observe(on: MainScheduler.asyncInstance)
            .share()
        
        reportResult
            .compactMap(getErrorDescription)
            .bind(to: self.rx.debugError)
            .disposed(by: disposeBag)
        
        reportResult
            .compactMap(getValue)
            .map { _ in }
            .bind(to: showSuccessView$)
            .disposed(by: disposeBag)
        
        // Child(Writing)
        output.reportingType
            .compactMap { $0 }
            .emit(to: subViewModels.writingViewModel.input.reportingType)
            .disposed(by: disposeBag)
        
        
        subViewModels.writingViewModel.output.openDropdownView
            .emit(to: input.openDropdownView)
            .disposed(by: disposeBag)
        
        subViewModels.writingViewModel.output.reportingDetail
            .compactMap { $0 }
            .emit(to: input.reportingDetail)
            .disposed(by: disposeBag)
        
        // Child(Image)
        output.selectedImages
            .emit(to:subViewModels.imageViewModel.input.selectedImages)
            .disposed(by: disposeBag)
            
        subViewModels.imageViewModel.output.addPhoto
            .emit(to: input.addPhoto)
            .disposed(by: disposeBag)
        
        subViewModels.imageViewModel.output.removePhoto
            .compactMap { $0 }
            .emit(to: input.removePhoto)
            .disposed(by: disposeBag)
        
        // Child(Dropdown)
        subViewModels.dropdownViewModel.output.selectedText
            .compactMap { $0 }
            .emit(to: input.reportingType)
            .disposed(by: disposeBag)
    }
}
