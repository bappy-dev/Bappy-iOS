//
//  CustomCalendarCell.swift
//  Bappy
//
//  Created by 이현욱 on 2022/10/12.
//

import UIKit

import FSCalendar

enum SelectionType {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

final class CustomCalendarCell: FSCalendarCell {
    static let id = "CustomCalendarCell"
    
    private weak var selectionLayer: CAShapeLayer?
    private weak var roundedLayer: CAShapeLayer?
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.rgb(244, 244, 239, 1).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel?.layer)
        self.selectionLayer = selectionLayer

        let roundedLayer = CAShapeLayer()
        roundedLayer.fillColor = UIColor.rgb(245, 213, 84, 1).cgColor
        roundedLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(roundedLayer, below: self.titleLabel?.layer)
        self.roundedLayer = roundedLayer

        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        self.backgroundView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionLayer?.frame = self.contentView.bounds
        self.roundedLayer?.frame = self.contentView.bounds

        let contentHeight = self.contentView.frame.height
        let contentWidth = self.contentView.frame.width

        let selectionLayerBounds = selectionLayer?.bounds ?? .zero
        let selectionLayerWidth = selectionLayer?.bounds.width ?? .zero
        
        let roundedLayerHeight = roundedLayer?.frame.height ?? .zero
        let roundedLayerWidth = roundedLayer?.frame.width ?? .zero
        
        let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
        let rect = CGRect(x: contentWidth / 2 - diameter / 2,
                          y: contentHeight / 2 - diameter / 2,
                          width: diameter,
                          height: diameter)
            .insetBy(dx: 0, dy: 0)
        self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath

        switch selectionType {
        case .single:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = false

        case .none:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = true
            
        case .middle:
            self.titleLabel.textColor = .bappyBrown
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = true

            let selectionRect = selectionLayerBounds
                .insetBy(dx: 0.0, dy: 1)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath

        case .leftBorder:
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = false

            let selectionRect = selectionLayerBounds
                .insetBy(dx: selectionLayerWidth / 4, dy: 1)
                .offsetBy(dx: selectionLayerWidth / 4, dy: 0.0)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath

        case .rightBorder:
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = false

            let selectionRect = selectionLayerBounds
                .insetBy(dx: selectionLayerWidth / 4, dy: 1)
                .offsetBy(dx: -selectionLayerWidth / 4, dy: 0.0)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath

        }
    }
}
