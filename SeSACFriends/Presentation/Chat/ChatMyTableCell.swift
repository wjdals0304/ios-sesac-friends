//
//  ChatMyTableCell.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/14.
//

import Foundation
import UIKit
import SnapKit

class ChatMyTableCell: UITableViewCell {
    
    static let identifier = "ChatMyTableCell"
    
    let chatTextView: UITextView = {
       let chatView = UITextView()
        chatView.font = UIFont.getRegularFont(.regular_14)
        chatView.layer.cornerRadius = 8
        chatView.backgroundColor = UIColor.getColor(.mychatColor)
        chatView.textColor = UIColor.getColor(.defaultTextColor)
        chatView.isEditable = false
        chatView.layer.masksToBounds = false
        return chatView
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
    
    func configure(text: String , date : String ) {
        
        [
            chatTextView,
            timeLabel
        ].forEach{ addSubview($0) }
    
        chatTextView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom).inset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chatTextView.snp.leading)
            make.bottom.equalTo(chatTextView.snp.bottom)
        }
        
        
        let date = date.toDate()!
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        timeLabel.text = "\(hour):\(minute)"
        
        let font = chatTextView.font!
        let estimatedFrame = text.getEstimatedFrame(with: font)
        print("====")
        print(text)
        print(estimatedFrame)

        
        chatTextView.snp.makeConstraints { make in
            make.width.equalTo(estimatedFrame.width + 20)
        }
        
    }
    
    
}
 
