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
        let user: BappyUser
        var name: String { "Bappy" }
        var flag: String {  "🇺🇸"  }
        var gender: String { "Other" }
        var birth: String { "2000.01.01" }
        var dateFormat: String { "yyyy.MM.dd" }
    }
    
    struct SubViewModels {
        let buttonSectionViewModel: ProfileButtonSectionViewModel
    }
    
    struct Input {
        var user: AnyObserver<BappyUser> // <-> Parent
        var moreButtonTapped: AnyObserver<Void> // <-> View
        var selectedIndex: AnyObserver<Int> // <-> Child
    }
    
    struct Output {
        var profileImageURL: Driver<URL?> // <-> View
        var name: Driver<String> // <-> View
        var flag: Driver<String> // <-> View
        var genderAndBirth: Driver<String> // <-> View
        var moreButtonTapped: Signal<Void> // <-> Parent
        var selectedIndex: Signal<Int> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    let subViewModels: SubViewModels
    
    private let user$: BehaviorSubject<BappyUser>
    
    private let moreButtonTapped$ = PublishSubject<Void>()
    private let selectedIndex$ = PublishSubject<Int>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(
            buttonSectionViewModel: ProfileButtonSectionViewModel(dependency: .init(user: dependency.user)))
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let profileImageURL = user$
            .map { $0.profileImageURL }
            .asDriver(onErrorJustReturn: nil)
        let name = user$
            .map { $0.name ?? dependency.name }
            .asDriver(onErrorJustReturn: dependency.name)
        let flag = user$
            .map { $0.nationality?.flag ?? dependency.flag }
            .asDriver(onErrorJustReturn: dependency.flag)
        let genderAndBirth = user$
            .map { (
                gender: $0.gender?.rawValue ?? dependency.gender,
                birth: $0.birth?.toString(dateFormat: dependency.dateFormat)
                ?? dependency.birth
            )}
            .map { "\($0.gender) / \($0.birth)" }
            .asDriver(onErrorJustReturn: "\(dependency.gender) / \(dependency.birth)")
        
        let moreButtonTapped = moreButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let selectedIndex = selectedIndex$
            .asSignal(onErrorJustReturn: 0)
        
        // MARK: Input & Output
        self.input = Input(
            user: user$.asObserver(),
            moreButtonTapped: moreButtonTapped$.asObserver(),
            selectedIndex: selectedIndex$.asObserver()
        )
        
        self.output = Output(
            profileImageURL: profileImageURL,
            name: name,
            flag: flag,
            genderAndBirth: genderAndBirth,
            moreButtonTapped: moreButtonTapped,
            selectedIndex: selectedIndex
        )
        
        // MARK: Bindind
        self.user$ = user$
        
        user$
            .bind(to: subViewModels.buttonSectionViewModel.input.user)
            .disposed(by: disposeBag)
        
        subViewModels.buttonSectionViewModel.output.selectedIndex
            .distinctUntilChanged()
            .drive(selectedIndex$)
            .disposed(by: disposeBag)
    }
}
