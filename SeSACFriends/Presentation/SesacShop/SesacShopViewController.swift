//
//  SesacShopViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/22.
//

import Foundation
import UIKit
import SnapKit

final class SesacShopViewController: UIViewController {
    
    let sesacShopViewModel = SesacShopViewModel()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["새싹", "배경"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedClicked), for: .valueChanged)
        return segmentedControl
    }()
    
    private let imageUIView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let sesacUIImageView  = UIImageView()
    private let sesacBackgrounImageUIView = UIImageView()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground

        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.textColor = UIColor.getColor(.whiteTextColor)
        button.backgroundColor = UIColor.getColor(.activeColor)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let sesacImageView = SesacImageView()
    let sesacBackgroundView = SesacBackgroundView()
    
    override func viewDidLoad() {
        
        getShopMyinfo()
        setup()
        setupConstraint()
        
        self.contentView.bringSubviewToFront(self.sesacImageView)
    }
    
    func setup() {
        
        view.backgroundColor = .systemBackground

        title = "새싹샵"
        
        [
            imageUIView,
            segmentedControl,
            contentView
        ].forEach { view.addSubview($0) }
        
        [
           sesacImageView,
           sesacBackgroundView
        ].forEach { contentView.addSubview($0) }
        
        [
            sesacUIImageView,
            sesacBackgrounImageUIView,
            saveButton
        ].forEach {  imageUIView.addSubview($0) }
        
        self.imageUIView.bringSubviewToFront(sesacUIImageView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(chagneSesacImage), name: .changeSesacImage, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(chagneBackgroundImage), name: .changeBackgroundImage, object: nil)
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        sesacImageView.snp.makeConstraints { make in 
            make.edges.equalToSuperview()
        }
        
        sesacBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacBackgrounImageUIView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sesacUIImageView.snp.makeConstraints { make in
            make.top.equalTo(sesacBackgrounImageUIView.snp.top).offset(11)
            make.leading.equalTo(sesacBackgrounImageUIView.snp.leading).offset(75)
            make.width.equalTo(sesacBackgrounImageUIView.snp.width).multipliedBy(0.53)
            make.height.equalTo(sesacBackgrounImageUIView.snp.width).multipliedBy(0.53)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
            make.width.equalTo(sesacBackgrounImageUIView.snp.width).multipliedBy(0.22)
        }
    
    }
    
}

private extension SesacShopViewController {
    
    @objc func segmentedClicked(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0 :
            self.contentView.bringSubviewToFront(sesacImageView)
        case 1:
            self.contentView.bringSubviewToFront(sesacBackgroundView)
        default :
            break
        }
    }
    
    func getShopMyinfo() {
        
        sesacShopViewModel.getShopMyinfo { APIStatus in

            switch APIStatus {
                
            case .success:
                
                let sesacImage = self.sesacShopViewModel.setSesacImage(index: self.sesacShopViewModel.sesac)
                let sesacBackgroundImage = self.sesacShopViewModel.setBackground(index: self.sesacShopViewModel.background)
                
                self.sesacUIImageView.image = UIImage(named: sesacImage)
                self.sesacBackgrounImageUIView.image = UIImage(named: sesacBackgroundImage)
                
            case .expiredToken:
                AuthNetwork.getIdToken { error in
                    switch error {
                    case .success :
                           self.getShopMyinfo()
                    case .failed :
                           self.view.makeToast(APIErrorMessage.failed.rawValue)
                    default :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
            case .failed :
                self.view.makeToast(APIErrorMessage.failed.rawValue)
                
            default :
                self.view.makeToast(APIErrorMessage.failed.rawValue)
                
            }
        }
    }
    
    @objc func chagneSesacImage(_ notification: Notification) {
    
        let imageIndex = notification.object as! Int
        
        self.sesacShopViewModel.sesac = imageIndex
        
        let sesacImage = self.sesacShopViewModel.setSesacImage(index: imageIndex)

        self.sesacUIImageView.image = UIImage(named: sesacImage)

    }
    
    @objc func chagneBackgroundImage(_ notification: Notification) {
        
        let imageIndex = notification.object as! Int
        
        self.sesacShopViewModel.background = imageIndex
        
        let sesacBackgroundImage = self.sesacShopViewModel.setBackground(index: imageIndex)

        self.sesacBackgrounImageUIView.image = UIImage(named: sesacBackgroundImage)

    }
    
    @objc func saveButtonClicked() {
        
        sesacShopViewModel.updateShop(sesac: self.sesacShopViewModel.sesac, background: self.sesacShopViewModel.background) { APIStatus in
            
            switch APIStatus {
                
            case .success :
                self.view.makeToast("성공적으로 저장되었습니다.")
            case .unownItem:
                self.view.makeToast("구매가 필요한 아이템이 있어요.")
            case .expiredToken:
                AuthNetwork.getIdToken { error in
                    switch error {
                    case .success :
                           self.getShopMyinfo()
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
}
