//
//  RequestReceivedViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/22.
//

import UIKit


final class RequestReceivedViewController: RxBaseViewController {
    
    // MARK: - Propertys
    var delegate: SeSacTabmanViewController? = nil
    
    private let placeHolderView = NotfoundView(type: .surroundingSeSac)
    
    private let userList = DataStorage.shared.fromQueueDBRequested
    
    private lazy var expandList: [Bool] = Array(repeating: false, count: userList.count)
    
    private lazy var tempUid: String? = nil
    
    
    
    
    // MARK: - Life Cycle
    private let customView = ProfileView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("탭 전환 - 받은 요청")
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setTableView()
        setPlaceHolderView()
        
        showPlaceHolderView(true)
    }
    
    
    private func setTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        
        customView.tableView.register(ProfileImageTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ProfileImageTableViewHeader.identifier)
        customView.tableView.register(ProfileExpandableTableViewCell.self, forCellReuseIdentifier: ProfileExpandableTableViewCell.identifier)
    }
    
    
    private func setPlaceHolderView() {
        view.addSubview(placeHolderView)
        
        placeHolderView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        placeHolderView.changeStudyButton.rx.tap.withUnretained(self)
            .bind { (vc, _) in
                vc.changeStudyButtonTapped()
            }
            .disposed(by: disposeBag)
        
        placeHolderView.reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func expandButtonTapped(_ button: UIButton) {
        expandList[button.tag].toggle()
        customView.tableView.reloadSections([button.tag], with: .fade)
    }
    
    
    @objc private func studyAcceptButtonTapped(_ button: UIButton) {
        tempUid = userList[button.tag].uid
        showCustomAlert(title: "스터디를 수락할까요?", message: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요", delegate: self)
    }
}




// MARK: - API Request
extension RequestReceivedViewController {
    
    /// https://sesac-ios-2.atlassian.net/wiki/spaces/SIS/pages/10289265/1+3+near+user+popup+1+4+accept+popup
    /// 상태코드별 분기처리 필요
    private func acceptStudy(uid: String) {
        APIService.share.request(router: .acceptStudy(uid: uid)) { [weak self] error, statusCode in
            switch statusCode {
            case 200:
                self?.showToast(message: "스터디 수락 성공! 잠시 후 채팅방으로 이동합니다", completion: {
                    UserDefaultManager.shared.matchedUserId = uid
                    self?.transition(ChattingViewController(), transitionStyle: .push)
                })
            case 201:
                self?.showToast(message: "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
            case 202:
                self?.showToast(message: "상대방이 스터디 찾기를 그만두었습니다")
            case 203:
                self?.showToast(message: "앗! 누군가가 나의 스터디를 수락하였어요!", completion: {
                    self?.requestQueueStatus()
                })
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.acceptStudy(uid: uid)
                    case .failure(let error):
                        self?.showErrorAlert(error: error)
                    }
                }
            case 406:
                self?.showAlert(title: "가입되지 않은 회원입니다. 초기화면으로 이동합니다.") { _ in
                    self?.changeRootViewController(to: OnboardingViewController())
                }
            case 500, 501:
                self?.showErrorAlert(error: error!)
            default:
                self?.showErrorAlert(error: error!)
            }
        }
    }
    
    
    private func requestQueueStatus() {
        APIService.share.request(type: QueueStatus.self, router: .queueStatus) { [weak self] result, _, statusCode in
            switch statusCode {
            case 200:
                if let result,
                   MatchStatus.status(result.matched) == .matched,
                   let id = result.matchedUid,
                   let nick = result.matchedNick {
                    DataStorage.shared.registerMatchedUser(id: id, nick: nick)
                    self?.transition(ChattingViewController(), transitionStyle: .push)
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
    
    
    private func requestQueueSearch() {
        APIService.share.request(type: QueueSearchResult.self, router: .queueSearch) { [weak self] result, _, statusCode in
            switch statusCode {
            case 200:
                if let result {
                    DataStorage.shared.updateSearchResult(info: result)
                    self?.customView.tableView.reloadData()
                }
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestQueueSearch()
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
}




// MARK: - TableView Protocol
extension RequestReceivedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageTableViewHeader.identifier) as? ProfileImageTableViewHeader else {
            return UIView()
        }
        
        header.customImageView.setImageView(img: .backgroundImage(userList[section].background), buttonType: .accept)
        
        header.customImageView.button.tag = section
        header.customImageView.button.addTarget(self, action: #selector(studyAcceptButtonTapped), for: .touchUpInside)
        
        return header
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = userList.count
        showPlaceHolderView(count == 0)
        
        return count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileExpandableTableViewCell.identifier, for: indexPath) as? ProfileExpandableTableViewCell else {
            return UITableViewCell()
        }
        
        let data = userList[indexPath.section]
        let expand = expandList[indexPath.section]
        cell.updateCell(user: data, isExpand: expand)
        
        cell.expandButton.tag = indexPath.section
        cell.expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        
        cell.userStudyList = DataStorage.shared.fromQueueDB[indexPath.section].studylist
        
        return cell
    }
}




// MARK: - TabmanSubViewController
extension RequestReceivedViewController: TabmanSubViewController {
    
    func changeStudyButtonTapped() {
        delegate?.changeStudyButtonTapped()
    }
    
    
    @objc func reloadButtonTapped() {
        requestQueueSearch()
    }
    
    
    func showPlaceHolderView(_ value: Bool) {
        placeHolderView.isHidden = !value
    }
}




// MARK: - CustomAlert Delegate
extension RequestReceivedViewController: CustomAlertDelegate {
    
    func okAction() {
        customAlertAction { [weak self] in
            if let tempUid = self?.tempUid {
                self?.acceptStudy(uid: tempUid)
            }
        }
    }
    
    
    func cancel() {
        customAlertAction()
    }
    
    
    private func customAlertAction(_ action: (() -> Void)? = nil) {
        dismiss(animated: true)
        action?()
        tempUid = nil
    }
}
