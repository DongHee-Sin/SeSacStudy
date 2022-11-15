//
//  ProfileImageTableViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit


final class ProfileImageTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - Propertys
    static var identifier: String {
        return String(describing: self)
    }
    
    let customImageView = ProfileBackgroundImageView()
    
    
    
    
    // MARK: - LifeCycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    // MARK: - Methods
    private func configureUI() {
        self.addSubview(customImageView)
    }
    
    
    private func setConstraint() {
        customImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(customImageView.snp.width).multipliedBy(0.57)
        }
    }
}
