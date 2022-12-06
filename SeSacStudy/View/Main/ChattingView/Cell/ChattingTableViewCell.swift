//
//  ChattingTableViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import UIKit


enum ChattingCellType {
    case received
    case send
}


final class ChattingTableViewCell: BaseTableViewCell {

    // MARK: - Propertys
    private let baseView = UIView().then {
        $0.layer.cornerRadius = 8
    }
    
    private let chatLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .customFont(.body3_R14)
        $0.textColor = R.color.black()
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "TEST : 15:02"
        $0.font = .customFont(.title6_R12)
        $0.textColor = R.color.gray6()
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [baseView, chatLabel, dateLabel].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        chatLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(baseView).inset(10)
            make.horizontalEdges.equalTo(baseView).inset(16)
        }
    }
    
    
    func updateCell(chat: String, createdAt: String, type: ChattingCellType) {
        chatLabel.text = chat
        dateLabel.text = createdAt
        
        switch type {
        case .received:
            baseView.layer.borderColor = R.color.gray6()?.cgColor
            baseView.layer.borderWidth = 1
            baseView.backgroundColor = .clear
            
            baseView.snp.remakeConstraints { make in
                make.width.lessThanOrEqualTo(self).multipliedBy(0.7)
                make.verticalEdges.equalTo(self).inset(12)
                make.leading.equalTo(self).offset(16)
            }
            
            dateLabel.snp.remakeConstraints { make in
                make.leading.equalTo(baseView.snp.trailing).offset(8)
                make.bottom.equalTo(baseView.snp.bottom)
            }
        case .send:
            baseView.layer.borderWidth = 0
            baseView.backgroundColor = R.color.whitegreen()
            
            baseView.snp.remakeConstraints { make in
                make.width.lessThanOrEqualTo(self).multipliedBy(0.7)
                make.verticalEdges.equalTo(self).inset(12)
                make.trailing.equalTo(self).offset(-16)
            }
            
            dateLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(baseView.snp.leading).offset(-8)
                make.bottom.equalTo(baseView.snp.bottom)
            }
        }
    }
}
