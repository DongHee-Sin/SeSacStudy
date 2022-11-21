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
    
    var textColor: UIColor? {
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
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        $0.isEnabled = false
        $0.titleLabel?.font = .customFont(.title4_R14)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.semanticContentAttribute = .forceRightToLeft
//        $0.contentVerticalAlignment = .center
//        $0.contentHorizontalAlignment = .center
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
    
    
    private func setButtonStyle(style: StudyListCellStyle) {
        button.setTitleColor(style.textColor, for: .normal)
        button.layer.borderColor = style.borderColor
    }
    
    
    func updateCell(title: String, style: StudyListCellStyle, image: UIImage? = nil) {
        button.setTitle(title, for: .normal)
        setButtonStyle(style: style)
        
        if let image {
            button.setImage(image, for: .normal)
            button.tintColor = R.color.green()
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        }
    }
}
