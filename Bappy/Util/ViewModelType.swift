//
//  ViewModelType.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/15.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
    
    func bind(input: Input) -> Output
}
