//
//  BaseCollectionViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


class BaseCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureUI() {}
    
    func setConstraint() {}
}
