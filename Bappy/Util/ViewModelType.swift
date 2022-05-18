//
//  ViewModelType.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/15.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Dependency
    associatedtype Input
    associatedtype Output
    
    var dependency: Dependency { get }
    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
    
    init(dependency: Dependency)
}
