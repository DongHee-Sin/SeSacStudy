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
    
    let wishStudyListView = StudyListView(title: "하고 싶은 스터디")
    
    let reviewView = SeSacReviewView()
    
    let expandButton = UIButton()
    
    lazy var userStudyList: [String] = []




    // MARK: - Methods
    override func configureUI() {
        setBorder()
        setCollectionView()
        
        contentView.isUserInteractionEnabled = true
        
        [nicknameView, titleStackView, wishStudyListView, reviewView].forEach {
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
    
    
    private func setCollectionView() {
        wishStudyListView.collectionView.delegate = self
        wishStudyListView.collectionView.dataSource = self
        wishStudyListView.collectionView.register(StudyListCollectionViewCell.self, forCellWithReuseIdentifier: StudyListCollectionViewCell.identifier)
    }
    
    
    private func expandViews(_ isExpand: Bool) {
        titleStackView.isHidden = !isExpand
        reviewView.isHidden = !isExpand
        nicknameView.updateCell(isExpand: !isExpand)
    }
    
    
    func updateCell(login: Login, isExpand: Bool) {
        
        wishStudyListView.isHidden = true
        
        nicknameView.label.text = login.nick
        
        titleStackView.setButtonStyle(reputation: login.reputation)
        
        reviewView.reviewLabel.text = login.comment.last ?? ""
        
        expandViews(isExpand)
    }
    
    
    func updateCell(user: User, isExpand: Bool) {
        
        nicknameView.label.text = user.nick
        
        titleStackView.setButtonStyle(reputation: user.reputation)
        
        reviewView.reviewLabel.text = user.reviews.last ?? ""
        
        expandViews(isExpand)
        wishStudyListView.isHidden = !isExpand
        
        
        
        if isExpand { wishStudyListView.collectionView.reloadData() }
    }
}




// MARK: - CollectionView Protocol
extension ProfileExpandableTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userStudyList.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudyListCollectionViewCell.identifier, for: indexPath) as? StudyListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateCell(title: userStudyList[indexPath.item], style: .normal)

        return cell
    }
}
