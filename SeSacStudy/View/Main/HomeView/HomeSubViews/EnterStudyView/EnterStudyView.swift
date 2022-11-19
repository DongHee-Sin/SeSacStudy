//
//  EnterStudyView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/17.
//

import UIKit


final class EnterStudyView: BaseView {
    
    // MARK: - Propertys
    let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: StudyListLayout())
    
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
        [collectionView, button, keyboardButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(button.snp.top).offset(-16)
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
