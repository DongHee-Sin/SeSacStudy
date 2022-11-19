//
//  EnterStudyView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/17.
//

import UIKit


final class EnterStudyView: BaseView {
    
    // MARK: - Propertys
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let surroundingList = StudyListView(title: "지금 주변에는").then {
        $0.collectionView.tag = 0
    }
    
    let myWishList = StudyListView(title: "내가 하고 싶은").then {
        $0.collectionView.tag = 1
    }
    
    
    let button = BasicButton(status: .fill).then {
        $0.setTitle("새싹 찾기", for: .normal)
        $0.titleLabel?.font = .customFont(.body3_R14)
    }
    
    let keyboardButton = UIButton().then {
        $0.isHidden = true
        $0.setTitle("새싹 찾기", for: .normal)
        $0.titleLabel?.textColor = R.color.white()
        $0.backgroundColor = R.color.green()
    }
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [surroundingList, myWishList].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [scrollView, stackView, button, keyboardButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.snp.width)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.bottom.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        keyboardButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    
    func keyboardButtonToggle(_ value: Bool, keyboardHeight: CGFloat) {
        keyboardButton.isHidden = !value
        keyboardButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-keyboardHeight)
        }
    }
}
