//
//  SortingOrderViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import SnapKit

protocol SortingOrderViewControllerDelegate: AnyObject {
    
}

private let reuseIndentifier = "SortingOrderCell"
final class SortingOrderViewController: UIViewController {
    
    // MARK: Properties
    weak var delegate: SortingOrderViewControllerDelegate?
    private var sortingList: [String] = [
        "Newest", "Nearest", "Many views", "Many hearts", "Less seats"
    ]
    
    private let upperRightPoint: CGPoint
    private let maxDimmedAlpha: CGFloat = 0.3
    
    private let containerView = UIView()
    private let dimmedView = UIView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SortingOrderCell.self, forCellReuseIdentifier: reuseIndentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 45.0
        tableView.separatorInset = .init(top: 0, left: 17.0, bottom: 0, right: 16.0)
        tableView.backgroundColor = .bappyLightgray
        return tableView
    }()
   
    // MARK: Lifecycle
    init(upperRightPoint: CGPoint) {
        self.upperRightPoint = upperRightPoint
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        dimmedView.backgroundColor = .black
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        let height = sortingList.count * 45
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
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
        containerView.backgroundColor = .clear
        tableView.layer.cornerRadius = 6.0
        tableView.clipsToBounds = true
        containerView.addBappyShadow(shadowOffsetHeight: 3.0)
    }
    
    private func layout() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(upperRightPoint.y)
            $0.trailing.equalTo(view.snp.leading).offset(upperRightPoint.x)
            $0.width.equalTo(150.0)
            $0.height.equalTo(0)
        }
        
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension SortingOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifier, for: indexPath) as! SortingOrderCell
        cell.text = sortingList[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SortingOrderViewController: UITableViewDelegate {
    
}
