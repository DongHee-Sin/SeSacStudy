//
//  EnterStudyViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/17.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard


final class EnterStudyViewController: BaseViewController {
    
    // MARK: - Propertys
    
    
    
    
    // MARK: - Life Cycle
    private let customView = EnterStudyView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setInitialUI()
        setCollectionView()
        
        keyboardBind()
    }
    
    
    private func setInitialUI() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        navigationItem.titleView = searchBar
    }
    
    
    private func setCollectionView() {
        [customView.surroundingList.collectionView, customView.myWishList.collectionView].forEach {
            $0.delegate = self
            $0.dataSource = self
            $0.register(StudyListCollectionViewCell.self, forCellWithReuseIdentifier: StudyListCollectionViewCell.identifier)
            
            if let flowLayout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        }
    }
}




// MARK: - Keyboard 대응
extension EnterStudyViewController {
    
    private func keyboardBind() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                guard let self else { return }
                self.customView.updateButtonLayout(height: height)
                self.customView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}




// MARK: - CollectionView Protocol
extension EnterStudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudyListCollectionViewCell.identifier, for: indexPath) as? StudyListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateCell(title: "아무거나", style: .normal)
        
        return cell
    }
}
