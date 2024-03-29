//
//  SeSacTitleStackView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


final class SeSacTitleStackView: BaseView {
    
    // MARK: - Propertys
    private let label = UILabel().then {
        $0.text = "새싹 타이틀"
        $0.font = .customFont(.title6_R12)
        $0.textColor = R.color.black()
    }
    
    let mannerButton = BasicButton(status: .inactive).then { $0.setTitle("좋은 매너", for: .normal) }
    let timeCommitmentButton = BasicButton(status: .inactive).then { $0.setTitle("정확한 시간 약속", for: .normal) }
    let quickResponseButton = BasicButton(status: .inactive).then { $0.setTitle("빠른 응답", for: .normal) }
    let kindnessButton = BasicButton(status: .inactive).then { $0.setTitle("친절한 성격", for: .normal) }
    let proficiencyButton = BasicButton(status: .inactive).then { $0.setTitle("능숙한 실력", for: .normal) }
    let goodTimeButton = BasicButton(status: .inactive).then { $0.setTitle("유익한 시간", for: .normal) }
    
    var buttons: [BasicButton] {
        return [mannerButton, timeCommitmentButton, quickResponseButton, kindnessButton, proficiencyButton, goodTimeButton]
    }
    
    private let verticalStackView1 = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 8
        $0.axis = .vertical
    }
    
    private let verticalStackView2 = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 8
        $0.axis = .vertical
    }
    
    private let horizontalStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [mannerButton, quickResponseButton, proficiencyButton].forEach {
            verticalStackView1.addArrangedSubview($0)
        }
        
        [timeCommitmentButton, kindnessButton, goodTimeButton].forEach {
            verticalStackView2.addArrangedSubview($0)
        }
        
        [verticalStackView1, verticalStackView2].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
        
        [label, horizontalStackView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        [mannerButton, timeCommitmentButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(32)
            }
        }
        
        label.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self).inset(16)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self).inset(16)
            make.bottom.equalTo(self).offset(-16)
        }
    }
    
    
    func setButtonStyle(reputation: [Int]) {
        zip(buttons, reputation).forEach { (button, reputation) in
            button.isEnabled = true
            button.titleLabel?.font = .customFont(.title4_R14)
            
            button.setButtonStyle(status: reputation > 0 ? .fill : .inactive)
        }
    }
}
