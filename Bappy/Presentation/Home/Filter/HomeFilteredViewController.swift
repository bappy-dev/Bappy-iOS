//
//  HomeFilteredViewController.swift
//  Bappy
//
//  Created by 이현욱 on 2022/10/20.
//

import UIKit

import RxSwift
import SnapKit
import RxCocoa

final class HomeFilteredViewController: UIViewController {
    private let viewModel: HomeFilteredViewModel
    private var disposeBag = DisposeBag()
    private let holderView = HomeListHolderView()
    private var filterVC: HomeFilterViewController?
    
    private let noResultView = NoResultView()
    
    private let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        return btn
    }()
    
    private let notFilteredStackView: UIStackView = {
        let stackView = UIStackView()
        lazy var notFilteredImageView: UIImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 170, height: 237))
            view.image = UIImage(named: "bappy_stupid")
            view.contentMode = .scaleAspectFit
            return view
        }()
        
        lazy var notFilteredLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = "Set the Filter!"
            lbl.textAlignment = .center
            lbl.textColor = .bappyBrown
            lbl.font = .roboto(size: 25.0, family: .Medium)
            return lbl
        }()
        
        stackView.addArrangedSubviews([notFilteredImageView, notFilteredLbl])
        stackView.spacing = 48
        stackView.axis = .vertical
        return stackView
    }()
    
    private let filterInfoLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Filter"
        lbl.font = .roboto(size: 25.0, family: .Medium)
        lbl.textColor = .bappyBrown
        return lbl
    }()
    
    private let filteringBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "home_filter"), for: .normal)
        return btn
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HangoutCell.self, forCellReuseIdentifier: HangoutCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UIScreen.main.bounds.width / 390.0 * 333.0 + 11.0
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .white
        refreshControl.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return refreshControl
    }()
    
    // MARK: Lifecycle
    init(viewModel: HomeFilteredViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.view.backgroundColor = .white
        holderView.isHidden = true
        noResultView.isHidden = true
        tableView.refreshControl = refreshControl
    }
    
    func layout() {
        let seperateView = UIView()
        seperateView.backgroundColor = .bappyGray
        
        self.view.addSubviews([backBtn, filterInfoLbl,filteringBtn, seperateView, tableView, holderView, notFilteredStackView, noResultView])
        
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15.0)
            $0.leading.equalToSuperview().inset(5.5)
            $0.width.height.equalTo(44.0)
        }
        
        filterInfoLbl.snp.makeConstraints {
            $0.centerY.equalTo(backBtn.snp.centerY)
            $0.leading.equalTo(backBtn.snp.trailing).offset(4)
            $0.height.equalTo(29.4)
        }
        
        filteringBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17)
            $0.centerY.equalTo(filterInfoLbl.snp.centerY)
        }
        
        seperateView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(filterInfoLbl.snp.bottom).offset(13)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(seperateView.snp.bottom).offset(13)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        holderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(seperateView.snp.bottom).offset(13)
        }
        
        notFilteredStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        noResultView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension HomeFilteredViewController {
    func bind() {
        backBtn.rx.tap
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refresh)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in }
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
        
        filteringBtn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.filteringView)
            .disposed(by: disposeBag)
        
        self.rx.viewWillDisappear
            .bind { [weak self] _ in
                self?.filterVC = nil
            }.disposed(by: disposeBag)
        
        viewModel.output.cellViewModels
            .skip(1)
            .map { [weak self] value in
                self?.filterVC?.dismiss(animated: true)
                self?.noResultView.isHidden = !value.isEmpty
                return value
            }
            .drive(tableView.rx.items(cellIdentifier: HangoutCell.reuseIdentifier, cellType: HangoutCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
        
        viewModel.output.endRefreshing
            .map { _ in false }
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.output.hideHolderView
            .distinctUntilChanged()
            .emit(onNext: { [weak self] value in
                self?.holderView.isHidden = value
                self?.notFilteredStackView.isHidden = true
            }).disposed(by: disposeBag)
        
        viewModel.output.showFilteringView
            .compactMap { $0 }
            .emit(onNext: { [weak self] viewModel in
                guard let `self` = self else { return }
                if self.filterVC == nil {
                    self.filterVC = HomeFilterViewController(viewModel: viewModel)
                }
                
                let configuration = UIImage.SymbolConfiguration(pointSize: 15.0, weight: .medium)
                let image = UIImage(systemName: "xmark", withConfiguration: configuration)
                
                let presentVC = BappyPresentBaseViewController(baseViewController: self.filterVC!,
                                                               title: "Filter",
                                                               leftBarButton: UIBarButtonItem(image: image, style: .plain, target: nil, action: nil),
                                                               rightBarButton: nil,
                                                               backBarButton: nil)
                
                presentVC.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(presentVC,  animated: true)
            })
            .disposed(by: disposeBag)
    }
}
