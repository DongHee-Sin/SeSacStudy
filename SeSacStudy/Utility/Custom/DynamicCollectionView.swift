//
//  DynamicCollectionView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/20.
//

import UIKit


final class DynamicCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}
