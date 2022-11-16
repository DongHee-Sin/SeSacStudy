//
//  HomeViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/11.
//

import UIKit

import CoreLocation



final class HomeViewController: BaseViewController {
    
    // MARK: - Propertys
    private let locationManager = CLLocationManager()
    
    
    
    
    // MARK: - Life Cycle
    private let customView = HomeView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        locationManager.delegate = self
    }
}




// MARK: - CLLocation Authorization
extension HomeViewController {
    
    private func checkUserDeviceLocationServiceAuthorization() {
        guard CLLocationManager.locationServicesEnabled() else {
            showRequestLocationServiceAlert()
            return
        }

        let authorizationStatus: CLAuthorizationStatus = locationManager.authorizationStatus
            
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    
    private func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted:
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            
        default:
            print("Default")
        }
    }
    
    
    private func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
}




// MARK: - CLLocation Delegate
extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            // ⭐️ 사용자 위치 정보 사용
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "사용자 위치를 가져오는데 실패했습니다.")
    }
}
