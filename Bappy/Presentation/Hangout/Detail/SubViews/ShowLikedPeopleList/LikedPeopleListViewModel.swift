//
//  LikedPeopleListViewModel.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/01.
//

import Foundation

import RxSwift
import RxCocoa

protocol LikedPeopleListViewModelDelegate: AnyObject {
    func selectedUser(id: String)
}

final class LikedPeopleListViewModel: ViewModelType {
    
    struct Dependency {
        var hangout: Hangout
        var likedNames: [String]
        var likedIDs: [Hangout.Info] { hangout.likedIDs }
    }
    
    struct Input {
        var selectedUserID: AnyObserver<String?>
    }
    
    struct Output {
        var selectedUserID: Signal<String?>
        var likedIDs: Driver<[Hangout.Info]> // <-> View
        var likedNames: Driver<[String]>
    }
    
    var disposeBag = DisposeBag()
    
    var dependency: Dependency
    
    let input: Input
    let output: Output
    weak var delegate: LikedPeopleListViewModelDelegate?
    
    private let likedIDs$: BehaviorSubject<[Hangout.Info]>
    private let selectedUserID$ = PublishSubject<String?>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        let selectedUserID = selectedUserID$
            .asSignal(onErrorJustReturn: nil)
        let likedIDs$ = BehaviorSubject<[Hangout.Info]>(value: dependency.likedIDs)
        let likedNames$ = BehaviorSubject<[String]>(value: dependency.likedNames)
        let likedIDs = likedIDs$
            .asDriver(onErrorJustReturn: dependency.likedIDs)
        let likedNames = likedNames$
            .asDriver(onErrorJustReturn: dependency.likedNames)
        
        self.input = Input(selectedUserID: selectedUserID$.asObserver())
        self.output = Output(selectedUserID: selectedUserID,
                             likedIDs: likedIDs,
                             likedNames: likedNames)
        
        self.likedIDs$ = likedIDs$
        
        selectedUserID$
            .compactMap { $0 }
            .bind { [weak self] id in
                self?.delegate?.selectedUser(id: id)
            }.disposed(by: disposeBag)
    }
}
