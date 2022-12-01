//
//  ChattingView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import UIKit


final class ChattingView: BaseView {
    
    // MARK: - Propertys
    let tableView = UITableView(frame: CGRect(), style: .grouped).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    let chatInputView = ChatInputView()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [tableView, chatInputView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        chatInputView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(chatInputView.snp.top).offset(-8)
        }
    }
    
    
    func updateChatInputViewLayout(height: CGFloat) {
        chatInputView.snp.updateConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(height > 0 ? -height : -16)
        }
    }
    
    
    func updateTextViewHeight(line: TextViewLine) {
        chatInputView.textView.isScrollEnabled = line == .moreThanThree
        chatInputView.textView.snp.updateConstraints { make in
            make.height.equalTo(line.height)
        }
    }
}
