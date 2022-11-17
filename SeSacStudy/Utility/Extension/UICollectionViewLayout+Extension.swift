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
    
    
    
    
    // MARK: - Study List
    static var studyListLayout: UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .estimated(1))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groubSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .estimated(1))
            
            let groub = NSCollectionLayoutGroup.horizontal(layoutSize: groubSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: groub)
            
            return section
        }
        
        return layout
    }
}
