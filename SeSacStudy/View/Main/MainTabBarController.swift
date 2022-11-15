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
        
        setViewControllers()
        setTabbarStyle()
    }
    
    
    private func setViewControllers() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: R.image.property1HomeProperty2Inact(), selectedImage: R.image.property1HomeProperty2Act())
        
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        settingVC.tabBarItem = UITabBarItem(title: "내정보", image: R.image.property1MyProperty2Inact(), selectedImage: R.image.property1MyProperty2Act())
        
        viewControllers = [homeVC, settingVC]
    }
    
    
    private func setTabbarStyle() {
        tabBar.tintColor = R.color.green()
        tabBar.unselectedItemTintColor = R.color.gray6()
    }
    
}
