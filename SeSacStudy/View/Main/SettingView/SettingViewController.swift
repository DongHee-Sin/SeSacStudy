//
//  SettingViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


struct SettingViewData {
    let title: String
    let image: UIImage?
}


final class SettingViewController: BaseViewController {
    
    // MARK: - Propertys
    private let settingDatas: [[SettingViewData]] = [
        [SettingViewData(title: DataStorage.shared.login.nick, image: R.image.sesac_face_11())],
        [
            SettingViewData(title: "공지사항", image: R.image.notice()),
            SettingViewData(title: "자주 묻는 질문", image: R.image.faq()),
            SettingViewData(title: "1:1 문의", image: R.image.qna()),
            SettingViewData(title: "알림 설정", image: R.image.setting_alarm()),
            SettingViewData(title: "이용약관", image: R.image.permit()),
        ]
    ]
    
    
    
    
    // MARK: - Life Cycle
    private let customView = SettingView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        
        customView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        customView.tableView.register(ProfileSettingTableViewCell.self, forCellReuseIdentifier: ProfileSettingTableViewCell.identifier)
        
        navigationItem.title = "내정보"
    }
    
    
    private func requestLoginAndTransitionVC() {
        
        APIService.share.request(type: Login.self, router: .login) { [weak self] result, _, statusCode in
            
            switch statusCode {
            case 200:
                if let result {
                    DataStorage.shared.updateInfo(info: result)
                }
                self?.transition(ProfileViewController(), transitionStyle: .push)
                
            case 406:
                self?.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
                
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestLoginAndTransitionVC()
                        return
                    case .failure(let error):
                        self?.showErrorAlert(error: error)
                    }
                }
                
            default:
                self?.showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요")
            }
        }
        
    }
}




// MARK: - TableView Protocol
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 96 : 74
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingDatas.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingDatas[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingTableViewCell.identifier, for: indexPath) as? ProfileSettingTableViewCell else {
                return UITableViewCell()
            }

            cell.updateCell(settingDatas[indexPath.section][indexPath.row])

            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
                return UITableViewCell()
            }

            cell.updateCell(settingDatas[indexPath.section][indexPath.row])

            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("Cell Selected : \(settingDatas[indexPath.section][indexPath.row])")
            
            requestLoginAndTransitionVC()
            
        }else {
            print("Cell Selected : \(settingDatas[indexPath.section][indexPath.row])")
        }
    }
    
}
