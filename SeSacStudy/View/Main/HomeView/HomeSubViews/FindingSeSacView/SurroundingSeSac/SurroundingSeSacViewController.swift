//
//  SurroundingSeSacViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/22.
//

import UIKit


final class SurroundingSeSacViewController: BaseViewController {
    
    // MARK: - Propertys
    var delegate: SeSacTabmanViewController? = nil
    
    private let placeHolderView = NotfoundView(type: .surroundingSeSac)
    
    private let userList = DataStorage.shared.SearchResult.fromQueueDB
    
    private lazy var expandList: [Bool] = Array(repeating: false, count: userList.count)
    
    
    
    
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
        
        print("탭 전환 - 주변새싹")
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
    
    
    private func requestSearch() {
        delegate?.requestSearch(completion: {
            /// 1. userList 업데이트
            /// 2. expandList 업데이트
            /// 3. tableView Reload
            ///
            /// viewWillAppear
            /// 당겨서 새로고침
            /// 펼친 카드를 닫을 때
        })
    }
    
    
    @objc private func expandButtonTapped(_ button: UIButton) {
        expandList[button.tag].toggle()
        customView.tableView.reloadSections([button.tag], with: .fade)
    }
    
    
    @objc private func requestStudyButtonTapped(_ button: UIButton) {
        let uid = userList[button.tag].uid
        APIService.share.request(router: .requestStudy(uid: uid)) { [weak self] error, statusCode in
            switch statusCode {
            case 200:
                self?.showToast(message: "스터디 요청을 보냈습니다")
            case 201:
                print("상대방이 이미 나에게 스터디 요청한 상태 ---")
            case 202:
                self?.showToast(message: "상대방이 스터디 찾기를 그만두었습니다")
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestStudyButtonTapped(button)
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
}




// MARK: - TableView Protocol
extension SurroundingSeSacViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageTableViewHeader.identifier) as? ProfileImageTableViewHeader else {
            return UIView()
        }
        
        header.customImageView.setImageView(img: R.image.sesac_background_1(), buttonType: .request)
        
        header.customImageView.button.tag = section
        header.customImageView.button.addTarget(self, action: #selector(requestStudyButtonTapped), for: .touchUpInside)
        
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
        
        cell.userStudyList = DataStorage.shared.SearchResult.fromQueueDB[indexPath.section].studylist
        
        return cell
    }
}




// MARK: - TabmanSubViewController
extension SurroundingSeSacViewController: TabmanSubViewController {
    
    func changeStudyButtonTapped() {
        delegate?.changeStudyButtonTapped()
    }
    
    
    @objc func reloadButtonTapped() {
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
                        self?.reloadButtonTapped()
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
    
    
    func showPlaceHolderView(_ value: Bool) {
        placeHolderView.isHidden = !value
    }
}
 
