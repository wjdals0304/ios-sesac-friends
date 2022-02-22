//
//  ChatYourTableCell.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/14.
//

import Foundation
import UIKit
import SnapKit

class ChatYourTableCell : UITableViewCell {
    
    static let identifier = "ChatYourTableCell"

    let chatImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.getColor(.grayTextColor).cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let chatTextLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.font = UIFont.getRegularFont(.regular_14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.grayTextColor)
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(text: String ,date: String) {
        
        [
            chatImageView,
            chatTextLabel,
            timeLabel,
        ].forEach{ addSubview($0) }
        
        
        let date = date.toDate()!
    
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        timeLabel.text = "\(hour):\(minute)"
        chatTextLabel.text = "\(text)"
    
        
        chatImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.right.greaterThanOrEqualToSuperview().inset(350)
            make.width.lessThanOrEqualTo(250)
        }
        
        chatTextLabel.snp.makeConstraints { make in
            make.edges.equalTo(chatImageView)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(chatImageView.snp.trailing).offset(8)
            make.bottom.equalTo(chatImageView.snp.bottom)
        }
        
    }
    
}
