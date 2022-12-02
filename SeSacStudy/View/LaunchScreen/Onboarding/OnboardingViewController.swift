//
//  OnboardingViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa


final class OnboardingViewController: RxBaseViewController {

    // MARK: - Propertys
    private let onboardings: [Onboarding] = [
        Onboarding(title: "위치 기반으로 빠르게\n주위 친구를 확인", image: R.image.onboarding_img1(), highlightedText: "위치 기반", highlightedColor: R.color.green()),
        Onboarding(title: "스터디를 원하는 친구를\n찾을 수 있어요", image: R.image.onboarding_img2(), highlightedText: "스터디를 원하는 친구", highlightedColor: R.color.green()),
        Onboarding(title: "SeSAC Study", image: R.image.onboarding_img3())
    ]
    
    
    
    
    // MARK: - Life Cycle
    private let onboardingView = OnboardingView()
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        onboardingView.collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        onboardingView.collectionView.delegate = self
        onboardingView.collectionView.dataSource = self
        
        bind()
    }
    
    
    private func bind() {
        onboardingView.startButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let navi = UINavigationController(rootViewController: EnterPhoneNumberViewController())
                vc.changeRootViewController(to: navi)
            }
            .disposed(by: disposeBag)
    }
}




extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardings.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateCell(data: onboardings[indexPath.item])
        
        return cell
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / view.frame.width)
        onboardingView.pageControl.currentPage = page
    }
}
