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
    
    private var timer: Timer?
    
    
    
    
    // MARK: - Life Cycle
    private let customView = HomeView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetBarUI()
        checkUserDeviceLocationServiceAuthorization()
        requestQueueStatus()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setDelegate()
        bind()
        
        navigationController?.navigationBar.isHidden = true
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
                switch vc.viewModel.matchStatus.value {
                case .normal:
                    let enterStudyVC = EnterStudyViewController()
                    enterStudyVC.location = vc.viewModel.location.value
                    vc.transition(enterStudyVC, transitionStyle: .push)
                case .waitingMatch:
                    vc.transition(FindingSeSacTabmanViewController(), transitionStyle: .push)
                case .matched: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    private func resetBarUI() {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    
    private func addCustomPin(imageNum: Int, location: CLLocationCoordinate2D) {
        let pin = CustomAnnotation(imageNum: imageNum, location: location)
        customView.mapView.addAnnotation(pin)
    }
    
    
    private func removeAllAnnotation() {
        let allAnnotations = customView.mapView.annotations
        customView.mapView.removeAnnotations(allAnnotations)
    }
    
    
    @objc private func timerAction() {
        customView.mapView.isUserInteractionEnabled = true
        timer = nil
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
                    self?.removeAllAnnotation()
                    
                    result.fromQueueDB.forEach {
                        self?.addCustomPin(imageNum: $0.sesac, location: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long))
                    }
                    
                    DataStorage.shared.updateSearchResult(info: result)
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
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        var annotationView = customView.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
            
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage = UIImage(named: "sesac_face_\(annotation.imageNum + 1)")
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)
        
        sesacImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        viewModel.location.accept(mapView.centerCoordinate)
        
        mapView.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
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
            customView.mapView.setRegion(MKCoordinateRegion(center: viewModel.sesacLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            
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
            customView.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "사용자 위치를 가져오는데 실패했습니다.")
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}
