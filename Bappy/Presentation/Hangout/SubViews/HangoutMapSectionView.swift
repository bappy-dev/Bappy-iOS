//
//  HangoutMapSectionView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/23.
//

import UIKit
import SnapKit

final class HangoutMapSectionView: UIView {
    
    // MARK: Properties
    private let mapView = UIView()
    
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
        self.backgroundColor = .white
        mapView.backgroundColor = UIColor(named: "bappy_yellow")
        mapView.layer.cornerRadius = 16.0
    }
    
    private func layout() {
        self.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(27.0)
            $0.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(mapView.snp.width).multipliedBy(129.0/339.0)
        }
        
        let label = UILabel()
        label.font = .roboto(size: 30.0, family: .Bold)
        label.text = "카카오맵??"
        label.textColor = UIColor(named: "bappy_brown")
        mapView.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
