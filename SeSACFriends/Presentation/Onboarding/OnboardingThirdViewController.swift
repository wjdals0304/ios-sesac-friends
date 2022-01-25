//
//  OnboardingThirdViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/25.
//

import Foundation
import SnapKit
import UIKit

class OnboardingThirdViewController : UIViewController {
    
    
    
    let textLabel : UILabel = {
       let label = UILabel()
        label.text =  "SeSAC Friends"
        label.font = UIFont.getRegularFont(.regular_24)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.spasing = 1.08
       return label
    }()
    
    let imageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "onboarding_img3")
        return image
    }()
    
    
    override func viewDidLoad() {
        
        setup()
        setupConstraint()
    }
    
    
    func setup() {
        view.backgroundColor = .systemBackground
        [
         textLabel,
         imageView
        ].forEach { view.addSubview($0) }
        
    }
    
    func setupConstraint(){
        
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(116)
            $0.leading.equalTo(109)
        }
        
        imageView.snp.makeConstraints{
            $0.top.equalTo(textLabel.snp.bottom).offset(56)
            $0.leading.equalToSuperview().offset(7)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(view.frame.width - 10)
            $0.height.equalTo(imageView.snp.width)
        }
        
    }
    
    
}
