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
    
    var tintColor: UIColor? {
        switch self {
        case .recommend: return R.color.error()
        case .normal: return R.color.black()
        case .userAdded: return R.color.green()
        }
    }
    
    var borderColor: CGColor? {
        switch self {
        case .recommend: return R.color.error()?.cgColor
        case .normal: return R.color.gray4()?.cgColor
        case .userAdded: return R.color.green()?.cgColor
        }
    }
}


final class StudyListCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Propertys
    private let button = UIButton().then {
        $0.setTitle(" ", for: .normal)
        $0.isEnabled = false
        $0.semanticContentAttribute = .forceRightToLeft
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
    }
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(button)
    }
    
    
    override func setConstraint() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func updateCell(title: String, style: StudyListCellStyle, image: UIImage? = nil) {
        button.setTitle(title, for: .normal)
        setButtonStyle(style: style)
        
        if let image {
            button.setImage(image, for: .normal)
        }
    }
    
    
    private func setButtonStyle(style: StudyListCellStyle) {
        button.tintColor = style.tintColor
        button.layer.borderColor = style.borderColor
    }
}
