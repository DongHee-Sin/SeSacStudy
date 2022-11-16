//
//  HomeView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit
import MapKit


final class HomeView: BaseView {
    
    // MARK: - Propertys
    let mapView = MKMapView()
    
    private let genderFilderImage = UIImageView().then {
        $0.image = R.image.button_filter()
    }
    
    private let annotationImage = UIImageView().then {
        $0.image = R.image.map_marker()
    }
    
    let gpsButton = UIButton().then {
        $0.setImage(R.image.bt_gps(), for: .normal)
    }
    
    let floatingButton = UIButton().then {
        $0.setImage(R.image.property1Default(), for: .normal)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [mapView, genderFilderImage, annotationImage, gpsButton, floatingButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        genderFilderImage.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        gpsButton.snp.makeConstraints { make in
            make.top.equalTo(genderFilderImage.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(genderFilderImage)
            make.height.equalTo(gpsButton.snp.width)
        }
        
        annotationImage.snp.makeConstraints { make in
            make.center.equalTo(mapView)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(48)
        }
    }
}
