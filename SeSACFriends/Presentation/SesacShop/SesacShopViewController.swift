//
//  SesacShopViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/22.
//

import Foundation
import UIKit
import Tabman
import Pageboy
import SnapKit

final class SesacShopViewController : TabmanViewController   {
    
    let segmentedControl : UISegmentedControl = {
        let items = ["새싹", "배경"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedClicked), for: .valueChanged)
        return segmentedControl
    }()
    
    let imageUIView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground

        return view
    }()
    
    
    let sesacImageView = SesacImageView()
    let sesacBackgroundView = SesacBackgroundView()
    
    override func viewDidLoad() {
        
        
        setup()
        setupConstraint()
        
        self.contentView.bringSubviewToFront(self.sesacImageView)
    }
    
    
    func setup(){
        
        view.backgroundColor = .systemBackground

        title = "새싹샵"
        self.tabBarController?.tabBar.isHidden = true
        
        
        [
            imageUIView,
            segmentedControl,
            contentView
        ].forEach { view.addSubview($0) }
        
        [
           sesacImageView,
           sesacBackgroundView
        ].forEach{ contentView.addSubview($0) }
        
    }
    
    func setupConstraint() {
        
        imageUIView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(15)
            make.leading.equalToSuperview().offset(14)
            make.width.equalTo(UIScreen.main.bounds.width - 26 )
            make.height.equalTo(175)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(imageUIView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
    }
    
    
  
}


private extension SesacShopViewController {
    
    @objc func segmentedClicked(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0 :
            self.contentView.bringSubviewToFront(sesacImageView)
            break
        case 1:
            self.contentView.bringSubviewToFront(sesacBackgroundView)

            break
        default :
            break
        }
    }
    
    
    
}
