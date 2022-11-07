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
            make.height.equalTo(500)
        }
        label.attributedText = .attributedString(text: "안녕하세요\n뚱이에요\n반가워요", style: .title6_R12, color: ColorManager.green)
//        label.text = "안녕하세요\n뚱이에요\n반가워요"
        label.numberOfLines = 0
        self.view = cusView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }


}
