//
//  OnboardingFirstViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/24.
//

import Foundation
import UIKit
import SnapKit

class OnboardingFirstViewController : UIViewController {
    
    let textLabel : UILabel = {
       let label = UILabel()
        label.text =  "위치 기반으로 빠르게\n주위 친구를 확인"
        label.font = UIFont.getRegularFont(.regular_24)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.spasing = 1.08
        label.asColor(targetString: "위치 기반", color: UIColor.getColor(.activeColor))
       return label
    }()
    
    let imageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "onboarding_img1")
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
            $0.leading.equalTo(85)
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

