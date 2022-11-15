//
//  ProfileExpandableTableViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit

import RxSwift
import RxCocoa


final class ProfileExpandableTableViewCell: BaseTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    

    // MARK: - Propertys
    var disposeBag = DisposeBag()
    
    private let stackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 0
        $0.axis = .vertical
    }
    
    let nicknameView = ProfileNicknameView()
    
    let titleStackView = SeSacTitleStackView()
    
    let reviewView = SeSacReviewView()
    
    //let expandableButton = UIButton()




    // MARK: - Methods
    override func configureUI() {
        setBorder()
        
        [nicknameView, titleStackView, reviewView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
    }


    override func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(16)
        }
    }


    private func setBorder() {
        stackView.layer.borderColor = R.color.gray2()?.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 10
    }
    
    
    func updateCell(isExpand: Bool) {
        titleStackView.isHidden = isExpand
        reviewView.isHidden = isExpand
        nicknameView.updateCell(isExpand: isExpand)
    }
}
