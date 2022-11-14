//
//  SeSacTitleStackView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


final class SeSacTitleStackView: BaseView {
    
    // MARK: - Propertys
    let mannerButton = BasicButton(status: .inactive)
    let timeCommitmentButton = BasicButton(status: .inactive)
    let quickResponseButton = BasicButton(status: .inactive)
    let kindnessButton = BasicButton(status: .inactive)
    let proficiencyButton = BasicButton(status: .inactive)
    let goodTimeButton = BasicButton(status: .inactive)
    
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
        
        self.addSubview(horizontalStackView)
    }
    
    
    override func setConstraint() {
        [mannerButton, timeCommitmentButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(32)
            }
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
