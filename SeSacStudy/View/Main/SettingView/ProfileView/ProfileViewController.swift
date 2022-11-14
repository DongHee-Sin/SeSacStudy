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
    
    private var isExpandable: Bool = false {
        didSet { customView.tableView.reloadSections([1], with: .fade)}
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
        
        customView.testButton.rx.tap.withUnretained(self)
            .bind { (vc, _) in
                vc.isExpandable.toggle()
            }
            .disposed(by: disposeBag)
    }
    
    
    private func setTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        
        customView.tableView.register(ProfileImageTableViewCell.self, forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
        customView.tableView.register(ProfileExpandableTableViewCell.self, forCellReuseIdentifier: ProfileExpandableTableViewCell.identifier)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageTableViewCell.identifier, for: indexPath) as? ProfileImageTableViewCell else {
                return UITableViewCell()
            }
            
            cell.customImageView.setImageView(img: R.image.sesac_background_1())
            
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileExpandableTableViewCell.identifier, for: indexPath) as? ProfileExpandableTableViewCell else {
                return UITableViewCell()
            }
            
            cell.updateCell(isExpandable: isExpandable)
            
//            cell.expandableButton.rx.tap
//                .withUnretained(self)
//                .bind { (vc, _) in
//                    vc.isExpandable.toggle()
//                }
//                .disposed(by: cell.disposeBag)
            
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}
