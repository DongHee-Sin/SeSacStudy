//
//  ReusableInitialView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import UIKit

import SnapKit
import Then


final class ReusableInitialView: BaseView {
    
    // MARK: - Propertys
//    private let stackView = UIStackView().then {
//    }
//    
//    let label = UILabel()
//    
//    let view = UIView()
//    
//    let button = UIButton().then {
//        $0.
//    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        //
    }
    
    
    override func setConstraint() {
        //
    }
    
}




extension ReusableInitialView {
    
    private var calcKeyboardHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return getWidth() < getHeight() ? 216 : 162
            
        } else{
            return getWidth() < getHeight() ? 265 : 353
            
        }
    }
    
    
    func getWidth() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    func getHeight() -> CGFloat{
        return UIScreen.main.bounds.height
    }
    
}
