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
    
    override func reloadData() {
        let offset = contentOffset
 
        UIView.animate(withDuration: 0) {
            super.reloadData()
        }
        
        layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.contentOffset = offset
        }
    }
}
