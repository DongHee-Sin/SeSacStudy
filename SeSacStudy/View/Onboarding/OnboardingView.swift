//
//  OnboardingView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit

import SnapKit
import Then


final class OnboardingView: BaseView {
    
    // MARK: - Propertys
    let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: .onboardingViewLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.numberOfPages = 3
        $0.currentPageIndicatorTintColor = ColorManager.black
        $0.pageIndicatorTintColor = ColorManager.gray5
    }
    
    
    let startButton = BasicButton(status: .fill).then {
        $0.setTitle("시작하기", for: .normal)
    }
    
    
    
    
    // MARK: - Methdos
    override func configureUI() {
        [collectionView, pageControl, startButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        startButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(startButton.snp.top).offset(-42)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(pageControl.snp.top)
        }
    }
}
