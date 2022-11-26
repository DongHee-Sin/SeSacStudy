//
//  TabmanSubViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/26.
//

import UIKit


protocol TabmanSubViewController: UIViewController {
    var delegate: SeSacTabmanViewController? { get set }
    
    func changeStudyButtonTapped()
    
    func reloadButtonTapped()
    
    func showPlaceHolderView(_ value: Bool)
}
