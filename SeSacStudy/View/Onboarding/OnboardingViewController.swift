//
//  OnboardingViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


final class OnboardingViewController: BaseViewController {

    // MARK: - Propertys
    
    
    
    
    // MARK: - Life Cycle
    private let onboardingView = OnboardingView()
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        //
    }
}
