//
//  UICollectionViewLayout+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


extension UICollectionViewLayout {
    
    static var onboardingViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groubSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

            let groub = NSCollectionLayoutGroup.horizontal(layoutSize: groubSize, subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: groub)
            section.orthogonalScrollingBehavior = .paging

            return section
        }

        return layout
    }
    
}
