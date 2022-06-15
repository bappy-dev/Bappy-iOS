//
//  ReportTypeDropdownView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/24.
//

import UIKit
import SnapKit

private let reuseIdentifier = "ReportTypeCell"

protocol ReportTypeDropdownViewDelegate: AnyObject {
    func didSelectText(_ text: String)
}

final class ReportTypeDropdownView: UIView {
    
    // MARK: Properties
    weak var delegate: ReportTypeDropdownViewDelegate?
    
    private var reportTypeList: [String] = [
        "The post is too violent.",
        "The post is false information.",
        "The post is is hate speech.",
        "The post is scam or fraud.",
        "The post is sexual activity.",
        "Something else",
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReportTypeCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 15.0)
        tableView.separatorColor = UIColor(red: 212.0/255.0, green: 209.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        tableView.rowHeight = 34.5
        tableView.backgroundColor = .clear
        return tableView
    }()
    
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
        self.backgroundColor = .bappyLightgray
        self.layer.cornerRadius = 23.0
        self.addBappyShadow()
        self.isHidden = true
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

// MARK: UITableViewDataSource
extension ReportTypeDropdownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ReportTypeCell
        cell.text = reportTypeList[indexPath.row]
        return cell
    }
}

// MARK: UITableViewDelegate
extension ReportTypeDropdownView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectText(reportTypeList[indexPath.row])
    }
}
