//
//  ProfileViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


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
        setNavigation()
    }
    
    
    private func setTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
