//
//  OnboardingViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


final class OnboardingViewController: BaseViewController {

    // MARK: - Propertys
    let onboardingImages: [UIImage?] = [
        R.image.onboarding_img1(), R.image.onboarding_img2(), R.image.onboarding_img3()
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
    }
}




extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.mainImageView.image = onboardingImages[indexPath.item]
        
        return cell
    }
}
