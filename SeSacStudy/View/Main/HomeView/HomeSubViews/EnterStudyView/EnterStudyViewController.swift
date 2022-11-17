//
//  EnterStudyViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/17.
//

import UIKit


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
    }
    
    
    private func setInitialUI() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        navigationItem.titleView = searchBar
    }
    
    
    private func setDelegate() {
        customView.surroundingList.collectionView.delegate = self
        customView.surroundingList.collectionView.dataSource = self
        customView.myWishList.collectionView.delegate = self
        customView.myWishList.collectionView.dataSource = self
    }
}




// MARK: - CollectionView Protocol
extension EnterStudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
