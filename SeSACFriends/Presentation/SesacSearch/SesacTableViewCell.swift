//
//  SesacTableViewCell.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/11.
//

import Foundation
import UIKit
import SnapKit

class SesacTableViewCell : UITableViewCell {
    
    static let identifier = "SesacTableViewCell"

    let requestButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        return button
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
    
    func setupViews(with data: FromQueueDB , type:String) {
        
        let user = User(id: "", v: 0, uid: data.uid, phoneNumber: "", email: "", fcMtoken: "", nick: data.nick, birth: "", gender: data.gender, hobby: "", comment: [], reputation: data.reputation, sesac: 0, sesacCollection: [], background: 0, backgroundCollection: [], purchaseToken: [], transactionID: [], reviewedBefore: [], reportedNum: 0, reportedUser: [], dodgepenalty: 0, dodgeNum: 0, ageMin: 23, ageMax: 30, searchable: 1, createdAt: "")
        
        let profileView = ProfileView(profileImage: "default_profile_img", userData: user, profileHeight: 252)
        let profileMainView = profileView.getProfileMainView()

        if let recognizers = profileMainView.gestureRecognizers {
            for recognizer in recognizers {
                profileMainView.removeGestureRecognizer(recognizer)
            }
        }
        
        if type == QueueType.fromQueueDB.rawValue {
            self.requestButton.setTitle("요청하기", for: .normal)
            self.requestButton.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
            self.requestButton.titleLabel?.font = UIFont.getRegularFont(.regular_14)
            self.requestButton.backgroundColor = UIColor.getColor(.redColor)
        } else {
            self.requestButton.setTitle("수락하기", for: .normal)
            self.requestButton.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
            self.requestButton.titleLabel?.font = UIFont.getRegularFont(.regular_14)
            self.requestButton.backgroundColor = UIColor.getColor(.blueColor)
        }
        
        
        [
          profileView,
          requestButton
        ].forEach { addSubview($0) }
        
        
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.top).offset(12)
            make.trailing.equalTo(profileView.snp.trailing).inset(12)
            make.width.equalTo(profileView.snp.width).multipliedBy(0.23)
            make.height.equalTo(40)
        }


        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(252).priority(999)
        }
        
    }
    

    

}
