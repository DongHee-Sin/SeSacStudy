//
//  SearchAgeGroupView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit

import RxSwift
import RxCocoa
import MultiSlider


final class SearchAgeGroupView: BaseView {
    
    // MARK: - Propertys
    private let label = UILabel().then {
        $0.textColor = R.color.black()
        $0.font = .customFont(.title4_R14)
        $0.text = "상대방 연령대"
    }
    
    let rangeLabel = UILabel().then {
        $0.textColor = R.color.green()
        $0.font = .customFont(.title3_M14)
    }
    
    let slider = MultiSlider().then {
        $0.outerTrackColor = R.color.gray2()
        $0.tintColor = R.color.green()
        $0.thumbTintColor = R.color.green()
        $0.hasRoundTrackEnds = true
        $0.orientation = .horizontal
        $0.trackWidth = 4
        
        $0.maximumValue = 65
        $0.minimumValue = 18
        $0.snapStepSize = 1

        $0.thumbCount = 2
    }
    
    private var disposeBag = DisposeBag()
    
    let ageRange = PublishSubject<[CGFloat]>()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        bind()
        
        [label, rangeLabel, slider].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        label.snp.makeConstraints { make in
            make.top.equalTo(self).inset(8)
            make.leading.equalTo(self)
        }
        
        rangeLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(8)
            make.trailing.equalTo(self)
        }
        
        slider.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.top.equalTo(label.snp.bottom)
            make.bottom.equalTo(self)
        }
    }
    
    
    private func bind() {
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        ageRange.withUnretained(self)
            .bind { (view, value) in
                let min = Int(value.first ?? 0)
                let max = Int(value.last ?? 0)
                view.labelUpdate(min: min, max: max)
            }
            .disposed(by: disposeBag)
    }
    
    
    @objc private func sliderChanged(slider: MultiSlider) {
        ageRange.onNext(slider.value)
    }
    
    
    private func labelUpdate(min: Int, max: Int) {
        rangeLabel.text = "\(min) - \(max)"
    }
    
    
    func updateView(min: Int, max: Int) {
        slider.value = [CGFloat(min), CGFloat(max)]
        labelUpdate(min: min, max: max)
    }
}
