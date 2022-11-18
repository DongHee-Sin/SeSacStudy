//
//  UICollectionViewLayout+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


extension UICollectionViewLayout {
    
    // MARK: - Onboarding
    static var onboardingViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth: CGFloat = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        
        return layout
    }
}




final class StudyListLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 8
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
