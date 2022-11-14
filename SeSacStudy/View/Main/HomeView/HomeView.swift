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
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(mapView)
    }
    
    
    override func setConstraint() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
