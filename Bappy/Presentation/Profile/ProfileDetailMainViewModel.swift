//
//  ProfileDetailMainViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/03.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileDetailMainViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        var name: String { "Bappy" }
        var flag: String {  "🇺🇸"  }
        var gender: String { "Other" }
        var birth: String { "2000.01.01" }
        var dateFormat: String { "yyyy.MM.dd" }
    }
    
    struct Input {}
    
    struct Output {
        var profileImageURL: Driver<URL?> // <-> View
        var name: Driver<String> // <-> View
        var flag: Driver<String> // <-> View
        var genderAndBirth: Driver<String> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
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
        
        // Input & Output
        self.input = Input()
        
        self.output = Output(
            profileImageURL: profileImageURL,
            name: name,
            flag: flag,
            genderAndBirth: genderAndBirth)
        
        // Bindind
        self.user$ = user$
    }
}
