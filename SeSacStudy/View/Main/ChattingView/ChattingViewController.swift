//
//  ChattingViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard


final class ChattingViewController: RxBaseViewController {
    
    // MARK: - Propertys
    private let viewModel = ChattingViewModel()
    
    private var isMoreViewExpanded = false {
        didSet { customView.showUpMoreExpandedView(isMoreViewExpanded) }
    }
    
    
    
    
    // MARK: - Life Cycle
    private let customView = ChattingView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBarUI()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        if DataStorage.shared.matchedUser.id == "" {
            requestQueueStatus()
        }else {
            updateUI()
        }
        
        setNavigationBar()
        setTableView()
        
        bind()
        keyboardBind()
    }
    
    
    private func setTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        
        customView.tableView.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.identifier)
        customView.tableView.register(ChattingTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ChattingTableViewHeader.identifier)
    }
    
    
    private func setNavigationBar() {
        let moreButton = UIBarButtonItem(image: R.image.more(), style: .plain, target: self, action: #selector(moreButtonTapped))
        navigationItem.rightBarButtonItem = moreButton
        
        navigationItem.setHidesBackButton(true, animated: true)
        
        let backButton = UIBarButtonItem(image: R.image.arrow(), style: .plain, target: self, action: #selector(popToRootView))
        navigationItem.leftBarButtonItem = backButton
    }
    
    
    private func updateBarUI() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    
    private func updateUI() {
        navigationItem.title = DataStorage.shared.matchedUser.nick
        // ⭐️ Header Title 변경하기
    }
    
    
    private func bind() {
        let rxTextView = customView.chatInputView.textView.rx
        let expandView = customView.moreExpandedView
        let input = ChattingViewModel.Input(text: rxTextView.text, beginEditing: rxTextView.didBeginEditing, endEditing: rxTextView.didEndEditing, reportTap: expandView.reportButton.rx.tap, cancelTap: expandView.cancelButton.rx.tap, reviewTap: expandView.reviewButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.line
            .withUnretained(self)
            .bind { (vc, value) in
                vc.customView.updateTextViewHeight(line: value)
            }
            .disposed(by: disposeBag)
        
        output.sendButtonEnable
            .withUnretained(self)
            .bind { (vc, value) in
                vc.customView.updateSendButton(value)
            }
            .disposed(by: disposeBag)
        
        output.beginEditing
            .withUnretained(self)
            .bind{ (vc, _) in
                if vc.customView.chatInputView.textView.text == Placeholder.chatting.rawValue {
                    vc.customView.chatInputView.textView.text = ""
                }
                vc.customView.chatInputView.textView.textColor = R.color.black()
            }.disposed(by: disposeBag)
        
        output.endEditing
            .withUnretained(self)
            .bind{ (vc, _) in
                if vc.customView.chatInputView.textView.text.count == 0 {
                    vc.customView.chatInputView.textView.text = Placeholder.chatting.rawValue
                    vc.customView.chatInputView.textView.textColor = R.color.gray7()
                }
            }.disposed(by: disposeBag)
        
        setMoreViewButtonAction(output: output)
    }
    
    
    private func setMoreViewButtonAction(output: ChattingViewModel.Output) {
        customView.moreExpandedView.dismissButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        output.reportTap
            .withUnretained(self)
            .bind { (vc, _) in
                print("report tap")
            }
            .disposed(by: disposeBag)
        
        output.cancelTap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.showCustomAlert(title: "스터디를 취소하겠습니까?", message: "스터디를 취소하시면 패널티가 부과됩니다.", delegate: self)
            }
            .disposed(by: disposeBag)
        
        output.reviewTap
            .withUnretained(self)
            .bind { (vc, _) in
                print("review tap")
            }
            .disposed(by: disposeBag)
    }
    
    
    @objc private func moreButtonTapped() {
        isMoreViewExpanded.toggle()
    }
    
    
    @objc private func popToRootView() {
        navigationController?.popToRootViewController(animated: true)
    }
}




// MARK: - API Request
extension ChattingViewController {
    
    private func requestQueueStatus() {
        APIService.share.request(type: QueueStatus.self, router: .queueStatus) { [weak self] result, _, statusCode in
            switch statusCode {
            case 200:
                
                guard DataStorage.shared.matchedUser.id == "" else { return }
                if let id = result?.matchedUid,
                   let nick = result?.matchedNick {
                    DataStorage.shared.registerMatchedUser(id: id, nick: nick)
                    self?.updateUI()
                }
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestQueueStatus()
                    case .failure(let error):
                        self?.showErrorAlert(error: error)
                    }
                }
            case 406:
                self?.showAlert(title: "가입되지 않은 회원입니다. 초기화면으로 이동합니다.") { _ in
                    self?.changeRootViewController(to: OnboardingViewController())
                }
            case 500:
                print("Server Error")
            case 501:
                print("Client Error")
            default:
                print("Default")
            }
        }
    }
    
    
    private func cancelStudy(uid: String) {
        APIService.share.request(router: .dodgeStudy(uid: uid)) { [weak self] _, statusCode in
            switch statusCode {
            case 200:
                DataStorage.shared.cancelMatch()
                self?.popToRootView()
            case 201:
                print("잘못된 uid")
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.cancelStudy(uid: uid)
                    case .failure(let error):
                        self?.showErrorAlert(error: error)
                    }
                }
            case 500:
                print("Server Error")
            case 501:
                print("Client Error")
            default:
                print("Default")
            }
        }
    }
}




// MARK: - Keyboard 대응
extension ChattingViewController {
    
    private func keyboardBind() {
        RxKeyboard.instance.visibleHeight
            .drive { [weak self] height in
                guard let self else { return }
                self.customView.updateChatInputViewLayout(height: height)
                self.customView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }
}




// MARK: - TableView Protocol
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChattingTableViewHeader.identifier) as? ChattingTableViewHeader else {
            return UIView()
        }
        
        return header
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.identifier, for: indexPath) as? ChattingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateCell(chat: "안녕하세요 굿밤되세요", type: indexPath.row == 0 ? .received : .send)
        
        return cell
    }
}




// MARK: - CustomAlert Delegate
extension ChattingViewController: CustomAlertDelegate {
    func okAction() {
        dismiss(animated: true)
        cancelStudy(uid: DataStorage.shared.matchedUser.id)
    }
    
    func cancel() {
        dismiss(animated: true)
    }
}
