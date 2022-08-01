//
//  ProfileEditMainViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileEditMainViewModel: ViewModelType {
    
    struct Dependency {
        let user: BappyUser
        var name: String { "Bappy" }
        var flag: String {  "🇺🇸"  }
        var gender: String { "Other" }
        var birth: String { "2000.01.01" }
        var dateFormat: String { "yyyy.MM.dd" }
    }
    
    struct Input {
        var edittedImage: AnyObserver<UIImage?> // <-> Parent
        var imageButtonTapped: AnyObserver<Void> // <-> View
    }
    
    struct Output {
        var edittedImage: Signal<UIImage?> // <-> View
        var profileImageURL: Driver<URL?> // <-> View
        var name: Driver<String> // <-> View
        var flag: Driver<String> // <-> View
        var genderAndBirth: Driver<String> // <-> View
        var imageButtonTapped: Signal<Void> // <-> Parent
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let user$: BehaviorSubject<BappyUser>
    
    private let edittedImage$ = PublishSubject<UIImage?>()
    private let imageButtonTapped$ = PublishSubject<Void>()
  
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let user$ = BehaviorSubject<BappyUser>(value: dependency.user)
        
        let edittedImage = edittedImage$
            .asSignal(onErrorJustReturn: nil)
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
        let imageButtonTapped = imageButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        
        // MARK: Input & Output
        self.input = Input(
            edittedImage: edittedImage$.asObserver(),
            imageButtonTapped: imageButtonTapped$.asObserver()
        )
        
        self.output = Output(
            edittedImage: edittedImage,
            profileImageURL: profileImageURL,
            name: name,
            flag: flag,
            genderAndBirth: genderAndBirth,
            imageButtonTapped: imageButtonTapped
        )
        
        // MARK: Bindind
        self.user$ = user$
    }
}
