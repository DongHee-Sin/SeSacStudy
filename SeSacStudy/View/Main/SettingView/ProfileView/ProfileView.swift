//
//  ProfileView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


final class ProfileView: BaseView {
    
    // MARK: - Propertys
    let tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)//.inset(16)
        }
    }
}
