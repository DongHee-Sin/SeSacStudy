//
//  ViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func loadView() {
        let cusView = UIView()
        
        let label = UILabel()
        cusView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(cusView)
            make.width.equalTo(200)
        }
        label.text = "안녕하세요"
        label.font = .customFont(.body1_M16)
        self.view = cusView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

