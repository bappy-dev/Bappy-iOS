//
//  SortingOrderViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let reuseIndentifier = "SortingOrderCell"
final class SortingOrderViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: SortingOrderViewModel
    private let disposeBag = DisposeBag()
    
    private let upperRightPoint: CGPoint
    private let maxDimmedAlpha: CGFloat = 0.3
    
    private let containerView = UIView()
    private let dimmedView = UIView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SortingOrderCell.self, forCellReuseIdentifier: reuseIndentifier)
        tableView.rowHeight = 45.0
        tableView.separatorInset = .init(top: 0, left: 17.0, bottom: 0, right: 16.0)
        tableView.backgroundColor = .bappyLightgray
        tableView.isScrollEnabled = false
        return tableView
    }()
   
    // MARK: Lifecycle
    init(viewModel: SortingOrderViewModel, upperRightPoint: CGPoint) {
        self.viewModel = viewModel
        self.upperRightPoint = upperRightPoint
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configureShadow()
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
    
    private func animatePresentContainer(height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }

        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 0
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            completion?()
        }
    }
    
    // MARK: Helpers
    private func configureShadow() {
        containerView.addBappyShadow(shadowOffsetHeight: 3.0)
    }
    
    private func configure() {
        view.backgroundColor = .clear
        containerView.backgroundColor = .clear
        tableView.layer.cornerRadius = 6.0
        tableView.clipsToBounds = true
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

// MARK: - Bind
extension SortingOrderViewController {
    private func bind() {
        self.rx.viewDidAppear
            .withLatestFrom(viewModel.output.sortingList)
            .bind(onNext: { [weak self] sortings in
                let height: CGFloat = CGFloat(sortings.count * 45)
                self?.animateShowDimmedView()
                self?.animatePresentContainer(height: height)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.sortingList
            .drive(tableView.rx.items) { tableView, row, sorting in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIndentifier,
                    for: IndexPath(row: row, section: 0)
                ) as! SortingOrderCell
                cell.text = sorting.description
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.output.popViewWithSorting
            .compactMap { $0 }
            .emit(onNext: { [weak self] sorting in
                self?.animateDismissView(completion: {
                    self?.viewModel.delegate?.selectedSorting(sorting)
                })
            })
            .disposed(by: disposeBag)
    }
}
