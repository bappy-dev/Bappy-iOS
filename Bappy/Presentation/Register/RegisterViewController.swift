//
//  RegisterNameViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit
import SnapKit
//import RxSwift
//import RxCocoa

final class RegisterViewController: UIViewController {
    
    // MARK: Properties
    private var page: Int = 0 {
        didSet {
            let x: CGFloat = UIScreen.main.bounds.width * CGFloat(page)
            let offset = CGPoint(x: x, y: 0)
            scrollView.setContentOffset(offset, animated: true)
            progressBarView.updateProgression(CGFloat(page + 1) / 4.0)
        }
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron_back"), for: .normal)
        button.imageEdgeInsets = .init(top: 13.0, left: 16.5, bottom: 13.0, right: 16.5)
        button.addTarget(self, action: #selector(backButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let progressBarView = ProgressBarView()
    private let continueButtonView = ContinueButtonView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nameView = RegisterNameView()
    private let genderView = RegisterGenderView()
    private let birthView = RegisterBirthView()
    private let nationalityView = RegisterNationalityView()
    
    // MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        configure()
        layout()
        addKeyboardObserver()
        addTapGestureOnScrollView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressBarView.initializeProgression(1.0/4.0)
        continueButtonView.isEnabled = true
    }

    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        view.endEditing(true)
    }
    
    @objc
    private func touchesScrollView() {
        view.endEditing(true)
    }
    
    // MARK: Actions
    @objc
    private func keyboardHeightObserver(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = view.frame.height - keyboardFrame.minY
        let bottomPadding = (keyboardHeight != 0) ? view.safeAreaInsets.bottom : view.safeAreaInsets.bottom * 2.0 / 3.0

        UIView.animate(withDuration: 0.4) {
            self.continueButtonView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomPadding - keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func backButtonHandler() {
        view.endEditing(true)
        guard page > 0 else {
            self.dismiss(animated: true)
            return
        }
        page -= 1
        continueButtonView.isEnabled = true
    }
    
    // MARK: Helpers
    private func addTapGestureOnScrollView() {
        let scrollViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchesScrollView))
        scrollView.addGestureRecognizer(scrollViewTapRecognizer)
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configure() {
        view.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        nationalityView.delegate = self
        continueButtonView.delegate = self
    }
    
    private func layout() {
        view.addSubview(progressBarView)
        progressBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(15.0)
            $0.leading.equalToSuperview().inset(5.5)
            $0.width.height.equalTo(44.0)
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        view.addSubview(nameView)
        nameView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
        }
        
        view.addSubview(genderView)
        genderView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(nameView.snp.trailing)
        }
        
        view.addSubview(birthView)
        birthView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(genderView.snp.trailing)
        }
        
        view.addSubview(nationalityView)
        nationalityView.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(contentView)
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(birthView.snp.trailing)
        }
        
        view.addSubview(continueButtonView)
        continueButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(bottomPadding * 2.0 / 3.0)
        }
    }
}

// MARK: - RegisterNationalityViewDelegate
extension RegisterViewController: RegisterNationalityViewDelegate {
    func showSelectNationalityView() {
        view.endEditing(true) // 임시
        let viewController = SelectNationalityViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = self
        present(viewController, animated: false, completion: nil)
    }
}

// MARK: - SelectNationalityViewControllerDelegate
extension RegisterViewController: SelectNationalityViewControllerDelegate {
    func getSelectedCountry(_ country: Country) {
        nationalityView.country = country
    }
}

// MARK: - ContinueButtonViewDelegate
extension RegisterViewController: ContinueButtonViewDelegate {
    func continueButtonTapped() {
        view.endEditing(true)
        page += 1
//        continueButtonView.isEnabled = false / asdfasdffsd
    }
}

