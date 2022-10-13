//
//  BappyDropdownView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "BappyDropdownCell"

final class BappyDropdownView: UIView {
    
    // MARK: Properties
    private let viewModel: BappyDropdownViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BappyDropdownCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorInset = .init(top: 0, left: 10.0, bottom: 0, right: 15.0)
        tableView.separatorColor = .rgb(212, 209, 197, 1)
        tableView.rowHeight = 34.5
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: Lifecycle
    init(viewModel: BappyDropdownViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    // MARK: Helpers
    private func configureShadow() {
        self.addBappyShadow()
    }
    
    private func configure() {
        self.backgroundColor = .bappyLightgray
        self.layer.cornerRadius = 23.0
    }
    
    private func layout() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview().inset(10.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - Bind
extension BappyDropdownView {
    private func bind() {
        tableView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.dropdownList
            .drive(tableView.rx.items) { tableView, row, text in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: IndexPath(row: row, section: 0)
                ) as! BappyDropdownCell
                cell.text = text
                return cell
            }
            .disposed(by: disposeBag)
    }
}
