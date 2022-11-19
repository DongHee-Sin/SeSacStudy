//
//  StudyListCollectionViewHeader.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/19.
//

import UIKit


final class StudyListCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - Propertys
    static var identifier: String {
        return String(describing: self)
    }
    
    private let label = UILabel().then {
        $0.backgroundColor = .red
        $0.textColor = R.color.black()
    }
    
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    // MARK: - Methods
    private func configureUI() {
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    
    func setTitle(_ title: String) {
        label.text = title
    }
}
