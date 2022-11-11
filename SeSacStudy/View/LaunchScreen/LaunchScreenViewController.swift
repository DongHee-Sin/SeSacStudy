//
//  LaunchScreenViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/11.
//

import UIKit


final class LaunchScreenViewController: BaseViewController {
    
    // MARK: - Propertys
    
    
    
    
    // MARK: - Life Cycle
    private let customView = LaunchScreenView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    
}
