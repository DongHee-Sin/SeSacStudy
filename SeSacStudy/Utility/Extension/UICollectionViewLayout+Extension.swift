//
//  UICollectionViewLayout+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


extension UICollectionViewLayout {
    
    static var onboardingViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth: CGFloat = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        
        return layout
    }
    
}
