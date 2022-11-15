//
//  WishStudyListView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit


final class WishStudyListView: BaseView {
    
    // MARK: - Propertys
    private let label = UILabel().then {
        $0.textColor = R.color.black()
        $0.font = .customFont(.title6_R12)
        $0.text = "하고 싶은 스터디"
    }
    
    let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: .studyListLayout)
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [label, collectionView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.bottom.leading.trailing.equalTo(self).inset(16)
        }
    }
}
