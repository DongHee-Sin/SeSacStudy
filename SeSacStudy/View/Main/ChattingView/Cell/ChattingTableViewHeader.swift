//
//  ChattingTableViewHeader.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import UIKit


final class ChattingTableViewHeader: UITableViewHeaderFooterView {

    // MARK: - Propertys
    static var identifier: String {
        return String(describing: self)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "  TEST : 1월 15일 토요일  "
        $0.backgroundColor = R.color.gray7()
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
        $0.textColor = R.color.white()
        $0.font = .customFont(.title5_M12)
    }
    
    private let imageLabel = ImageLabelView().then {
        $0.image.image = R.image.setting_alarm()
    }
    
    private let subLabel = UILabel().then {
        $0.text = "채팅을 통해 약속을 정해보세요 :)"
        $0.textColor = R.color.gray6()
        $0.font = .customFont(.title4_R14)
    }
    
    
    
    
    
    
    // MARK: - LifeCycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    // MARK: - Methods
    private func configureUI() {
        [dateLabel, imageLabel, subLabel].forEach {
            self.addSubview($0)
        }
    }
    
    
    private func setConstraint() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.centerX.equalTo(self)
            make.height.equalTo(28)
        }
      
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.centerX.equalTo(self)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(2)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-16)
        }
    }
    
    
    func updateHeader(nick: String) {
        imageLabel.label.text = "\(nick)님과 매칭되었습니다."
    }
}
