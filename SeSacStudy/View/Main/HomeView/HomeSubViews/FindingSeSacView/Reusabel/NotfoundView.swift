//
//  NotfoundView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/26.
//

import UIKit


enum NotfoundViewType {
    case surroundingSeSac
    case requestReceived
}


final class NotfoundView: BaseView {
    
    // MARK: - Propertys
    private let image = UIImageView().then {
        $0.image = R.image.sprout1()
    }
    
    private let mainLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = R.color.black()
        $0.font = .customFont(.display_R20)
    }
    
    private let subLabel = UILabel().then {
        $0.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        $0.textAlignment = .center
        $0.textColor = R.color.gray7()
        $0.font = .customFont(.title4_R14)
    }
    
    let changeStudyButton = BasicButton(status: .fill).then {
        $0.titleLabel?.font = .customFont(.body3_R14)
        $0.setTitle("스터디 변경하기", for: .normal)
    }
    
    let reloadButton = UIButton().then {
        $0.setImage(R.image.bt_refresh(), for: .normal)
    }
    
    
    
    
    // MARK: - Init
    convenience init(type: NotfoundViewType) {
        self.init(frame: CGRect())
        mainLabel.text = type == .surroundingSeSac ? "아쉽게도 주변에 새싹이 없어요ㅠ" : "아직 받은 요청이 없어요ㅠ"
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [image, mainLabel, subLabel, changeStudyButton, reloadButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        mainLabel.snp.makeConstraints { make in
            make.center.equalTo(self.safeAreaLayoutGuide)
        }
        
        image.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.centerX.equalTo(self)
            make.bottom.equalTo(mainLabel.snp.top).offset(-32)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
        }
        
        changeStudyButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(reloadButton.snp.leading).offset(-8)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(48)
        }
    }
    
}
