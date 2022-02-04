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

class HomeViewController: UIViewController {
    
    var buttonIndex: Int?
    
    let mkMapView = MKMapView()
    let locationManager = CLLocationManager()
    
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
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    
    var arrayButtons : [UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setup()
        setupConstraint()
    }

    func setup(){
        
        self.arrayButtons = [self.entireButton,self.manButton,self.womanButton]
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mkMapView.showsUserLocation = true
        
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
        
        searchButton.layer.cornerRadius = searchButton.frame.size.width / 2
        searchButton.clipsToBounds = true
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
            
            arrayButtons.map {
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
    
    
    
}
