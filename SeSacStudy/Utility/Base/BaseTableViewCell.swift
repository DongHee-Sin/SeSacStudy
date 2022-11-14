//
//  BaseTableViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


class BaseTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {}
    
    func setConstraint() {}
}
