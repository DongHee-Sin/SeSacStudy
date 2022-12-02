//
//  MoreExpandedView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/02.
//

import UIKit


final class MoreExpandedView: BaseView {
    
    // MARK: - Propertys
    let stackView = UIStackView().then {
        $0.backgroundColor = R.color.white()
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    lazy var reportButton = UIButton().then {
        $0.configuration = setConfiguration(title: "새싹 신고", image: R.image.siren())
    }
    
    lazy var cancelButton = UIButton().then {
        $0.configuration = setConfiguration(title: "스터디 취소", image: R.image.cancel_match())
    }
    
    lazy var reviewButton = UIButton().then {
        $0.configuration = setConfiguration(title: "리뷰 등록", image: R.image.write())
    }
    
    let dismissButton = UIButton().then {
        $0.backgroundColor = R.color.black()?.withAlphaComponent(0.5)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.backgroundColor = .clear
        
        [reportButton, cancelButton, reviewButton].forEach {
            stackView.addArrangedSubview($0)
            $0.isHidden = true
        }
        
        [dismissButton, stackView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.top.leading.trailing.equalTo(self)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func hideButtons(_ value: Bool) {
        stackView.subviews.forEach {
            $0.isHidden = value
        }
    }
}




extension MoreExpandedView {
    private func setConfiguration(title: String, image: UIImage?) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = image
        
        config.imagePlacement = .top
        config.imagePadding = 6
        config.baseForegroundColor = R.color.black()
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = .customFont(.title3_M14)
            return outgoing
        })
        
        return config
    }
}
