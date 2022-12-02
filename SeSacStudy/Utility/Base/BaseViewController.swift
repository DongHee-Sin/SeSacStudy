//
//  BaseViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/02.
//

import UIKit


class BaseViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = ""
        
        configure()
    }
    
    
    
    
    // MARK: - Methods
    func configure() {}
}
