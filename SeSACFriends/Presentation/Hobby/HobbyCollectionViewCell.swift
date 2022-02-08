//
//  HobbyCollectionView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/06.
//

import Foundation
import UIKit

class HobbyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HobbyCollectionViewCell"
    
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_12)
        label.textColor = UIColor.getColor(.defaultTextColor)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with text: String , from fromRecommendArray : Array<String>) {
        
        [
         textLabel
        ].forEach { addSubview($0) }
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        if fromRecommendArray.contains( text ) {
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 8
            self.layer.borderColor = UIColor.getColor(.redColor).cgColor
            textLabel.text = text
            textLabel.textColor = UIColor.getColor(.redColor)
            
        } else {
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 8
            self.layer.borderColor = UIColor.getColor(.defaultTextColor).cgColor
            textLabel.text = text
            textLabel.textColor = UIColor.getColor(.defaultTextColor)
        }
   

    }
    
    func setupMyHobby(with text : String) {
        [
         textLabel
        ].forEach { addSubview($0) }
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.getColor(.activeColor).cgColor
        textLabel.textColor = UIColor.getColor(.activeColor)
        
        textLabel.addTrailing(image: UIImage(named: "close_small") ?? UIImage(), with: text)
    }
    
        
}
