//
//  ChattingTableViewHeader.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import UIKit


final class ChattingTableViewHeader: UITableViewHeaderFooterView {

    // MARK: - Propertys
    static var identifier: String {
        return String(describing: self)
    }
    
    let dateLabel = UILabel().then {
        $0.backgroundColor = R.color.gray7()
        $0.layer.cornerRadius = 20
        $0.textColor = R.color.white()
        $0.font = .customFont(.title5_M12)
    }
    
    
    
    
    // MARK: - LifeCycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    // MARK: - Methods
    private func configureUI() {
        //self.addSubview(customImageView)
    }
    
    
    private func setConstraint() {
//        customImageView.snp.makeConstraints { make in
//            make.verticalEdges.equalTo(self)
//            make.horizontalEdges.equalTo(self).inset(16)
//            make.height.equalTo(customImageView.snp.width).multipliedBy(0.57)
//        }
    }
}
