//
//  LikedPeopleListViewController.swift
//  Bappy
//
//  Created by 이현욱 on 2022/11/01.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class LikedPeopleListViewController: UIViewController {
    let viewModel: LikedPeopleListViewModel
    var disposeBag = DisposeBag()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(LikedPeopleCell.self, forCellReuseIdentifier: LikedPeopleCell.reuseIndentifier)
        view.separatorStyle = .none
        view.rowHeight = 80
        return view
    }()
    
    // MARK: Lifecycle
    init(viewModel: LikedPeopleListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.view.backgroundColor = .bappyLightgray
    }
    
    private func layout() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension LikedPeopleListViewController {
    private func bind() {
        tableView.rx.modelSelected(Hangout.Info.self)
            .map { [weak self] info in
                self?.dismiss(animated: true)
                return info.id
            }
            .bind(to: viewModel.input.selectedUserID)
            .disposed(by: disposeBag)
        
        viewModel.output.likedIDs
            .drive(tableView.rx.items(cellIdentifier: LikedPeopleCell.reuseIndentifier, cellType: LikedPeopleCell.self)) { _, element, cell in
                cell.bind(element)
            }.disposed(by: disposeBag)
    }
}
