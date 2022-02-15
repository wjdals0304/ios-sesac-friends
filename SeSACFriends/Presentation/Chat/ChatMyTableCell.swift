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
    
    let chatLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.getRegularFont(.regular_14)
        label.layer.cornerRadius = 8
        label.layer.backgroundColor = UIColor.getColor(.mychatColor).cgColor
        label.textColor = UIColor.getColor(.defaultTextColor)
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
    
    func configure() {
        [
            chatLabel,
            timeLabel
        ].forEach{ addSubview($0) }
        
        chatLabel.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 111)
            make.trailing.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chatLabel.snp.leading).inset(8)
            make.bottom.equalTo(chatLabel.snp.bottom)
        }
        
    }
    
    
}
 
