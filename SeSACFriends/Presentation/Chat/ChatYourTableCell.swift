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

    let chatTextView: UITextView = {
       let chatView = UITextView()
        chatView.font = UIFont.getRegularFont(.regular_14)
        chatView.layer.cornerRadius = 8
        chatView.layer.borderColor = UIColor.getColor(.grayTextColor).cgColor
        chatView.layer.borderWidth = 1
        chatView.textColor = UIColor.getColor(.defaultTextColor)
        chatView.isEditable = false
        chatView.layer.masksToBounds = false
        return chatView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.grayTextColor)
        label.text = "12:01"
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
    
    func configure(text: String ) {
        
        [
            chatTextView,
            timeLabel
        ].forEach{ addSubview($0) }
        
    
        chatTextView.snp.makeConstraints { make in
//            make.width.equalTo(UIScreen.main.bounds.width - 111)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom).inset(10)
//            make.width.equalTo(150)
//            make.height.equalTo(50)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(chatTextView.snp.trailing).offset(8)
            make.bottom.equalTo(chatTextView.snp.bottom)
        }
        
        let font = chatTextView.font!
        
        let estimatedFrame = text.getEstimatedFrame(with: font)

        
        chatTextView.snp.makeConstraints { make in
            make.width.equalTo(estimatedFrame.width + 10)
        }
        
        
        
        
    }
    
}
