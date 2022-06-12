//
//  CountryListView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/13.
//

import UIKit
import SnapKit

//private let reuseIdentifier = "CountryCell"
//final class CountryListView: UIView {
//
//    // MARK: Properties
//    private var countries: [Country]
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(countryCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 15.0)
//        tableView.separatorColor = UIColor(named: "bappy_gray")
//        return tableView
//    }()
//
//    // MARK: Lifecycle
//    override init(frame: CGRect) {
//        self.countries = NSLocale.isoCountryCodes
//            .map { NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $0]) }
//            .map { countryCode -> Country in
//                let code = String(countryCode[countryCode.index(after: countryCode.startIndex)...])
//                let name = NSLocale(localeIdentifier: "en_UK")
//                    .displayName(forKey: NSLocale.Key.identifier, value: countryCode) ?? ""
//                return Country(code: code, name: name)
//            }
//        super.init(frame: frame)
//
//        configure()
//        layout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: Helpers
//    private func configure() {
//        self.backgroundColor = UIColor(named: "bappy_lightgray")
//        self.layer.cornerRadius = 14.0
//        tableView.backgroundColor = UIColor(named: "bappy_lightgray")
//    }
//
//    private func layout() {
//        self.snp.makeConstraints { $0.height.equalTo(253.0) }
//
//        self.addSubview(tableView)
//        tableView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(8.0)
//            $0.leading.equalToSuperview().inset(30.0)
//            $0.trailing.equalToSuperview().inset(20.0)
//            $0.bottom.equalToSuperview().inset(20.0)
//        }
//    }
//}
//// MARK: UITableViewDataSource
//extension CountryListView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return countries.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! countryCell
//        cell.country = countries[indexPath.row]
//        return cell
//    }
//}
//
//// MARK: UITableViewDelegate
//extension CountryListView: UITableViewDelegate {
//
//}
//
