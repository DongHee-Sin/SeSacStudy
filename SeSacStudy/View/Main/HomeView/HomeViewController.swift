//
//  HomeViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/11.
//

import UIKit

import CoreLocation
import MapKit


final class HomeViewController: BaseViewController {
    
    // MARK: - Propertys
    private let locationManager = CLLocationManager()
    
    private let viewModel = HomeViewModel()
    
    
    
    
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
        checkUserDeviceLocationServiceAuthorization()
        
        locationManager.delegate = self
        customView.mapView.delegate = self
        
        requestQueueStatus()
    }
    
    
    private func requestQueueStatus() {
        
        APIService.share.request(type: QueueStatus.self, router: .queueStatus) { result, _, statusCode in
            
            switch statusCode {
            case 200:
                if let result {
                    print(result)
                }
            case 201:
                print("매칭하지 않은 일반 상태")
            case 401:
                print("id토큰 만료")
            case 406:
                print("미가입 회원")
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




// MARK: - MapView Delegate
extension HomeViewController: MKMapViewDelegate {
    
}




// MARK: - CLLocation Authorization
extension HomeViewController {
    
    private func checkUserDeviceLocationServiceAuthorization() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            guard CLLocationManager.locationServicesEnabled() else {
                self.showRequestLocationServiceAlert()
                return
            }

            let authorizationStatus: CLAuthorizationStatus = self.locationManager.authorizationStatus
                
            self.checkUserCurrentLocationAuthorization(authorizationStatus)
        }
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
        
        DispatchQueue.main.async { [weak self] in
            self?.present(requestLocationServiceAlert, animated: true)
        }
    }
    
}




// MARK: - CLLocation Delegate
extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            customView.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "사용자 위치를 가져오는데 실패했습니다.")
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}
