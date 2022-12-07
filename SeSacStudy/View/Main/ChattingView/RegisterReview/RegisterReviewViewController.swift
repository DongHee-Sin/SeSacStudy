//
//  RegisterReviewViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/07.
//

import UIKit


final class RegisterReviewViewController: RxBaseViewController {
    
    // MARK: - Propertys
    
    
    
    
    // MARK: - Life Cycle
    private let customView = RegisterReviewView(nick: DataStorage.shared.matchedUser.nick)
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        customView.sesacTitleView.buttons.forEach {
            $0.addTarget(self, action: #selector(sesacTitleButtonTapped), for: .touchUpInside)
        }
        
        customView.titleView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        bind()
    }
    
    
    private func bind() {
        customView.reviewTextView.rx.didBeginEditing
            .bind{ _ in
                if self.customView.reviewTextView.text == Placeholder.registerReview.rawValue {
                    self.customView.reviewTextView.text = ""
                }
                self.customView.reviewTextView.textColor = R.color.black()
            }.disposed(by: disposeBag)
        
        customView.reviewTextView.rx.didEndEditing
            .bind{
                if self.customView.reviewTextView.text.count == 0 {
                    self.customView.reviewTextView.text = Placeholder.registerReview.rawValue
                    self.customView.reviewTextView.textColor = R.color.gray7()
                }
            }.disposed(by: disposeBag)
    }
    
    
    @objc private func sesacTitleButtonTapped(_ button: BasicButton) {
        if button.buttonStatus == .inactive {
            button.setButtonStyle(status: .fill)
        }else {
            button.setButtonStyle(status: .inactive)
        }
    }
    
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
}
