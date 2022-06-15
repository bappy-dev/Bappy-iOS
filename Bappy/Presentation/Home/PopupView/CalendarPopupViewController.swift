//
//  CalendarPopupViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/31.
//

import UIKit
import SnapKit

protocol CalendarPopupViewControllerDelegate: AnyObject {
    
}

final class CalendarPopupViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: CalendarPopupViewControllerDelegate?
    
    private let maxDimmedAlpha: CGFloat = 0.3
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .bappyYellow
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minuteInterval = 10
        datePicker.minimumDate = Date() + 60 * 10
//        datePicker.addTarget(self, action: #selector(DidChangeDatePicker), for: .valueChanged)
        return datePicker
    }()
   
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateDismissView()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.4, delay: 0.4, options: .transitionCrossDissolve) {
            self.containerView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.isHidden = true
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        containerView.layer.cornerRadius = 17.0
        containerView.addBappyShadow(shadowOffsetHeight: 4.0)
    }
    
    private func layout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        containerView.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6.0)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10.0)
        }
    }
}
