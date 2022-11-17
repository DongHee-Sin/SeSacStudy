//
//  EnterStudyView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/17.
//

import UIKit


final class EnterStudyView: BaseView {
    
    // MARK: - Propertys
    let surroundingList = StudyListView(title: "지금 주변에는").then {
        $0.collectionView.tag = 0
    }
    
    let myWishList = StudyListView(title: "내가 하고 싶은").then {
        $0.collectionView.tag = 1
    }
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [surroundingList, myWishList].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        surroundingList.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        myWishList.snp.makeConstraints { make in
            make.top.equalTo(surroundingList.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
