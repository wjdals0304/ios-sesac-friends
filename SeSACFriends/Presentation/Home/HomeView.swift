//
//  HomeView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation
import UIKit
import MapKit


class HomeView: BaseUIView {
    
    var arrayButtons : [UIButton] = [UIButton]()
    let mkMapView = MKMapView()

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
        return button
    }()
    
    let manButton : UIButton = {
        let button = UIButton()
        button.setTitle("남자", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let womanButton : UIButton = {
        let button = UIButton()
        button.setTitle("여자", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
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
    
    
    override func setup() {
        [
        mkMapView,
         buttonStackView,
         placeButton,
         searchButton
        ].forEach { addSubview($0) }
        
        self.arrayButtons = [self.entireButton,self.manButton,self.womanButton]
        
        buttonStackView.addArrangedSubview(entireButton)
        buttonStackView.addArrangedSubview(manButton)
        buttonStackView.addArrangedSubview(womanButton)
    }
    
    override func setupConstraint() {
        
           entireButton.isSelected = true
           entireButton.backgroundColor = UIColor.getColor(.activeColor)
           entireButton.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
           
        mkMapView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }
           
           buttonStackView.snp.makeConstraints { make in
               make.top.equalTo(safeAreaLayoutGuide)
               make.leading.equalToSuperview().offset(16)
               make.width.equalTo(self.snp.width).multipliedBy(0.15)
               make.height.equalTo(144)
           }
           
           placeButton.snp.makeConstraints { make in
               make.top.equalTo(buttonStackView.snp.bottom).offset(16)
               make.leading.equalTo(buttonStackView.snp.leading)
               make.width.equalTo(buttonStackView.snp.width)
               make.height.equalTo(buttonStackView.snp.width)
           }
           
           searchButton.snp.makeConstraints { make in
               make.width.equalTo(self.snp.width).multipliedBy(0.17)
               make.trailing.equalToSuperview().inset(16)
               make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
               make.height.equalTo(self.snp.width).multipliedBy(0.17)
           }
    }
    
    
}
