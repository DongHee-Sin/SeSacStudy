//
//  CustomAnnotation.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/17.
//

import Foundation

import CoreLocation
import MapKit


final class CustomAnnotationView: MKAnnotationView {
    
    static var identifier: String { "CustomAnnotationView" }
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
}


final class CustomAnnotation: NSObject, MKAnnotation {
    let imageNum: Int
    let coordinate: CLLocationCoordinate2D
    
    
    init(imageNum: Int, location: CLLocationCoordinate2D) {
        self.imageNum = imageNum
        self.coordinate = location
        
        super.init()
    }
    
}
