//
//  HomeViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/26.
//

import Foundation
import UIKit
import MapKit
import SnapKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    var buttonIndex: Int?
    
    let mkMapView = MKMapView()
    let locationManager = CLLocationManager()
    let homeViewModel = HomeViewModel()
    
    var arrayButtons : [UIButton] = [UIButton]()
    
    var runTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
    let mTimer : Selector = #selector(Tick_TimeConsole) // 위치 확인 타이머
    
    let buttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 8
        stackView.clipsToBounds = true
        return stackView
    }()
    
    let entireButton : UIButton = {
        let button = UIButton()
        button.setTitle("전체", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(touchStackButtons(_:)), for: .touchUpInside)
        return button
    }()
    
    let manButton : UIButton = {
        let button = UIButton()
        button.setTitle("남자", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(touchStackButtons(_:)), for: .touchUpInside)
        return button
    }()
    
    let womanButton : UIButton = {
        let button = UIButton()
        button.setTitle("여자", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        button.addTarget(self, action: #selector(touchStackButtons(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()

    let placeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "place"), for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(touchPlaceButton), for: .touchUpInside)
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchButton.layer.cornerRadius = searchButton.frame.size.width / 2
        searchButton.clipsToBounds = true
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        setup()
        setupConstraint()
    }

    func setup(){
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: mTimer, userInfo: nil, repeats: true)
        
        self.arrayButtons = [self.entireButton,self.manButton,self.womanButton]
        
        mkMapView.delegate = self
        locationManager.delegate = self
        
        // 정확도 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 위치 데이터를 추적하기 위해 사용자에게 승인을 요청
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트
        locationManager.startUpdatingLocation()
        // 위치보기값
        mkMapView.showsUserLocation = true

        // 초기 화면
        setUpGoLation()
        
        
        [
         mkMapView,
         buttonStackView,
         placeButton,
         searchButton
        ].forEach { view.addSubview($0) }
        
        buttonStackView.addArrangedSubview(entireButton)
        buttonStackView.addArrangedSubview(manButton)
        buttonStackView.addArrangedSubview(womanButton)
    }
    
    func setupConstraint(){
        
     
        entireButton.isSelected = true
        entireButton.backgroundColor = UIColor.getColor(.activeColor)
        entireButton.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        
        
        mkMapView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.15)
            make.height.equalTo(144)
        }
        
        placeButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(16)
            make.leading.equalTo(buttonStackView.snp.leading)
            make.width.equalTo(buttonStackView.snp.width)
            make.height.equalTo(buttonStackView.snp.width)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(self.view.snp.width).multipliedBy(0.17)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(self.view.snp.width).multipliedBy(0.17)
        }
    }
    
}

extension HomeViewController : CLLocationManagerDelegate {
    
    func deleteAnnotation(_ annotation: MKAnnotation) {
            mkMapView.removeAnnotation(annotation)
    }
    
    func setUpGoLation( ) {
    
        guard let currentLocation = locationManager.location else {
            self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            return
        }
        
        let coordinate = currentLocation.coordinate
        
        let lat = coordinate.latitude
        let long = coordinate.longitude
        
        let pLocation = CLLocationCoordinate2DMake(lat, long)
        
        let spanValue = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)

       mkMapView.setRegion(pRegion, animated: true)

    }
    
    
    // MARK: 위도 경도로 원하는 위치 표시
    func goLocation(latitudeValue : CLLocationDegrees , longitudeValue: CLLocationDegrees , delta span: Double) -> CLLocationCoordinate2D {
            
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        
        return pLocation
    }
    
    // MARK: 지도에 위치를 나태나기 위해 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last

        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
    }
    
    
    // MARK: 원하는 위치 핀 설치하기
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees , delta span : Double, title strTitle: String , strSubtitle: String) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        
        mkMapView.addAnnotation(annotation)
        
    }
    
    // MARK: 중앙 고정 핀 설치
    func setCenterAnnotation( latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees , delta span : Double ) {
        
        let centerAnnotation = mkMapView.annotations.filter{ $0.title == "중앙 고정 핀" }.first
        
        let centerOverlay = mkMapView.overlays.first

        if centerAnnotation != nil {
            deleteAnnotation(centerAnnotation!)
            mkMapView.removeOverlay(centerOverlay!)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = "중앙 고정 핀"
        annotation.subtitle = "새싹 찾기 기준 위치"
        
        let circle =  MKCircle(center: annotation.coordinate, radius: 700)
        
        mkMapView.addOverlay(circle)
        mkMapView.addAnnotation(annotation)
    
    }

}

