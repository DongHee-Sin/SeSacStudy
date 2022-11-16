//
//  ProfileViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit

import RxSwift
import RxCocoa
import MultiSlider


final class ProfileViewController: BaseViewController {
    
    // MARK: - Propertys
    private let viewModel = ProfileViewModel()
    
    private var login = UserInfoManager.shared.login! {
        didSet {
            print("\(login.gender), \(login.study), \(login.searchable), \(login.ageMin), \(login.ageMax)")
        }
    }
    
    private lazy var myPage = MyPage(login: login)
    
    private var isExpand: Bool = false {
        didSet { customView.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade) }
    }
    
    
    
    
    // MARK: - Life Cycle
    private let customView = ProfileView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        tabBarController?.tabBar.isHidden = true
        
        setTableView()
        setNavigation()
    }
    
    
    private func setTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        
        customView.tableView.register(ProfileImageTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ProfileImageTableViewHeader.identifier)
        customView.tableView.register(ProfileExpandableTableViewCell.self, forCellReuseIdentifier: ProfileExpandableTableViewCell.identifier)
        customView.tableView.register(SettingUserInfoTableViewCell.self, forCellReuseIdentifier: SettingUserInfoTableViewCell.identifier)
    }
    
    
    private func setNavigation() {
        let saveItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        navigationItem.title = "정보 관리"
        navigationItem.rightBarButtonItem = saveItem
    }
    
    
    @objc private func saveButtonTapped() {
        requestMypageUpdate(info: myPage)
    }
    
    
    private func requestMypageUpdate(info: MyPage) {
        
        APIService.share.request(router: .mypage(body: info)) { [weak self] _, statusCode in
            guard let self else { return }
            
            switch statusCode {
            case 200:
                self.showToast(message: "수정되었습니다")
                self.navigationController?.popViewController(animated: true)
            case 401:
                FirebaseAuthManager.share.fetchFCMToken { result in
                    switch result {
                    case .success(_):
                        self.requestMypageUpdate(info: self.myPage)
                    case .failure(let error):
                        self.showErrorAlert(error: error)
                    }
                }
            case 406:
                self.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
            case 500:
                self.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
            case 501:
                self.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
            default:
                self.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
            }
            
        }
        
    }
    
    
    private func requestWithdraw() {
        
        APIService.share.request(router: .withdraw) { [weak self] _, statusCode in
            
            switch statusCode {
            case 200:
                self?.changeRootViewController(to: OnboardingViewController())
            case 401:
                FirebaseAuthManager.share.fetchFCMToken { result in
                    switch result {
                    case .success(_):
                        self?.requestWithdraw()
                    case .failure(let error):
                        self?.showErrorAlert(error: error)
                    }
                }
            case 406:
                self?.showAlert(title: "이미 탈퇴 처리되었거나 가입되지 않은 회원입니다.", message: "초기화면으로 돌아갑니다.") { _ in
                    self?.changeRootViewController(to: OnboardingViewController())
                }
            case 500:
                self?.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
            case 501:
                self?.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
            default:
                self?.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
            }
        }
        
    }
}




// MARK: - TableView Protocol
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageTableViewHeader.identifier) as? ProfileImageTableViewHeader else {
                return UIView()
            }
            
            header.customImageView.setImageView(img: UserInfoManager.shared.sesacImage)
            
            return header
            
        }else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }else {
            return .zero
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileExpandableTableViewCell.identifier, for: indexPath) as? ProfileExpandableTableViewCell else {
                return UITableViewCell()
            }
            
            cell.updateCell(login: login, isExpand: isExpand)
            
            cell.expandButton.rx.tap
                .withUnretained(self)
                .bind { (vc, _) in
                    vc.isExpand.toggle()
                }
                .disposed(by: cell.disposeBag)
            
            
            return cell
            
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingUserInfoTableViewCell.identifier, for: indexPath) as? SettingUserInfoTableViewCell else {
                return UITableViewCell()
            }
            
            cell.updateCell(login: login)
            
            
            cell.genderView.gender
                .withUnretained(self)
                .bind { (vc, gender) in
                    vc.login.gender = gender
                    //vc.customView.tableView.reloadSections([1], with: .none)
                }
                .disposed(by: cell.disposeBag)
            
            
            cell.frequentStudyView.textField.textField.rx.text
                .withUnretained(self)
                .bind { (vc, text) in
                    vc.login.study = text.value ?? ""
                }
                .disposed(by: cell.disposeBag)
            
            
            cell.numberSearchAvailabilityView.availabilitySwitch.rx.isOn
                .withUnretained(self)
                .bind { (vc, value) in
                    vc.login.searchable = value ? 1 : 0
                }
                .disposed(by: cell.disposeBag)
            
            
            cell.ageGroubView.ageRange
                .withUnretained(self)
                .bind { (vc, value) in
                    vc.login.ageMin = Int(value.first ?? 0)
                    vc.login.ageMax = Int(value.last ?? 0)
                }
                .disposed(by: cell.disposeBag)
            
            
            cell.withdrawalView.button.rx.tap
                .withUnretained(self)
                .bind { (vc, _) in
                    vc.requestWithdraw()
                }
                .disposed(by: cell.disposeBag)
            
            
            return cell
        }
    }
}
