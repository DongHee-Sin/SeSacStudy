//
//  MainTabBarController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/11.
//

import UIKit


final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: nil, selectedImage: nil)
        
        viewControllers = [homeVC]
    }
    
}
