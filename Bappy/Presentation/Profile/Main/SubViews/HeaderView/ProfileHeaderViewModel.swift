//
//  ProfileHeaderViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/01.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileHeaderViewModel: ViewModelType {
    
    struct Dependency {
        var dateFormat: String { "yyyy.MM.dd" }
    }
    
    struct SubViewModels {
        let buttonSectionViewModel: ProfileButtonSectionViewModel
    }
    
    struct Input {
        var selectedIndex: AnyObserver<Int> // <-> Parent
        var user: AnyObserver<BappyUser?> // <-> Parent
        var moreButtonTapped: AnyObserver<Void> // <-> View
        var selectedButtonIndex: AnyObserver<Int> // <-> Child
    }
    
    struct Output {
        var profileImageURL: Signal<URL?> // <-> View
        var name: Signal<String?> // <-> View
        var flag: Signal<String?> // <-> View
        var genderAndBirth: Signal<String?> // <-> View
        var moreButtonTapped: Signal<Void> // <-> Parent
        var selectedButtonIndex: Signal<Int> // <-> Parent
        var user: Signal<BappyUser?> // <-> Child
        var selectedIndex: Signal<Int> // <-> Child
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
   
    private let selectedIndex$ = PublishSubject<Int>()
    private let user$ = BehaviorSubject<BappyUser?>(value: nil)
    private let moreButtonTapped$ = PublishSubject<Void>()
    private let selectedButtonIndex$ = PublishSubject<Int>()
  
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            buttonSectionViewModel: ProfileButtonSectionViewModel()
        )
        
        // MARK: Streams
        let profileImageURL = user$
            .compactMap(\.?.profileImageURL)
            .asSignal(onErrorJustReturn: nil)
        let name = user$
            .compactMap(\.?.name)
            .asSignal(onErrorJustReturn: nil)
        let flag = user$
            .compactMap(\.?.nationality?.flag)
            .asSignal(onErrorJustReturn: nil)
        let genderAndBirth = Observable
            .combineLatest(
                user$.compactMap(\.?.gender?.rawValue),
                user$.compactMap { $0?.birth?.toString(dateFormat: dependency.dateFormat) }
            )
            .map { "\($0) / \($1)" }
            .asSignal(onErrorJustReturn: nil)
        let moreButtonTapped = moreButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let selectedButtonIndex = selectedButtonIndex$
            .asSignal(onErrorJustReturn: 0)
        let user = user$
            .asSignal(onErrorJustReturn: nil)
        let selectedIndex = selectedIndex$
            .asSignal(onErrorJustReturn: 0)
        
        // MARK: Input & Output
        self.input = Input(
            selectedIndex: selectedIndex$.asObserver(),
            user: user$.asObserver(),
            moreButtonTapped: moreButtonTapped$.asObserver(),
            selectedButtonIndex: selectedButtonIndex$.asObserver()
        )
        
        self.output = Output(
            profileImageURL: profileImageURL,
            name: name,
            flag: flag,
            genderAndBirth: genderAndBirth,
            moreButtonTapped: moreButtonTapped,
            selectedButtonIndex: selectedButtonIndex,
            user: user,
            selectedIndex: selectedIndex
        )
        
        // MARK: Bindind
        // Child
        output.selectedIndex
            .emit(to: subViewModels.buttonSectionViewModel.input.selectedIndex)
            .disposed(by: disposeBag)
        
        output.user
            .compactMap { $0 }
            .emit(to: subViewModels.buttonSectionViewModel.input.user)
            .disposed(by: disposeBag)
        
        subViewModels.buttonSectionViewModel.output.selectedButtonIndex
            .emit(to: input.selectedButtonIndex)
            .disposed(by: disposeBag)
    }
}
