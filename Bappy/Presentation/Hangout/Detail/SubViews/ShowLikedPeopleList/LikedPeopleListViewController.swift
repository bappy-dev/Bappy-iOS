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
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Like"
        lbl.font = .roboto(size: 21, family: .Medium)
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    private let closeBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "  Close", style: .plain, target: nil, action: nil)
        button.setTitleTextAttributes([
            .font: UIFont.roboto(size: 18.0, family: .Medium)
        ], for: .normal)
        return button
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(LikedPeopleCell.self, forCellReuseIdentifier: LikedPeopleCell.reuseIndentifier)
        view.separatorStyle = .none
        view.backgroundColor = .bappyLightgray
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
        navigationItem.title = "Like"
        
        navigationItem.leftBarButtonItem = closeBtn
        
        self.view.backgroundColor = .bappyLightgray
    }
    
    private func layout() {
        let seperateView = UIView()
        seperateView.backgroundColor = .black
        
        self.view.addSubviews([titleLbl, seperateView, tableView])
        
        titleLbl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
        }
        //
        //        closeBtn.snp.makeConstraints {
        //            $0.centerY.equalTo(titleLbl.snp.centerY)
        //            $0.leading.equalToSuperview().inset(20)
        //        }
        
        seperateView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLbl.snp.bottom).offset(15)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(seperateView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension LikedPeopleListViewController {
    private func bind() {
        closeBtn.rx.tap
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
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
