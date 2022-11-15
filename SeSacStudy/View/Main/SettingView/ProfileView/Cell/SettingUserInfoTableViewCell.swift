//
//  SettingUserInfoTableViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit

import RxSwift
import RxCocoa


final class SettingUserInfoTableViewCell: BaseTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    

    // MARK: - Propertys
    var disposeBag = DisposeBag()
    
    private let stackView = UIStackView().then {
        $0.backgroundColor = .red
        $0.distribution = .fill
        $0.spacing = 8
        $0.axis = .vertical
    }
    
    let genderView = MyGenderView()
    let frequentStudyView = FrequentStudyView()
    let numberSearchAvailabilityView = NumberSearchAvailabilityView()
    



    // MARK: - Methods
    override func configureUI() {
        contentView.isUserInteractionEnabled = true
        
        [genderView, frequentStudyView, numberSearchAvailabilityView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView].forEach {
            self.addSubview($0)
        }
    }


    override func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(16)
        }
        
    }
    
    
    func updateCell() {
        
    }
}
