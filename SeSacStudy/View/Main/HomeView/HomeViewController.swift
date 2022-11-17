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
        setDelegate()
        bind()
        
        checkUserDeviceLocationServiceAuthorization()
        requestQueueStatus()
    }
    
    
    private func setDelegate() {
        locationManager.delegate = self
        customView.mapView.delegate = self
    }
    
    
    private func bind() {
        viewModel.matchStatus
            .withUnretained(self)
            .bind { (vc, status) in
                switch status {
                case .normal:
                    vc.customView.floatingButton.setImage(R.image.property1Default(), for: .normal)
                case .waitingMatch:
                    vc.customView.floatingButton.setImage(R.image.property1Matching(), for: .normal)
                case .matched:
                    vc.customView.floatingButton.setImage(R.image.property1Matched(), for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        
        viewModel.location
            .withUnretained(self)
            .bind { (vc, location) in
                vc.requestSearchSurrounding(location: location)
            }
            .disposed(by: disposeBag)
        
        
        customView.gpsButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.checkUserDeviceLocationServiceAuthorization()
            }
            .disposed(by: disposeBag)
        
        
        customView.floatingButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                print("button tap")
                /// 지금 생각한 방법..
                /// status 변경에 대한 바인딩을 할 때, 따로 프로퍼티 하나를 더 유지
                /// 해당 프로퍼티를 기준으로 floating button 이벤트에 대한 분기처리 수행...
            }
            .disposed(by: disposeBag)
    }
    
    
    private func addCustomPin(lat: Double, long: Double) {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        pin.title = "새싹 영등포캠퍼스"
        pin.subtitle = "전체 3층짜리 건물"
        customView.mapView.addAnnotation(pin)
    }
}




// MARK: - Request API
extension HomeViewController {
    
    private func requestQueueStatus() {
        APIService.share.request(type: QueueStatus.self, router: .queueStatus) { [weak self] result, _, statusCode in
            switch statusCode {
            case 200:
                if let result {
                    self?.viewModel.matchStatus.accept(result.matched == 0 ? .waitingMatch : .matched)
                }
            case 201:
                self?.viewModel.matchStatus.accept(.normal)
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestQueueStatus()
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
    
    
    private func requestSearchSurrounding(location: CLLocationCoordinate2D) {
        
        APIService.share.request(type: QueueSearchResult.self, router: .queueSearch(location: location)) { [weak self] result, _, statusCode in
            switch statusCode {
            case 200:
                if let result {
                    result.fromQueueDB.forEach {
                        self?.addCustomPin(lat: $0.lat, long: $0.long)
                    }
                }
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestSearchSurrounding(location: location)
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




// MARK: - MapView Delegate
extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = customView.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            //없으면 하나 만들어 주시고
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
            annotationView?.canShowCallout = true
            
        } else {
            //있으면 등록된 걸 쓰시면 됩니다.
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = R.image.sesac_face_1()
        
        //상황에 따라 다른 annotationView를 리턴하게 하면 여러가지 모양을 쓸 수도 있겠죠?
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Animated ..")
        /// 맵 변경되면 호출
        /// 여기서 API 요청
        /// 요청 후 맵 업뎃
        viewModel.location.accept(mapView.centerCoordinate)
    }
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
            viewModel.location.accept(coordinate)
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
