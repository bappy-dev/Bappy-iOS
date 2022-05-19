//
//  MyListViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

final class MyListViewController: UIViewController {
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
