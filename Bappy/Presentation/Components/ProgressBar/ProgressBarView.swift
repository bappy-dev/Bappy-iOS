//
//  ProgressBarView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit
import SnapKit
import RxSwift

final class ProgressBarView: UIView {
    
    // MARK: Properties
    private let viewModel: ProgressBarViewModel
    private let yellowView = UIView()
    
    // MARK: Lifecycle
    init(viewModel: ProgressBarViewModel = ProgressBarViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = UIColor(named: "bappy_lightgray")
        yellowView.backgroundColor = UIColor(named: "bappy_yellow")
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
extension ProgressBarView {
    func initializeProgression(_ progression: CGFloat) {
        updateProgression(progression)
    }
    
    func updateProgression(_ progression: CGFloat) {
        yellowView.snp.removeConstraints()
        UIView.animate(withDuration: 0.3) {
            self.yellowView.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.equalTo(self.snp.width).multipliedBy(progression)
            }
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Binder
extension Reactive where Base: ProgressBarView {
    var setProgression: Binder<CGFloat> {
        return Binder(self.base) { progressBarView, progression in
            progressBarView.updateProgression(progression)
        }
    }
}
