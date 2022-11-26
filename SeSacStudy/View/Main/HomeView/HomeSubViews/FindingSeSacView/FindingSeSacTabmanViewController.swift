//
//  FindingSeSacTabmanViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/22.
//

import UIKit

import Tabman
import Pageboy


final class FindingSeSacTabmanViewController: TabmanViewController {
    
    // MARK: - Propertys
    private var viewControllers: [UIViewController] = [
        SurroundingSeSacViewController(),
        RequestReceivedViewController()
    ]
    
    private let changeStudyButton = BasicButton(status: .fill).then {
        $0.titleLabel?.font = .customFont(.body3_R14)
        $0.setTitle("스터디 변경하기", for: .normal)
    }
    
    private let reloadButton = UIButton().then {
        $0.setImage(R.image.bt_refresh(), for: .normal)
    }
    
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabman()
        setInitialUI()
        setFloatingButton()
        
        view.backgroundColor = R.color.white()
    }
    
    
    
    
    // MARK: - Methods
    private func configureTabman() {
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.backgroundView.style = .clear
        
        
        bar.indicator.weight = .medium
        bar.indicator.tintColor = R.color.green()
        bar.indicator.overrideUserInterfaceStyle = .light
        bar.indicator.overscrollBehavior = .compress
        
        bar.layout.contentInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: 20)
        
        bar.buttons.customize {
            $0.font = .customFont(.title3_M14)
            $0.tintColor = R.color.gray6()
            $0.selectedTintColor = R.color.green()
        }
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    
    private func setInitialUI() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "새싹 찾기"
        
        setNavigationBarButtonItem()
    }
    
    
    private func setNavigationBarButtonItem() {
        let stopFindingButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopFindingButtonTapped))
        stopFindingButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont.customFont(.title3_M14)], for: UIControl.State.normal)
        navigationItem.rightBarButtonItem = stopFindingButton
    }
    
    
    private func setFloatingButton() {
        [changeStudyButton, reloadButton].forEach {
            view.addSubview($0)
        }
        
        changeStudyButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(reloadButton.snp.leading).offset(-8)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(48)
        }
        
        changeStudyButton.addTarget(self, action: #selector(changeStudyButtonTapped), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func changeStudyButtonTapped() {
        guard let count = navigationController?.viewControllers.count else { return }
        if count >= 3 {
            navigationController?.popViewController(animated: true)
        }else {
            transition(EnterStudyViewController(), transitionStyle: .push)
        }
    }
    
    
    @objc private func reloadButtonTapped() {
        //
    }
    
    
    @objc private func stopFindingButtonTapped() {
        requestCancelSearch()
    }
}




// MARK: - Request API
extension FindingSeSacTabmanViewController {
    
    private func requestCancelSearch() {
        APIService.share.request(router: .cancelRequestSearch) { [weak self] _, statusCode in
            switch statusCode {
            case 200:
                let navi = UINavigationController(rootViewController: MainTabBarController())
                self?.changeRootViewController(to: navi)
            case 201:
                self?.showToast(message: "누군가와 스터디를 함께하기로 약속하셨어요!")
                // 채팅화면으로 이동
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestCancelSearch()
                    case .failure(let error):
                        self?.showErrorAlert(error: error)
                    }
                }
            case 406:
                self?.showAlert(title: "가입되지 않은 회원입니다. 초기화면으로 이동합니다.") { _ in
                    self?.changeRootViewController(to: OnboardingViewController())
                }
            case 500:
                print("Server Error")
            case 501:
                print("Client Error")
            default:
                print("Default")
            }
        }
    }
}




// MARK: - Tabman Protocol
extension FindingSeSacTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: index == 0 ? "주변 새싹" : "받은 요청")
        
        return item
    }
}
