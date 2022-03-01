//
//  SesacImageCollectionViewCell.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/23.
//

import Foundation
import UIKit

final class SesacImageCollectionViewCell : UICollectionViewCell {

    static let identifier = "SesacImageCollectionViewCell"
    
    let imageView : UIImageView = {
        let image = UIImageView()
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 8
        image.layer.borderColor = UIColor.getColor(.grayLineColor).cgColor
        return image
    }()
    
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

    func setup(title: String, price:String, desc:String, sesacCollection: Array<Int>, backgroundCollection: Array<Int>, indexPath: Int ) {
        
        [
         imageView,
         titleLabel,
         priceButton,
         descLabel
        ].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(165)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(11)
            make.trailing.equalToSuperview().inset(9)
            make.width.equalTo(self).multipliedBy(0.3)
            make.height.equalTo(20)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview()
        }
        
        titleLabel.text = title
        descLabel.text = desc

        if sesacCollection.contains(indexPath) {
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
