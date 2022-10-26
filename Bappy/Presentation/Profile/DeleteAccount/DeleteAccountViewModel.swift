//
//  DeleteAccountViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/20.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FBSDKCoreKit

final class DeleteAccountViewModel: ViewModelType {
    
    struct Dependency {
        var dropdownList: [String]
        let hangoutRepository: HangoutRepository
        
        init(dropdownList: [String], hangoutRepository: HangoutRepository = DefaultHangoutRepository()) {
            self.hangoutRepository = hangoutRepository
            self.dropdownList = dropdownList
        }
    }
    
    struct SubViewModels {
        let firstPageViewModel: DeleteAccountFirstPageViewModel
        let secondPageViewModel: DeleteAccountSecondPageViewModel
    }
    
    struct Input {
        var cancelButtonTapped: AnyObserver<Void> // <-> View
        var confirmButtonTapped: AnyObserver<Void> // <-> View
        var isReasonSelected: AnyObserver<Bool> // <-> Child(Second)
    }
    
    struct Output {
        var page: Driver<Int> // <-> View
        var popView: Signal<Void> // <-> View
        var isConfirmButtonEnabled: Driver<Bool> // <-> View
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let page$ = BehaviorSubject<Int>(value: 0)
    
    private let cancelButtonTapped$ = PublishSubject<Void>()
    private let confirmButtonTapped$ = PublishSubject<Void>()
    private let isReasonSelected$ = BehaviorSubject<Bool>(value: false)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            firstPageViewModel: DeleteAccountFirstPageViewModel(),
            secondPageViewModel: DeleteAccountSecondPageViewModel(
                dependency: .init(dropdownList: dependency.dropdownList)
            )
        )
        
        // MARK: Streams
        let page = page$
            .asDriver(onErrorJustReturn: 0)
        let popView = cancelButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let isConfirmButtonEnabled = Observable
            .combineLatest(isReasonSelected$, page$)
            .map { ($1 == 0) || ($1 == 1 && $0) }
            .asDriver(onErrorJustReturn: false)
        
        // MARK: Input & Output
        self.input = Input(
            cancelButtonTapped: cancelButtonTapped$.asObserver(),
            confirmButtonTapped: confirmButtonTapped$.asObserver(),
            isReasonSelected: isReasonSelected$.asObserver()
        )
        
        self.output = Output(
            page: page,
            popView: popView,
            isConfirmButtonEnabled: isConfirmButtonEnabled
        )
        
        // MARK: Bindind
        confirmButtonTapped$
            .withLatestFrom(page$)
            .filter { $0 == 0 }
            .map { _ in 1 }
            .bind(to: page$)
            .disposed(by: disposeBag)
        
//        confirmButtonTapped$
//            .withLatestFrom(page$)
//            .filter { $0 == 1 }
        
        // facebook
//       Delete /AccessToken.current?.userID/permissions
        
        //google
//        Auth.auth().currentUser?.delete { error in
//            if error != nil {
//
//            } else {
//
//            }
//        }
//        guard let loginType = UserDefaults.standard.value(forKey: "LoginType") as? String, let type = LoginType(rawValue: loginType) {
//            switch type {
//            case .Apple:
//                <#code#>
//            case .Google:
//                <#code#>
//            case .Facebook:
//                <#code#>
//            }
//        }
        
        subViewModels.secondPageViewModel.output.isReasonSelected
            .emit(to: isReasonSelected$)
            .disposed(by: disposeBag)
    }
}


