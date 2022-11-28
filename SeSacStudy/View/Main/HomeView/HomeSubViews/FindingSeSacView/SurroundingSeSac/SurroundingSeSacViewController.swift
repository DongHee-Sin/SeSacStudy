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
        cell.updateCell(user: data, isExpand: expand)
        
        cell.expandButton.tag = indexPath.section
        cell.expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        
        cell.userStudyList = DataStorage.shared.SearchResult.fromQueueDB[indexPath.section].studylist
        
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
