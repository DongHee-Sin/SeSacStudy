//
//  ProfileViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit

import RxSwift
import RxCocoa


final class ProfileViewController: BaseViewController {
    
    // MARK: - Propertys
    private let viewModel = ProfileViewModel()
    
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
    }
}




// MARK: - TableView Protocol
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageTableViewHeader.identifier) as? ProfileImageTableViewHeader else {
                return UIView()
            }
            
            header.customImageView.setImageView(img: R.image.sesac_background_1())
            
            return header
            
        }else {
            return nil
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
            
            cell.updateCell(isExpand: isExpand)
            
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
            
            
            
            return cell
        }
    }
}
