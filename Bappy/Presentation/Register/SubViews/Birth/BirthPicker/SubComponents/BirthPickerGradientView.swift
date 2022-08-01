//
//  BirthPickerGradientView.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/15.
//

import UIKit
import SnapKit

final class BirthPickerGradientView: UIView {
    
    enum Position { case top, bottom }
    // MARK: Properties
    private let position: Position
    private let gradientLayer = CAGradientLayer()
    
    // MARK: Lifecycle
    init(position: Position) {
        self.position = position
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    // MARK: Event
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        if (self == hitView) { return nil }
        return hitView
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.addSublayer(gradientLayer)
        
        let colors: [CGColor] = (position == .top)
        ? [UIColor.white.withAlphaComponent(0.8).cgColor,
           UIColor.white.withAlphaComponent(0).cgColor]
        : [UIColor.white.withAlphaComponent(0).cgColor,
           UIColor.white.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.colors =  colors
        
    }
    
    private func layout() {
        gradientLayer.frame.size.width = self.frame.size.width
        gradientLayer.frame.size.height = self.frame.size.height
    }
}
