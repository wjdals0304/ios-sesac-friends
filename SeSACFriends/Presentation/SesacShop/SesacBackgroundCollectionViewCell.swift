//
//  SesacBackgroundCollectionViewCell.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/24.
//

import Foundation
import UIKit
import SnapKit

final class SesacBackgroundCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "SesacBackgroundCollectionViewCell"
    
    let imageView = UIImageView()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_16)
        label.textColor = UIColor.getColor(.defaultTextColor)
        return label
    }()
    
    let priceButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_14)
        label.numberOfLines = 0
        label.textColor = UIColor.getColor(.defaultTextColor)
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(title: String,price:String,desc:String,sesacCollection : Array<Int> , backgroundCollection : Array<Int> , indexPath : Int ) {
        
        
        [
         imageView,
         titleLabel,
         priceButton,
         descLabel
        ].forEach{ addSubview($0)}
        
        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.height.equalTo(165)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(63)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.width.equalTo(165)
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().inset(17)
//            make.bottom.equalTo(descLabel.snp.top).inset(10)
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
        
        titleLabel.text = title
        descLabel.text = desc
        
        if backgroundCollection.contains(indexPath){
            priceButton.setTitle("보유", for: .normal)
            priceButton.setTitleColor(UIColor.getColor(.grayTextColor), for: .normal)
            priceButton.setBackgroundColor(UIColor.getColor(.grayLineColor), for: .normal)
        } else {
            priceButton.setTitle(price, for: .normal)
            priceButton.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
            priceButton.setBackgroundColor(UIColor.getColor(.activeColor), for: .normal)
            
        }
        
        
        
    
    }
}
