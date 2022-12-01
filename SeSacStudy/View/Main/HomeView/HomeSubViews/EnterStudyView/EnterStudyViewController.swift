//
//  EnterStudyViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/17.
//

import UIKit

import CoreLocation
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
        
        test()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setInitialUI()
        setCollectionView()
        
        keyboardBind()
        bind()
        
        requestSearchSurrounding()
    }
    
    
    private func setInitialUI() {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        
        let searchBar = UISearchBar()
        searchBar.placeholder = Placeholder.study.rawValue
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
        
        
        customView.button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.requestSearchUser()
            }
            .disposed(by: disposeBag)
    }
    
    
    private func appendWishStudyList(list: [String]) {
        switch viewModel.appendWishStudyList(list: list) {
        case .success: break
        case .exceedLimit: showToast(message: "스터디를 더 이상 추가할 수 없습니다")
        case .duplicateStudy: showToast(message: "이미 등록된 스터디입니다")
        }
    }
    
    
    private func requestSearchSurrounding() {
        
        APIService.share.request(type: QueueSearchResult.self, router: .queueSearch) { [weak self] result, _, statusCode in
            switch statusCode {
            case 200:
                if let result {
                    var userStudyList: [String] = []
                    result.fromQueueDB.forEach { userStudyList.append(contentsOf: $0.studylist) }
                    result.fromQueueDBRequested.forEach { userStudyList.append(contentsOf: $0.studylist) }
                    self?.viewModel.userStudyList = userStudyList
                    self?.viewModel.recommendList = result.fromRecommend

                    self?.customView.surroundingList.collectionView.reloadData()
                }
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestSearchSurrounding()
                    case .failure(let error):
                        self?.showErrorAlert(error: error)
                    }
                }
            case 406:
                self?.showAlert(title: "가입되지 않은 회원입니다. 초기화면으로 이동합니다.") { _ in
                    self?.changeRootViewController(to: OnboardingViewController())
                }
            case 500:
                print("Server Error")
            case 501:
                print("Client Error")
            default:
                print("Default")
            }
        }
    }
    
    
    private func requestSearchUser() {
        
        APIService.share.request(router: .requestSearch(list: viewModel.myWishStudyList.value)) { [weak self] _, statusCode in
            switch statusCode {
            case 200:
                guard let count = self?.navigationController?.viewControllers.count else { return }
                if count >= 3 {
                    self?.navigationController?.popViewController(animated: true)
                }else {
                    self?.transition(FindingSeSacTabmanViewController(), transitionStyle: .push)
                }
            case 201: print("신고 누적되어 이용불가")
            case 203: print("스터디 취소 패널티 1단계")
            case 204: print("스터디 취소 패널티 2단계")
            case 205: print("스터디 취소 패널티 3단계")
            case 401: print("firebase token error")
            case 406: print("미가입회원")
            case 500: print("서버에러")
            case 501: print("클라이언트에러")
            default: break
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
            cell.updateCell(title: viewModel.myWishStudyList.value[indexPath.row], style: .userAdded, image: UIImage(systemName: "xmark"))
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
    
    
    
    
    
    
    
    
    
    
    func test() {
        guard var viewControllers = navigationController?.viewControllers else { return }
        
        if viewControllers.count >= 3 {
            if let index = viewControllers.firstIndex(where: { return $0 is FindingSeSacTabmanViewController }) {
                viewControllers.remove(at: index)
                navigationController?.viewControllers = viewControllers
            }
        }else {
            print(">>>>>>>>>>????☘️☘️☘️☘️☘️☘️☘️☘️")
        }
    }
}
