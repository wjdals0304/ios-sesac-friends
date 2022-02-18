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
import Toast_Swift

class HomeViewController: BaseViewController {
    
    var buttonIndex: Int?
    
    let locationManager = CLLocationManager()
    let hobbyViewModel = HobbyViewModel()

    var runTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
    let mTimer : Selector = #selector(Tick_TimeConsole) // 위치 확인 타이머
//    let checkQueueTimer: Selector = #selector(checkQueueState)

    let homeView = HomeView()
    
    override func loadView() {
        self.view = homeView
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeView.searchButton.layer.cornerRadius = homeView.searchButton.frame.size.width / 2
        homeView.searchButton.clipsToBounds = true
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        setup()
        setupConstraint()
        addTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        print(#function)
        checkQueueState()

    }
    

    override func setup(){
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: mTimer, userInfo: nil, repeats: true)

        

        homeView.mkMapView.delegate = self
        locationManager.delegate = self
        
        // 정확도 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 위치 데이터를 추적하기 위해 사용자에게 승인을 요청
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트
        locationManager.startUpdatingLocation()
        // 위치보기값
        homeView.mkMapView.showsUserLocation = true

        // 초기 화면
        setUpGoLation()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(chagneFloatingButtonImage), name: NSNotification.Name("chagneFloatingButtonImage"), object: nil)
        
    }
    
    override func addTarget() {
        homeView.entireButton.addTarget(self, action: #selector(touchStackButtons(_:)), for: .touchUpInside)
        homeView.manButton.addTarget(self, action: #selector(touchStackButtons(_:)), for: .touchUpInside)
        homeView.womanButton.addTarget(self, action: #selector(touchStackButtons(_:)), for: .touchUpInside)
        homeView.placeButton.addTarget(self, action: #selector(touchPlaceButton), for: .touchUpInside)
        homeView.searchButton.addTarget(self, action: #selector(touchSearchButton), for: .touchUpInside)
    }
    
 
}

extension HomeViewController : CLLocationManagerDelegate {
    
    func deleteAnnotation(_ annotation: MKAnnotation) {
        homeView.mkMapView.removeAnnotation(annotation)
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

        homeView.mkMapView.setRegion(pRegion, animated: true)

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
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees , delta span : Double, title strTitle: String , strSubtitle: String, imageName: String,gender: Int ) {
        
        let annotation = CustomPointAnnotation(coordinate: goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span), imageName: imageName)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        annotation.gender = gender
        homeView.mkMapView.addAnnotation(annotation)
        
    }
    
    // MARK: 중앙 고정 핀 설치
    func setCenterAnnotation( latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees , delta span : Double ) {
        
        let centerAnnotation = homeView.mkMapView.annotations.filter{ $0.title == "중앙 고정 핀" }.first
        
        let centerOverlay = homeView.mkMapView.overlays.first

        if centerAnnotation != nil {
            deleteAnnotation(centerAnnotation!)
            homeView.mkMapView.removeOverlay(centerOverlay!)
        }

        let customAnnotation = CustomPointAnnotation(coordinate: goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
         ,imageName: "map_marker")
        
        customAnnotation.title =  "중앙 고정 핀"
        customAnnotation.subtitle = "새싹 찾기 기준 위치"
        
        let circle =  MKCircle(center: customAnnotation.coordinate, radius: 700)
        
        homeView.mkMapView.addOverlay(circle)
        homeView.mkMapView.addAnnotation(customAnnotation)
    
    }

}

extension HomeViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        

        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
                
        var annotationView = homeView.mkMapView.dequeueReusableAnnotationView(withIdentifier: CustomPointAnnotation.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomPointAnnotation.identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let pin = annotation as? CustomPointAnnotation
        annotationView?.image = UIImage(named: pin!.imageName)
        
        if pin?.imageName == "map_marker" {
            annotationView?.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        } else {
            annotationView?.frame = CGRect(x: 0, y: 0, width: 83.33, height: 83.33)
        }

        
        return annotationView
    }
    
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        runTimeInterval = Date().timeIntervalSinceReferenceDate
    }
    
    @objc func Tick_TimeConsole() {
        
        guard let timeInterval = runTimeInterval else { return }
        
        let interval = Date().timeIntervalSinceReferenceDate - timeInterval
        
        if interval < 0.25 { return }
        
        let coordinate = homeView.mkMapView.centerCoordinate
        
        hobbyViewModel.location = Location(
                  region: hobbyViewModel.calculateRegion(lat: coordinate.latitude, long: coordinate.longitude)
                  ,lat: coordinate.latitude, long: coordinate.longitude)
        
        setCenterAnnotation(latitudeValue: hobbyViewModel.location.lat
                            ,longitudeValue: hobbyViewModel.location.long, delta: 0.01)

        postOnqueue(region: hobbyViewModel.location.region
                    ,lat: hobbyViewModel.location.lat, long: hobbyViewModel.location.long)

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
    
    @objc func chagneFloatingButtonImage(_ notification: Notification) {
        let imageValue = notification.object as! String
        
        self.homeView.searchButton.setImage(UIImage(named: imageValue ), for: .normal)
    }
    

    func checkQueueState() {
        
        hobbyViewModel.getMyQueueState { APIStatus, myqueueState in
            
            switch APIStatus {
                
            case .success :
                
                switch myqueueState {
                     
                 case .message :
                    self.homeView.searchButton.setImage(UIImage(named: MyqueueState.message.rawValue ), for: .normal)

                 case .antenna:
                    self.homeView.searchButton.setImage(UIImage(named: MyqueueState.antenna.rawValue ), for: .normal)

                 case .search:
                    self.homeView.searchButton.setImage(UIImage(named: MyqueueState.search.rawValue ), for: .normal)
                default :
                    self.homeView.searchButton.setImage(UIImage(named: MyqueueState.search.rawValue ), for: .normal)
                    
                }
                
            case .stopSearch :
                self.homeView.searchButton.setImage(UIImage(named: MyqueueState.search.rawValue ), for: .normal)
                
            
            case .expiredToken :
                AuthNetwork.getIdToken { error in
                        switch error {
                        case .success :
                            self.checkQueueState()
                        case .failed :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        default :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
                
            default :
                
                self.homeView.searchButton.setImage(UIImage(named: MyqueueState.search.rawValue ), for: .normal)
                
        
            }
        }
        

        
    }

    
    
    
    
    @objc func touchStackButtons(_ sender: UIButton) {
        
       let arrayButtons = homeView.arrayButtons
        
        if buttonIndex != nil {
 
                for index in homeView.arrayButtons.indices {
                    print(index)
                    arrayButtons[index].isSelected = false
                    arrayButtons[index].setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
                    arrayButtons[index].setBackgroundColor(UIColor.getColor(.whiteTextColor), for: .normal)
                sender.isSelected = true
                buttonIndex = homeView.arrayButtons.firstIndex(of: sender)
            }
            
        } else {
            
            _ = homeView.arrayButtons.map {
                $0.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
                $0.setBackgroundColor(UIColor.getColor(.whiteTextColor), for: .normal)
            }
            
            sender.isSelected = true
            buttonIndex = homeView.arrayButtons.firstIndex(of: sender)
        }
        
        if sender.isSelected {
            homeView.arrayButtons[buttonIndex!].setBackgroundColor(UIColor.getColor(.activeColor), for: .selected)
            homeView.arrayButtons[buttonIndex!].setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
            
            let buttonLabel = homeView.arrayButtons[buttonIndex!].titleLabel?.text!
            
            if buttonLabel == "남자" {

                for annotation in homeView.mkMapView.annotations {
                    if let customPointAnnotation = annotation as? CustomPointAnnotation {
                        if customPointAnnotation.gender == Gender.woman.rawValue {
                            homeView.mkMapView.view(for: customPointAnnotation)?.isHidden = true
                        } else {
                            homeView.mkMapView.view(for: customPointAnnotation)?.isHidden = false
                        }
                    }
                }
                
            } else if buttonLabel == "여자" {
                        
                for annotation in homeView.mkMapView.annotations {
                    if let customPointAnnotation = annotation as? CustomPointAnnotation {
                        if customPointAnnotation.gender == Gender.man.rawValue {
                            homeView.mkMapView.view(for: customPointAnnotation)?.isHidden = true
                        } else {
                            homeView.mkMapView.view(for: customPointAnnotation)?.isHidden = false
                        }
                    }
                }
                
            } else {
                
                for annotation in homeView.mkMapView.annotations {
                    if let customPointAnnotation = annotation as? CustomPointAnnotation {
                        homeView.mkMapView.view(for: customPointAnnotation)?.isHidden = false
                        }
                    }
            }
        }
    
    }
    
    @objc func touchPlaceButton() {
        
        guard let currentLocation = locationManager.location else {
            self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            return
        }
        
        homeView.mkMapView.setUserTrackingMode(.follow, animated: true)
        homeView.mkMapView.showsUserLocation = true
        
    }
    
    func postOnqueue(region: Int , lat: Double, long : Double) {
        
        hobbyViewModel.postOnqueue(region: region, lat: lat, long: long) { queue, APIStatus in
            
            switch APIStatus {
                
            case .success :
                
                guard let queue = queue else {
                    self.view.makeToast(APIErrorMessage.failed.rawValue)
                    return
                }
                            
                for queue in queue.fromQueueDB {
                    let sesacImage = self.hobbyViewModel.changeSesacImage(sesac: queue.sesac)
                    self.setAnnotation(latitudeValue: queue.lat, longitudeValue: queue.long, delta: 0.1, title: queue.nick, strSubtitle: queue.nick , imageName : sesacImage ,gender:queue.gender)
                }
                
            case .expiredToken :
                
                AuthNetwork.getIdToken { error in
                        switch error {
                        case .success :
                            self.postOnqueue(region: region, lat: lat, long: long)
                        case .failed :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        default :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
                
            default :
                self.view.makeToast(APIErrorMessage.failed.rawValue)
            }
            
        }
    }
     
    @objc func touchSearchButton() {
        
        if self.hobbyViewModel.queueState.matchedNick != nil  {
        
            if self.hobbyViewModel.queueState.matched == matchedState.matched.rawValue {
                
                if self.hobbyViewModel.queueState.dodged == dodgedState.matched.rawValue {
                       print("채팅방으로~")
                    // TODO: 채팅방으로 이동하게 변경 필요
                    
                    let vc = ChatViewController(queueData: FromQueueDB(uid: self.hobbyViewModel.queueState.matchedUid!, nick: self.hobbyViewModel.queueState.matchedNick!, lat: 0, long: 0, reputation: [], hf: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0))
                    
                    self.navigationController?.pushViewController(vc, animated: true )
                }
                
            } else {
                
                let vc = SesacSearchViewController(location: hobbyViewModel.location)
                self.navigationController?.pushViewController(vc, animated: true )
                
            }
            
        } else {
            
            let vc = HobbyViewController(location: hobbyViewModel.location)
            self.navigationController?.pushViewController(vc, animated: true )
                        
        }
        

        
    }
}



class CustomPointAnnotation: NSObject, MKAnnotation {
    static let identifier = "CustomPointAnnotation"
    
    var coordinate: CLLocationCoordinate2D
    var imageName : String
    var title: String?
    var subtitle: String?
    var gender : Int?
    
    init(coordinate:CLLocationCoordinate2D,imageName : String ){
        self.coordinate = coordinate
        self.imageName = imageName
    }
}
