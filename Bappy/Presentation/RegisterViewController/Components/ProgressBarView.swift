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
    private let yellowView: UIView = {
        let yellowView = UIView()
        yellowView.backgroundColor = UIColor(red: 245.0/255.0, green: 213.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        yellowView.layer.cornerRadius = 3.5
        yellowView.clipsToBounds = false
        yellowView.layer.shadowColor = UIColor.black.cgColor
        yellowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        yellowView.layer.shadowOpacity = 0.5
        yellowView.layer.shadowRadius = 1.0
        return yellowView
    }()
    
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
        self.clipsToBounds = false
        self.layer.cornerRadius = 4.5
        self.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    }
    
    private func layout() {
        self.snp.makeConstraints { $0.height.equalTo(9.0) }
        self.addSubview(yellowView)
        yellowView.snp.makeConstraints {
            $0.height.equalTo(7.0)
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo(0)
        }
    }
    
    // MARK: Methods
    func initializeProgression() {
        updateProgression(1.0/7.0)
    }
    
    func updateProgression(_ progression: CGFloat) {
        yellowView.snp.removeConstraints()
        UIView.animate(withDuration: 0.3) {
            self.yellowView.snp.makeConstraints {
                $0.height.equalTo(7.0)
                $0.leading.bottom.equalToSuperview()
                $0.width.equalTo(self.snp.width).multipliedBy(progression)
            }
            self.layoutIfNeeded()
        }
    }
}

// MARK: Binder
extension Reactive where Base: ProgressBarView {
    var setProgression: Binder<CGFloat> {
        return Binder(self.base) { progressBarView, progression in
            progressBarView.updateProgression(progression)
        }
    }
}
