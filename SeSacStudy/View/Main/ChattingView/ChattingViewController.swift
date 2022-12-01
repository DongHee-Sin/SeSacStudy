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


final class ChattingViewController: BaseViewController {
    
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
        
        bind()
        keyboardBind()
    }
    
    
    private func setNavigationBar() {
        navigationItem.title = "User Nickname"
        
//        let moreButton = UIBarButtonItem(image: R.image.more(), style: .plain, target: self, action: #selector(<#T##@objc method#>))
//        navigationItem.rightBarButtonItem = moreButton
    }
    
    
    private func bind() {
        let rxTextView = customView.chatInputView.textView.rx
        let input = ChattingViewModel.Input(text: rxTextView.text, beginEditing: rxTextView.didBeginEditing, endEditing: rxTextView.didEndEditing)
        let output = viewModel.transform(input: input)
        
        
        output.line
            .withUnretained(self)
            .bind { (vc, value) in
                print("☘️☘️☘️☘️☘️☘️☘️☘️")
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