extension HomeViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView = self.mkMapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "map_marker")
        
        return annotationView
    }
    
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        runTimeInterval = Date().timeIntervalSinceReferenceDate
    }
    
    @objc func Tick_TimeConsole() {
        
        guard let timeInterval = runTimeInterval else { return }
        
        let interval = Date().timeIntervalSinceReferenceDate - timeInterval
        
        if interval < 0.25 { return }
        
        let coordinate = mkMapView.centerCoordinate
        
        let lat = coordinate.latitude
        let long = coordinate.longitude
   

        let region = calculateRegion(lat: lat, long: long)
        setCenterAnnotation(latitudeValue: lat, longitudeValue: long, delta: 0.01)

        postOnqueue(region: region, lat: lat, long: long)

        runTimeInterval = nil
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = .white
        circleRenderer.fillColor = UIColor.gray.withAlphaComponent(0.3)
        circleRenderer.lineWidth = 1.0
        
        return circleRenderer
    }
    
}


private extension HomeViewController {
    
    @objc func touchStackButtons(_ sender: UIButton) {
        
        if buttonIndex != nil {
            
            if !sender.isSelected {
                for index in arrayButtons.indices {
                    arrayButtons[index].isSelected = false
                    arrayButtons[index].setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
                    arrayButtons[index].setBackgroundColor(UIColor.getColor(.whiteTextColor), for: .normal)
                }
                
                sender.isSelected = true
                buttonIndex = arrayButtons.firstIndex(of: sender)
            }
        } else {
            _ = arrayButtons.map {
                $0.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
                $0.setBackgroundColor(UIColor.getColor(.whiteTextColor), for: .normal)
            }
            
            sender.isSelected = true
            buttonIndex = arrayButtons.firstIndex(of: sender)
        }
        
        if sender.isSelected {
            arrayButtons[buttonIndex!].setBackgroundColor(UIColor.getColor(.activeColor), for: .selected)
            arrayButtons[buttonIndex!].setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        }
    
    }
    
    @objc func touchPlaceButton() {
        
        guard let currentLocation = locationManager.location else {
            self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            return
        }
        
        mkMapView.showsUserLocation = true
        mkMapView.setUserTrackingMode(.follow, animated: true)
        
    }
    
    func postOnqueue(region: Int , lat: Double, long : Double) {
        
        homeViewModel.postOnqueue(region: region, lat: lat, long: long) { queue, APIStatus in
            
            switch APIStatus {
                
            case .success :
                
                guard let queue = queue else {
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                    return
                }
                print(queue)
                
            
            case .expiredToken :
                let currentUser = FirebaseAuth.Auth.auth().currentUser
                currentUser?.getIDToken(completion: { idtoken, error in
                guard let idtoken = idtoken else {
                        print(error!)
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                        return
                 }
                
                 UserManager.idtoken = idtoken
                })
                self.postOnqueue(region: region, lat: lat, long: long)
                
                
            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")

                
            }
            
        }
    }
    
    
    func calculateRegion(lat: Double, long: Double) -> Int {
        
        let calLat = String(lat + 90).replacingOccurrences(of: ".", with: "").substring(to:5)
        let calLong = String(long + 180).replacingOccurrences(of: ".", with: "").substring(to:5)
        
        return Int(calLat + calLong)!
    }
    
    
    
    
}
