//
//  LocaleSettingViewModel.swift
//  Bappy
//
//  Created by 정동천 on 2022/07/12.
//

import UIKit
import RxSwift
import RxCocoa

final class LocaleSettingViewModel: ViewModelType {
    
    struct Dependency {
        let bappyAuthRepository: BappyAuthRepository
    }
    
    struct Input {
        var closeButtonTapped: AnyObserver<Void> // <-> View
        var itemDeleted: AnyObserver<IndexPath> // <-> View
    }
    
    struct Output {
        var closeButtonTapped: Signal<Void> // <-> Parent
        var localeSettingSection: Driver<[LocaleSettingSection]> // <-> View
    }
    
    let dependency: Dependency
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let closeButtonTapped$ = PublishSubject<Void>()
    private let itemDeleted$ = PublishSubject<IndexPath>()
    
    private let localeSettingSection$ = BehaviorSubject<[LocaleSettingSection]>(value: [])
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // Streams
        let closeButtonTapped = closeButtonTapped$
            .asSignal(onErrorJustReturn: Void())
        let localeSettingSection = localeSettingSection$
            .asDriver(onErrorJustReturn: [])
        
        // Input & Output
        self.input = Input(
            closeButtonTapped: closeButtonTapped$.asObserver(),
            itemDeleted: itemDeleted$.asObserver()
        )
        
        self.output = Output(
            closeButtonTapped: closeButtonTapped,
            localeSettingSection: localeSettingSection
        )
        
        // Bindind
        itemDeleted$
            .withLatestFrom(localeSettingSection$) { indexPath, sections -> [LocaleSettingSection] in
                var sections = sections
                var section = sections[indexPath.section]
                section.items.remove(at: indexPath.row)
                sections[indexPath.section] = section
                return sections
            }
            .bind(to: localeSettingSection$)
            .disposed(by: disposeBag)
        
        localeSettingSection$.onNext([.init(items: [
            Location(
                name: "Centum Station",
                address: "210 Haeun-daero, Haeundae-gu, Busan, South Korea",
                latitude: 35.179495,
                longitude: 129.124544,
                isSelected: false
            ),
            Location(
                name: "Pusan National University",
                address: "2 Busandaehak-ro 63beon-gil, Geumjeong-gu, Busan, South Korea",
                latitude: 35.2339681,
                longitude: 129.0806855,
                isSelected: true
            ),
            Location(
                name: "Dongseong-ro",
                address: "Dongseong-ro, Jung-gu, Daegu, South Korea",
                latitude: 35.8715163,
                longitude: 128.5959431,
                isSelected: false
            ),
            Location(
                name: "Pangyo-dong",
                address: "Pangyo-dong, Bundang-gu, Seongnam-si, Gyeonggi-do, South Korea",
                latitude: 37.3908894,
                longitude: 127.0967915,
                isSelected: false
            ),
        ])])
    }
}
