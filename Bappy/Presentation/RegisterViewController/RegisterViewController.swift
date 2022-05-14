//
//  RegisterNameViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/10.
//

import UIKit
import SnapKit

final class RegisterViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: RegisterViewModel
    private var page: Int = 0 {
        didSet { print("DEBUG: page \(page)") }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 18.0, family: .Medium)
        label.text = "CREATE AN ACCOUNT"
        label.textColor = UIColor(red: 86.0/255.0, green: 69.0/255.0, blue: 8.0/255.0, alpha: 1.0)
        return label
    }()
    
    private let progressBarView = ProgressBarView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let bottomButtonView = BottomButtonView()
    
    // MARK: Lifecycle
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
        addKeyboardObserver()
        addTapGestureOnScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressBarView.updateProgression(1.0/7.0)
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
    private func previousButtonHandler() {
        guard page > 0 else { return }
        page -= 1
        let offset = view.frame.width * CGFloat(page)
        let progression = CGFloat(page + 1) / 7.0
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        progressBarView.updateProgression(progression)
        view.endEditing(true)
    }
    
    private func nextButtonHandler() {
        guard page < 6 else { return }
        page += 1
        let offset = view.frame.width * CGFloat(page)
        let progression = CGFloat(page + 1) / 7.0
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        progressBarView.updateProgression(progression)
        view.endEditing(true)
    }
    
    @objc
    private func keyboardHeightObserver(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = view.frame.height - keyboardFrame.minY

        UIView.animate(withDuration: 0.3) {
            self.bottomButtonView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-1 * keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
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
        bottomButtonView.delegate = self
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(progressBarView)
        progressBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview().inset(23.0)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(25.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        let nameView = RegisterNameView()
        let genderView = RegisterGenderView()
        let birthView = RegisterBirthView()
        let nationalityView = RegisterNationalityView()
        let languageView = RegisterLanguageView()
        let personalityView = RegisterPersonalityView()
        let hobbyView = RegisterHobbyView()
        
        contentView.addSubview(nameView)
        nameView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
        }
        
        contentView.addSubview(genderView)
        genderView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(nameView.snp.trailing)
        }
        
        contentView.addSubview(birthView)
        birthView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(genderView.snp.trailing)
        }
        
        contentView.addSubview(nationalityView)
        nationalityView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(birthView.snp.trailing)
        }
        
        contentView.addSubview(languageView)
        languageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(nationalityView.snp.trailing)
        }
        
        contentView.addSubview(personalityView)
        personalityView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(languageView.snp.trailing)
        }
        
        contentView.addSubview(hobbyView)
        hobbyView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(view.frame.width)
            $0.leading.equalTo(personalityView.snp.trailing)
        }
        
        view.addSubview(bottomButtonView)
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: BottomButtonViewDelegate
extension RegisterViewController: BottomButtonViewDelegate {
    func didTapPreviousButton() {
        previousButtonHandler()
    }
    
    func didTapNextButton() {
        nextButtonHandler()
    }
}
