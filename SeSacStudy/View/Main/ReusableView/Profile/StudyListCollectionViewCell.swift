//
//  StudyListCollectionViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/18.
//

import UIKit


enum StudyListCellStyle {
    case recommend
    case normal
    case userAdded
}


final class StudyListCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Propertys
    private let button = UIButton().then {
        $0.isEnabled = false
        //$0.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        
        $0.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        $0.tintColor = .secondaryLabel
        $0.setTitle("5", for: .normal)
        $0.setTitleColor(.secondaryLabel, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
    }
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        //
    }
    
    
    override func setConstraint() {
        //
    }
    
    
    private func updateCell(title: String, style: StudyListCellStyle, image: UIImage? = nil) {
        
        if let image {
            button.setImage(image, for: .normal)
        }
    }
}
