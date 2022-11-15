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
    
    let expandButton = UIButton()




    // MARK: - Methods
    override func configureUI() {
        setBorder()
        
        contentView.isUserInteractionEnabled = true
        
        [nicknameView, titleStackView, reviewView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView, expandButton].forEach {
            self.addSubview($0)
        }
    }


    override func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
        expandButton.snp.makeConstraints { make in
            make.edges.equalTo(nicknameView).inset(16)
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
