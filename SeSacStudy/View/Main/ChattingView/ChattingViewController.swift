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
    
    private lazy var socketManager = SocketIOManager(delegate: self)
    
    private var isMoreViewExpanded = false {
        didSet {
            // ⭐️ 사용자 Queue상태 확인 후, 스터디 취소 Title 변경 필요..
            customView.showUpMoreExpandedView(isMoreViewExpanded)
        }
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        socketManager.closeConnection()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        requestQueueStatus()
        
        setNavigationBar()
        setTableView()
        
        bind()
        keyboardBind()
        
        addObserver()
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
        fetchChatList(uid: DataStorage.shared.matchedUser.id, lastDate: viewModel.lastChatDate)
        
        navigationItem.title = DataStorage.shared.matchedUser.nick
    }
    
    
    private func bind() {
        let chatInputView = customView.chatInputView
        let rxTextView = chatInputView.textView.rx
        let expandView = customView.moreExpandedView
        let input = ChattingViewModel.Input(text: rxTextView.text, beginEditing: rxTextView.didBeginEditing, endEditing: rxTextView.didEndEditing, sendButtonTap: chatInputView.sendButton.rx.tap, reportTap: expandView.reportButton.rx.tap, cancelTap: expandView.cancelButton.rx.tap, reviewTap: expandView.reviewButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.text
            .bind(to: viewModel.userInputMessage)
            .disposed(by: disposeBag)
        
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
        
        output.sendButtonTap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.sendChat(message: vc.viewModel.userInputMessage.value)
            }
            .disposed(by: disposeBag)
        
        viewModel.matchStatus
            .withUnretained(self)
            .bind { (vc, value) in
                vc.customView.moreExpandedView.cancelButton.setTitle(value == .matched ? "스터디 취소" : "스터디 종료", for: .normal)
            }
            .disposed(by: disposeBag)
        
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
                if vc.viewModel.matchStatus.value == .matched {
                    vc.showCustomAlert(title: "스터디를 취소하겠습니까?", message: "스터디를 취소하시면 패널티가 부과됩니다.", delegate: self)
                }else {
                    vc.popToRootView()
                }
            }
            .disposed(by: disposeBag)
        
        output.reviewTap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.transition(RegisterReviewViewController(), transitionStyle: .presentOver)
            }
            .disposed(by: disposeBag)
    }
    
    
    /// ⭐️ tableView reload 시점 : 1. 내가 보냈을 때, 2. 소켓으로부터 채팅 받았을 때
    /// Realm은 Thread safe하지 않음... 뭔가 문제가 발생할 것 같다.
    /// Realm 데이터를 관리하는 코드들이 직렬큐에서 동작하면 될 것 같은데.. 생각좀..
    private func addObserver() {
        viewModel.addObserver { [weak self] in
            self?.customView.tableView.reloadData()
            self?.scrollToBottom()
        }
    }
    
    
    private func addChatToDatabase(_ chatList: [ChatResponse]) {
        do {
            try viewModel.addChatToDatabase(chatList)
        }
        catch {
            showErrorAlert(error: error)
        }
    }
    
    
    private func scrollToBottom() {
        guard viewModel.chatCount >= 1 else { return }
        let lastIndexPath = IndexPath(row: viewModel.chatCount-1, section: 0)
        customView.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
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
                guard let result else { return }
                self?.viewModel.matchStatus.accept(MatchStatus.status(result.matched))
                
                guard DataStorage.shared.matchedUser.id == "" || DataStorage.shared.matchedUser.nick == "" else {
                    self?.updateUI()
                    return
                }
                
                if let id = result.matchedUid,
                   let nick = result.matchedNick {
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
    
    
    private func fetchChatList(uid: String, lastDate: String) {
        APIService.share.request(type: ChatList.self, router: .fetchChat(uid: uid, lastDate: lastDate)) { [weak self] result, _, statusCode in
            switch statusCode {
            case 200:
                if let chatList = result?.payload, !chatList.isEmpty {
                    self?.addChatToDatabase(chatList)
                }
                self?.socketManager.establishConnection()
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.fetchChatList(uid: uid, lastDate: lastDate)
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
    
    
    private func sendChat(message: String) {
        APIService.share.request(type: ChatResponse.self, router: .sendChat(uid: DataStorage.shared.matchedUser.id, chat: message)) { [weak self] result, error, statusCode in
            switch statusCode {
            case 200:
                if let result {
                    self?.customView.chatInputView.textView.text = ""
                    self?.addChatToDatabase([result])
                }
            case 201:
                self?.showToast(message: "스터디가 종료되어 채팅을 전송할 수 없습니다") {
                    self?.popToRootView()
                }
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.sendChat(message: message)
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
                self?.showErrorAlert(error: error)
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
                self.scrollToBottom()
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
        
        header.updateHeader(nick: DataStorage.shared.matchedUser.nick)
        
        return header
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.identifier, for: indexPath) as? ChattingTableViewCell else {
            return UITableViewCell()
        }
        
        let chat = viewModel.fetchChat(at: indexPath.row)
        let dateString = viewModel.toString(from: chat.createdAt)
        let cellType: ChattingCellType = chat.from == UserDefaultManager.shared.matchedUserId ? .received : .send
        
        cell.updateCell(chat: chat.chat, createdAt: dateString, type: cellType)
        
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




// MARK: - SocketDataDelegate
extension ChattingViewController: SocketDataDelegate {
    func received(message: ChatResponse) {
        addChatToDatabase([message])
    }
}
