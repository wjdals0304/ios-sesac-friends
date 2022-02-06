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
    let textLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel.layer.cornerRadius = 3.0
        textLabel.layer.borderWidth = 1.0
        textLabel.layer.borderColor = UIColor.black.cgColor
        textLabel.textColor = .black
    }
    
    
}
