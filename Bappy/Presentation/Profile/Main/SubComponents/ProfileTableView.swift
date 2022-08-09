//
//  ProfileTableView.swift
//  Bappy
//
//  Created by 정동천 on 2022/08/06.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileTableView: UITableView {
    
    private var hasUpdatedConstraints: Bool = false
    
    override func updateConstraints() {
        super.updateConstraints()
        
        hasUpdatedConstraints = true
    }
    
    override func reloadData() {
        let offset = contentOffset
 
        UIView.animate(withDuration: 0) {
            super.reloadData()
        }
        
        if hasUpdatedConstraints {
            layoutIfNeeded()
        }
        
        DispatchQueue.main.async {
            self.contentOffset = offset
        }
    }
}
