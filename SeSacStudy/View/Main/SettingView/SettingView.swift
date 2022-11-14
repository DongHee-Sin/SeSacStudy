//
//  SettingView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


final class SettingView: BaseView {
    
    // MARK: - Propertys
    let tableView = UITableView().then {
        $0.backgroundColor = R.color.white()
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(tableView)
    }
    
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
