//
//  BaseViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit

import RxSwift


class BaseViewController: UIViewController {
    
    // MARK: - Propertys
    var disposeBag = DisposeBag()
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = ""
        
        configure()
    }
    
    
    
    
    // MARK: - Methods
    func configure() {}
}
