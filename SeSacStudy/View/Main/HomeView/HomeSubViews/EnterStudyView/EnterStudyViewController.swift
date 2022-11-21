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
    private let viewModel = EnterStudyViewModel()
    
    
    
    
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
        bind()
    }
    
    
    private func setInitialUI() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.delegate = self
        
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
    
    
    private func bind() {
        viewModel.myWishStudyList
            .withUnretained(self)
            .bind { (vc, _) in
                vc.customView.myWishList.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    
    private func appendWishStudyList(list: [String]) {
        if viewModel.studyEnterValidation(count: list.count) {
            viewModel.appendWishStudyList(list: list)
        }else {
            showToast(message: "스터디를 더 이상 추가할 수 없습니다")
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
        if collectionView.tag == 0 {
            return 2
        }else {
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return section == 0 ? viewModel.recommendList.count : viewModel.userStudyList.count
        }else {
            return viewModel.myWishStudyList.value.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudyListCollectionViewCell.identifier, for: indexPath) as? StudyListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if collectionView.tag == 0 {
            cell.updateCell(title: indexPath.section == 0 ? viewModel.recommendList[indexPath.row] : viewModel.userStudyList[indexPath.row], style: indexPath.section == 0 ? .recommend : .normal)
        }else {
            cell.updateCell(title: viewModel.myWishStudyList.value[indexPath.row], style: .userAdded)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if collectionView.tag == 0 {
            let selectedStudy = indexPath.section == 0 ? viewModel.recommendList[row] : viewModel.userStudyList[row]
            appendWishStudyList(list: [selectedStudy])
            
        }else {
            viewModel.removeWishStudyList(at: row)
        }
    }
}




// MARK: - SearchBar Delegate
extension EnterStudyViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let list = searchBar.text?.components(separatedBy: " ") ?? []
        
        appendWishStudyList(list: list)
    }
}
