//
//  HomeListViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/19.
//

import UIKit
import SnapKit

private let reuseIdentifier = "HangoutCell"
final class HomeListViewController: UIViewController {
    
    // MARK: Properties
    // 임시 변수
    private var hangoutList: [Hangout] = [
        Hangout(
            id: "abc", state: .available, title: "Who wants to go eat?",
            meetTime: "03. Mar. 19:00", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [
                (id: "abc", imageURL: nil),
                (id: "abc", imageURL: URL(string: EXAMPLE_IMAGE1_URL))
            ],
            userHasLiked: true),
        Hangout(
            id: "def", state: .expired, title: "Who wants to go eat?",
            meetTime: "05. Mar. 20:00", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [(id: "def", imageURL: nil)],
            userHasLiked: false),
        Hangout(
            id: "hij", state: .closed, title: "Who wants to go eat?",
            meetTime: "08. Mar. 19:30", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE3_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [(id: "qwer", imageURL: nil)],
            userHasLiked: true),
        Hangout(
            id: "abc", state: .available, title: "Who wants to go eat?",
            meetTime: "03. Mar. 19:00", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [(id: "qwer", imageURL: nil)],
            userHasLiked: true),
        Hangout(
            id: "def", state: .available, title: "Who wants to go eat?",
            meetTime: "05. Mar. 20:00", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [(id: "qwer", imageURL: nil)],
            userHasLiked: false),
        Hangout(
            id: "hij", state: .available, title: "Who wants to go eat?",
            meetTime: "08. Mar. 19:30", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE3_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [(id: "qwer", imageURL: nil)],
            userHasLiked: true),
        Hangout(
            id: "abc", state: .available, title: "Who wants to go eat?",
            meetTime: "03. Mar. 19:00", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE1_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [(id: "qwer", imageURL: nil)],
            userHasLiked: true),
        Hangout(
            id: "def", state: .available, title: "Who wants to go eat?",
            meetTime: "05. Mar. 20:00", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE2_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [(id: "qwer", imageURL: nil)],
            userHasLiked: false),
        Hangout(
            id: "hij", state: .available, title: "Who wants to go eat?",
            meetTime: "08. Mar. 19:30", language: "English",
            placeName: "Pusan University",
            plan: "Hey guys, this is LIly. I want to go on a picnic. This Sat urday to Haeundae Anyone wanna join? Hey guys, this is LIly. I want to go on a picnic. This Saturday to Haeundae Anyone wanna join?",
            limitNumber: 5, latitude: 35.2342279, longitude: 129.0860221,
            postImageURL: URL(string: EXAMPLE_IMAGE3_URL),
            openchatURL: URL(string: "https://open.kakao.com/o/gyeerYje"),
            mapImageURL: URL(string: EXAMPLE_MAP_URL),
            googleMapURL: URL(string: "https://www.google.com/maps/dir/?api=1&destination=PNU+maingate&destination_place_id=ChIJddvJ8eqTaDURk21no4Umdvo"),
            kakaoMapURL: URL(string: "https://map.kakao.com/link/to/abcdefu,37.402056,127.108212"),
            participantIDs: [(id: "qwer", imageURL: nil)],
            userHasLiked: true),
        
    ]
    private var hasShown: Bool = false
    
    private let topView = HomeListTopView()
    private let topSubView = HomeListTopSubView()
    private let tableView = UITableView()
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        configureTableView()
        configureRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc func refresh() {
        self.tableView.refreshControl?.endRefreshing()
    }

    // MARK: Helpers
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(HangoutCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UIScreen.main.bounds.width / 390.0 * 333.0 + 11.0
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        let refreshControl = self.tableView.refreshControl
        refreshControl?.backgroundColor = .white
        refreshControl?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func configure() {
        view.backgroundColor = .white
        topView.delegate = self
        topSubView.delegate = self
    }
    
    private func layout() {
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(topSubView)
        topSubView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(topSubView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hangoutList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HangoutCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.bind(with: hangoutList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeListViewController: HangoutCellDelegate {
    func showDetailView(_ indexPath: IndexPath) {
        let dependency: HangoutDetailViewModel.Dependency = .init(
            currentUser: User(id: "abc", state: .anonymous),
            hangout: hangoutList[indexPath.row],
            postImage: nil,
            mapImage: nil
        )
        let viewModel = HangoutDetailViewModel(dependency: dependency)
        let viewController = HangoutDetailViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - HomeListTopViewDelegate
extension HomeListViewController: HomeListTopViewDelegate {
    func localeButtonTapped() {
        guard let tabBarController = tabBarController else { return }
        let viewController = HomeLocaleViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        tabBarController.present(viewController, animated: false)
    }
    
    func searchButtonTapped() {
        let viewController = HomeSearchViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func filterButtonTapped() {
        //
    }
}

// MARK: - HomeListTopSubViewDelegate
extension HomeListViewController: HomeListTopSubViewDelegate {
    func sortingOrderButtonTapped() {
        let point: CGPoint = .init(
            x: topSubView.frame.maxX - 7.0,
            y: topSubView.frame.maxY - 12.0
        )
        let viewController = SortingOrderViewController(upperRightPoint: point)
        viewController.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(viewController, animated: true)
    }
}
