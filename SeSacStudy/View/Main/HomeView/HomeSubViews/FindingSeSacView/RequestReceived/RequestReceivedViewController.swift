//
//  RequestReceivedViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/22.
//

import UIKit


final class RequestReceivedViewController: BaseViewController {
    
    // MARK: - Propertys
    var delegate: SeSacTabmanViewController? = nil
    
    private lazy var placeHolderView = NotfoundView(type: .surroundingSeSac)
    
    
    
    
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
        
        print("탭 전환 - 받은 요청")
    }
    
    
    
    
    // MARK: - Methods
    
}




// MARK: - TabmanSubViewController
extension RequestReceivedViewController: TabmanSubViewController {
    
    func changeStudyButtonTapped() {
        delegate?.changeStudyButtonTapped()
    }
    
    
    func reloadButtonTapped() {
        // API request
    }
    
    
    func showPlaceHolderView(_ value: Bool) {
        if value {
            view.addSubview(placeHolderView)
            
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

