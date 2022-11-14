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
    
    
    
    
    // MARK: -
    static var studyListLayout: UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                    
                // 아이템에 대한 사이즈
                // absolute는 고정값, estimated는 추측, fraction은 퍼센트 (상위 요소 크기에 대한 비율 => 얘는 그룹 사이즈에 비례)
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                    
                // 아이템 만들기
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                // 아이템 간의 간격 설정
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                   
                // 그룹 사이즈   => 얘는 비율로 잡으면 CollectionView 뷰객체의 크기에 비례
                let groubSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
                    
                // 그룹 만들기
                let groub = NSCollectionLayoutGroup.horizontal(layoutSize: groubSize, subitem: item, count: 2)
                    
                    // 그룹으로 섹션 만들기
                let section = NSCollectionLayoutSection(group: groub)
                //section.orthogonalScrollingBehavior = .continuous   // 가로 스크로르
                    
                // 섹션에 대한 간격 설정
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
                    
                return section
            }
                
            return layout
        
    }
}
