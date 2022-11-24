//
//  SurroundingSeSacViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/22.
//

import UIKit


final class SurroundingSeSacViewController: BaseViewController {
    
    // MARK: - Propertys
    
    
    
    
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
    }
    
    
    private func setTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        
        customView.tableView.register(ProfileImageTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ProfileImageTableViewHeader.identifier)
        customView.tableView.register(ProfileExpandableTableViewCell.self, forCellReuseIdentifier: ProfileExpandableTableViewCell.identifier)
    }
}




// MARK: - TableView Protocol
extension SurroundingSeSacViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageTableViewHeader.identifier) as? ProfileImageTableViewHeader else {
            return UIView()
        }
        
        header.customImageView.setImageView(img: R.image.sesac_background_1(), buttonType: .request)
        
        return header
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileExpandableTableViewCell.identifier, for: indexPath) as? ProfileExpandableTableViewCell else {
            return UITableViewCell()
        }
        
        //cell.updateCell(login: <#T##Login#>, isExpand: <#T##Bool#>, collectionViewProtocol: self)
        
        /// expand버튼 어케 처리할지?
        /// 1. button마다 tag부여 (section값으로)
        /// 2. addTarget으로 버튼탭하면 tag값의 section reload
        
        
        return cell

    }
}
