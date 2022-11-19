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
        setCollectionView()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    private func setInitialUI() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        navigationItem.titleView = searchBar
    }
    
    
    private func setCollectionView() {        
        customView.collectionView.delegate = self
        customView.collectionView.dataSource = self
        customView.collectionView.register(StudyListCollectionViewCell.self, forCellWithReuseIdentifier: StudyListCollectionViewCell.identifier)
        customView.collectionView.register(StudyListCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StudyListCollectionViewHeader.identifier)
        
        if let flowLayout = customView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
    }
    
    
//    func keyboardWillShow(_ notification:NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            print("keyboardHeight = \(keyboardHeight)")
//        }
//        // 원하는 로직...
//    }
//
//
//    func keyboardWillHide(_ notification:NSNotification) {
//        // 원하는 로직...
//    }
}




// MARK: - CollectionView Protocol
extension EnterStudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StudyListCollectionViewHeader.identifier, for: indexPath)
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
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
