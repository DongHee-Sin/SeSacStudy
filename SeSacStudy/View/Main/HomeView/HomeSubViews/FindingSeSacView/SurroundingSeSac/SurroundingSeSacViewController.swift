//
//  SurroundingSeSacViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/22.
//

import UIKit


final class SurroundingSeSacViewController: BaseViewController {
    
    // MARK: - Propertys
    var delegate: SeSacTabmanViewController? = nil
    
    private lazy var placeHolderView = NotfoundView(type: .surroundingSeSac)
    
    private let userList = DataStorage.shared.SearchResult.fromQueueDB
    
    private lazy var expandList: [Bool] = Array(repeating: false, count: userList.count)
    
    
    
    
    // MARK: - Life Cycle
    private let customView = ProfileView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("탭 전환 - 주변새싹")
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setTableView()
        
        showPlaceHolderView(true)
    }
    
    
    private func setTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        
        customView.tableView.register(ProfileImageTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ProfileImageTableViewHeader.identifier)
        customView.tableView.register(ProfileExpandableTableViewCell.self, forCellReuseIdentifier: ProfileExpandableTableViewCell.identifier)
    }
    
    
    @objc func expandButtonTapped(_ button: UIButton) {
        print("\(button.tag) 번 버튼 tap")
        
        expandList[button.tag].toggle()
        customView.tableView.reloadSections([button.tag], with: .fade)
    }
}




// MARK: - TableView Protocol
extension SurroundingSeSacViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileImageTableViewHeader.identifier) as? ProfileImageTableViewHeader else {
            return UIView()
        }
        
        header.customImageView.setImageView(img: R.image.sesac_background_1(), buttonType: .request)
        
        return header
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = userList.count
        showPlaceHolderView(count == 0)
        
        return count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileExpandableTableViewCell.identifier, for: indexPath) as? ProfileExpandableTableViewCell else {
            return UITableViewCell()
        }
        
        let data = userList[indexPath.section]
        let expand = expandList[indexPath.section]
//        cell.updateCell(user: data, isExpand: true)
        cell.updateCell(user: data, isExpand: expand, delegate: self)
        
        cell.wishStudyListView.collectionView.tag = indexPath.section
        
        /// expand버튼 어케 처리할지?
        /// 1. button마다 tag부여 (section값으로)
        /// 2. addTarget으로 버튼탭하면 tag값의 section reload
        cell.expandButton.tag = indexPath.section
        cell.expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        
        return cell
    }
}




// MARK: - CollectionView Protocol
extension SurroundingSeSacViewController: CollectionViewProtocol {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = DataStorage.shared.SearchResult.fromQueueDB[collectionView.tag].reviews.count
        return count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudyListCollectionViewCell.identifier, for: indexPath) as? StudyListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = userList[collectionView.tag].reviews[indexPath.item]
        //DataStorage.shared.SearchResult.fromQueueDB[collectionView.tag].reviews[indexPath.item]
        cell.updateCell(title: data, style: .normal)
        
        return cell
    }
}




// MARK: - TabmanSubViewController
extension SurroundingSeSacViewController: TabmanSubViewController {
    
    func changeStudyButtonTapped() {
        delegate?.changeStudyButtonTapped()
    }
    
    
    func reloadButtonTapped() {
        // API request
    }
    
    
    func showPlaceHolderView(_ value: Bool) {
        if value {
            view.addSubview(placeHolderView)
            
            placeHolderView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            placeHolderView.changeStudyButton.rx.tap.withUnretained(self)
                .bind { (vc, _) in
                    vc.changeStudyButtonTapped()
                }
                .disposed(by: disposeBag)
            
            placeHolderView.reloadButton.rx.tap.withUnretained(self)
                .bind { (vc, _) in
                    vc.reloadButtonTapped()
                }
                .disposed(by: disposeBag)
        }else {
            placeHolderView.isHidden = true
        }
    }
}
