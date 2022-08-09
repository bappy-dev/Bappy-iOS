//
//  ViewModelType.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/15.
//

import Foundation
import RxSwift

public protocol ViewModelType: AnyObject, ReactiveCompatible {
    associatedtype Dependency
    associatedtype Input
    associatedtype Output
    
    var dependency: Dependency { get }
    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
    
    init(dependency: Dependency)
}

extension Reactive where Base: ViewModelType {
    public var debugError: Binder<String> {
        return Binder(self.base) { _, description in
            print("ERROR: \(description)")
        }
    }
}

func getValue<T: Any>(_ result: Result<T, Error>) -> T? {
    guard case .success(let value) = result else { return nil }
    return value
}

func getErrorDescription<T: Any>(_ result: Result<T, Error>) -> String? {
    guard case .failure(let error) = result else { return nil }
    return error.localizedDescription
}
