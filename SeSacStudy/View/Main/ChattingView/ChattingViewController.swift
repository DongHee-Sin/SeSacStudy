//
//  ChattingViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard


final class ChattingViewController: RxBaseViewController {
    
    // MARK: - Propertys
    private let viewModel = ChattingViewModel()
    
    
    
    
    // MARK: - Life Cycle
    private let customView = ChattingView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setNavigationBar()
        setTableView()
        
        bind()
        keyboardBind()
    }
    
    
    private func setTableView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        
        customView.tableView.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.identifier)
        customView.tableView.register(ChattingTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ChattingTableViewHeader.identifier)
    }
    
    
    private func setNavigationBar() {
        navigationItem.title = "고래밥"
        
        let moreButton = UIBarButtonItem(image: R.image.more(), style: .plain, target: self, action: #selector(moreButtonTapped))
        navigationItem.rightBarButtonItem = moreButton
    }
    
    
    private func bind() {
        let rxTextView = customView.chatInputView.textView.rx
        let input = ChattingViewModel.Input(text: rxTextView.text, beginEditing: rxTextView.didBeginEditing, endEditing: rxTextView.didEndEditing)
        let output = viewModel.transform(input: input)
        
        
        output.line
            .withUnretained(self)
            .bind { (vc, value) in
                vc.customView.updateTextViewHeight(line: value)
            }
            .disposed(by: disposeBag)
        
        
        output.beginEditing
            .bind{ _ in
                if self.customView.chatInputView.textView.text == Placeholder.chatting.rawValue {
                    self.customView.chatInputView.textView.text = ""
                }
                self.customView.chatInputView.textView.textColor = R.color.black()
            }.disposed(by: disposeBag)
        
        
        output.endEditing
            .bind{
                if self.customView.chatInputView.textView.text.count == 0 {
                    self.customView.chatInputView.textView.text = Placeholder.chatting.rawValue
                    self.customView.chatInputView.textView.textColor = R.color.gray7()
                }
            }.disposed(by: disposeBag)
    }
    
    
    @objc private func moreButtonTapped() {
        customView.showUpMoreExpandedView(true)
    }
}




// MARK: - Keyboard 대응
extension ChattingViewController {
    
    private func keyboardBind() {
        RxKeyboard.instance.visibleHeight
            .drive { [weak self] height in
                guard let self else { return }
                self.customView.updateChatInputViewLayout(height: height)
                self.customView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }
}




// MARK: - TableView Protocol
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChattingTableViewHeader.identifier) as? ChattingTableViewHeader else {
            return UIView()
        }
        
        return header
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.identifier, for: indexPath) as? ChattingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateCell(chat: "안녕하세요 굿밤되세요", type: indexPath.row == 0 ? .received : .send)
        
        return cell
    }
}
