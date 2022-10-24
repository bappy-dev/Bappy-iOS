//
//  RoundedProgressBarView.swift
//  Bappy
//
//  Created by Yujin Cha on 2022/10/24.
//

import UIKit
import SnapKit
import RxSwift

final class RoundedProgressBarView: UIView {
    
    // MARK: Properties
    private let yellowView = UIView()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .bappyLightgray
        layer.cornerRadius = 4.5
        clipsToBounds = true
        
        yellowView.backgroundColor = .bappyYellow
        yellowView.layer.cornerRadius = 4.5
        yellowView.clipsToBounds = true
    }
    
    private func layout() {
        self.snp.makeConstraints { $0.height.equalTo(9.0) }
        self.addSubview(yellowView)
        yellowView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(0)
        }
    }
}

// MARK: - Methods
extension RoundedProgressBarView {
    func initializeProgression(_ progression: CGFloat) {
        updateProgression(progression)
    }
    
    func updateProgression(_ progression: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.yellowView.snp.updateConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.equalTo(self.frame.width * progression)
            }
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Binder
extension Reactive where Base: RoundedProgressBarView {
    var setProgression: Binder<CGFloat> {
        return Binder(self.base) { progressBarView, progression in
            progressBarView.updateProgression(progression)
        }
    }
    
    var initProgression: Binder<CGFloat> {
        return Binder(self.base) { progressBarView, progression in
            progressBarView.initializeProgression(progression)
        }
    }
}