//final class RegisterViewController: UIViewController {
//
//    // MARK: Properties
//    private let viewModel: RegisterViewModel
//    private var page: Int = 0 {
//        didSet { print("DEBUG: page \(page)") }
//    }
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .roboto(size: 18.0, family: .Medium)
//        label.text = "CREATE AN ACCOUNT"
//        label.textColor = UIColor(named: "bappy_brown")
//        return label
//    }()
//
//    private let progressBarView = ProgressBarView()
//    private let scrollView = UIScrollView()
//    private let contentView = UIView()
//    private let bottomButtonView: BottomButtonView
//
//    private let disposeBag = DisposeBag()
//
//    // MARK: Lifecycle
//    init(viewModel: RegisterViewModel = RegisterViewModel()) {
//        self.viewModel = viewModel
//        self.bottomButtonView = BottomButtonView(viewModel: viewModel.subViewModels.bottomButtonViewModel)
//        super.init(nibName: nil, bundle: nil)
//
//        bind()
//        configure()
//        layout()
//        addKeyboardObserver()
//        addTapGestureOnScrollView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        progressBarView.initializeProgression(1.0/7.0)
//    }
//
//    // MARK: Events
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        view.endEditing(true)
//    }
//
//    @objc
//    private func touchesScrollView() {
//        view.endEditing(true)
//    }
//
//    // MARK: Actions
//    @objc
//    private func keyboardHeightObserver(_ notification: NSNotification) {
//        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        let keyboardHeight = view.frame.height - keyboardFrame.minY
//
//        UIView.animate(withDuration: 0.3) {
//            self.bottomButtonView.snp.updateConstraints {
//                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-1 * keyboardHeight)
//            }
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    // MARK: Helpers
//    private func bind() {
//        contentView.rx.numOfSubviews
//            .bind(to: viewModel.input.numOfPage)
//            .disposed(by: disposeBag)
//
//        viewModel.output.pageContentOffset
//            .drive(scrollView.rx.setContentOffset)
//            .disposed(by: disposeBag)
//
////        viewModel.output.pageContentOffset
////            .drive(view.rx.endEditing)
////            .disposed(by: disposeBag)
//
//        viewModel.output.progression
//            .drive(progressBarView.rx.setProgression)
//            .disposed(by: disposeBag)
//
//        viewModel.output.showSuccessView
//            .emit { [weak self] _ in
//                guard let self = self else { return }
//                let viewController = RegisterSuccessViewController()
//                self.navigationController?.pushViewController(viewController, animated: true)
////                self.present(viewController, animated: true)
//            }
//            .disposed(by: disposeBag)
//    }
//
//    private func addTapGestureOnScrollView() {
//        let scrollViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchesScrollView))
//        scrollView.addGestureRecognizer(scrollViewTapRecognizer)
//    }
//
//    private func addKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightObserver), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    private func configure() {
//        view.backgroundColor = .white
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isScrollEnabled = false
//
//    }
//
//    private func layout() {
//        view.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
//            $0.centerX.equalToSuperview()
//        }
//
//        view.addSubview(progressBarView)
//        progressBarView.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(28.0)
//            $0.leading.trailing.equalToSuperview().inset(23.0)
//        }
//
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints {
//            $0.top.equalTo(progressBarView.snp.bottom).offset(25.0)
//            $0.leading.trailing.bottom.equalToSuperview()
//        }
//
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//            $0.height.equalToSuperview()
//        }
//
//        let nameView = RegisterNameView()
//        let genderView = RegisterGenderView()
//        let birthView = RegisterBirthView()
//        let nationalityView = RegisterNationalityView()
//        let languageView = RegisterLanguageView()
//        let personalityView = RegisterPersonalityView()
//        let hobbyView = RegisterHobbyView()
//
//        contentView.addSubview(nameView)
//        nameView.snp.makeConstraints {
//            $0.top.leading.bottom.equalToSuperview()
//            $0.width.equalTo(view.frame.width)
//        }
//
//        contentView.addSubview(genderView)
//        genderView.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview()
//            $0.width.equalTo(view.frame.width)
//            $0.leading.equalTo(nameView.snp.trailing)
//        }
//
//        contentView.addSubview(birthView)
//        birthView.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview()
//            $0.width.equalTo(view.frame.width)
//            $0.leading.equalTo(genderView.snp.trailing)
//        }
//
//        contentView.addSubview(nationalityView)
//        nationalityView.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview()
//            $0.width.equalTo(view.frame.width)
//            $0.leading.equalTo(birthView.snp.trailing)
//        }
//
//        contentView.addSubview(languageView)
//        languageView.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview()
//            $0.width.equalTo(view.frame.width)
//            $0.leading.equalTo(nationalityView.snp.trailing)
//        }
//
//        contentView.addSubview(personalityView)
//        personalityView.snp.makeConstraints {
//            $0.top.bottom.equalToSuperview()
//            $0.width.equalTo(view.frame.width)
//            $0.leading.equalTo(languageView.snp.trailing)
//        }
//
//        contentView.addSubview(hobbyView)
//        hobbyView.snp.makeConstraints {
//            $0.top.bottom.trailing.equalToSuperview()
//            $0.width.equalTo(view.frame.width)
//            $0.leading.equalTo(personalityView.snp.trailing)
//        }
//
//        view.addSubview(bottomButtonView)
//        bottomButtonView.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//}
//
//// MARK: Binder
//// MainScheduler에서 수행, Observer only -> 값을 주입할 수 있지만, 값을 관찰할 수 없음
//extension Reactive where Base: UIScrollView {
//    var setContentOffset: Binder<CGPoint> {
//        return Binder(self.base) { scrollView, offset in
//            scrollView.setContentOffset(offset, animated: true)
//        }
//    }
//}
//
//// MARK: ControlEvent
//// MainScheduler에서 수행, Observable only -> 값을 관찰할 수 있지만, 값을 주입할 수 없음
//extension Reactive where Base: UIView {
//    var numOfSubviews: ControlEvent<Int> {
//        let source = self.methodInvoked(#selector(Base.didAddSubview)).map { _ in base.subviews.count }
//        return ControlEvent(events: source)
//    }
//}
