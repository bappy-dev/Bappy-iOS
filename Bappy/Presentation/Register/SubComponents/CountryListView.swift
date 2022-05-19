//
//  CountryListView.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/13.
//

import UIKit
import SnapKit

final class CountryListView: UIView {
    
    // MARK: Properties
    private var countries: [Country]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(countryCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 15.0)
        tableView.separatorColor = UIColor(red: 134.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1.0)
        return tableView
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        self.countries = NSLocale.isoCountryCodes
            .map { NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $0]) }
            .map { countryCode -> Country in
                let code = String(countryCode[countryCode.index(after: countryCode.startIndex)...])
                let name = NSLocale(localeIdentifier: "en_UK")
                    .displayName(forKey: NSLocale.Key.identifier, value: countryCode) ?? ""
                return Country(code: code, name: name)
            }
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.layer.cornerRadius = 14.0
        tableView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    }
    
    private func layout() {
        self.snp.makeConstraints { $0.height.equalTo(253.0) }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalToSuperview().inset(30.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(20.0)
        }
    }
}
// MARK: UITableViewDataSource
extension CountryListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! countryCell
        cell.country = countries[indexPath.row]
        return cell
    }
}

// MARK: UITableViewDelegate
extension CountryListView: UITableViewDelegate {
    
}

// MARK: UITableViewCell
final class countryCell: UITableViewCell {
    
    // MARK: Properties
    var country: Country? {
        didSet {
            guard let country = country else { return }
            countryLabel.text = country.name
            countryFlagLabel.text = flag(code: country.code)
        }
    }
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 15.0)
        label.textColor = UIColor(red: 86.0/255.0, green: 69.0/255.0, blue: 8.0/255.0, alpha: 1.0)
        return label
    }()
    
    private let countryFlagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 33.0)
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func flag(code:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    private func configure() {
        contentView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    }
    
    private func layout() {
        contentView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10.0)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(countryFlagLabel)
        countryFlagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15.0)
        }
    }
}
