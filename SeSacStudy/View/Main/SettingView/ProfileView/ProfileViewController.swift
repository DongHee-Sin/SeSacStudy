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
    
    
    
    
    // MARK: - Methods
    override func configure() {
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
        print("Save Button Tapped")
        
        let mypage = MyPage(login: login)
        
        //APIService.share.request(router: <#T##Router#>, completion: <#T##(Error?, Int?) -> Void#>)
        
        
        ///⭐️⭐️⭐️⭐️⭐️ 수정할 내용 ⭐️⭐️⭐️⭐️⭐️⭐️
        ///1. 굳이 리로드를 하지 않아도 RxSwift - Bind를 활용하면 뷰객체의 상태를 바로 변경해줄 수 있다.
        ///2. 따라서 저장해야 할 상태값은 옵저버블로 선언하여 뷰컨에서 구독하도록 하고 -> 구독하여 값이 변경되면 저장
        ///3. 각 Cell에서는 옵저버블의 값을바탕으로 뷰객체의 상태만 변경해주면 된다.
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
                .disposed(by: disposeBag)
            
            
            return cell
        }
    }
}
