//
//  LoginBirthViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/21.
//

import Foundation
import UIKit
import SnapKit

class LoginBirthViewController : UIViewController {
    
    var age = 0
    
    let birthLabel : UILabel = {
       let label = UILabel()
        label.text = "생년월일을 알려주세요."
        label.font = UIFont.getRegularFont(.regular_20)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
       return label
    }()
    
    var birthViewStack = UIStackView()
    
    let yearView : UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
       return view
    }()
    
    let yearLabel : UILabel = {
        let label = UILabel()
        label.text = "년"
        label.font = UIFont.getRegularFont(.regular_16)
        label.textColor = UIColor.getColor(.defaultTextColor)
        return label
    }()
    
    let yearTextField : UITextField = {
       let textField = UITextField()
       return textField
    }()
    

    let monthView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let monthLabel : UILabel = {
        let label = UILabel()
        label.text = "월"
        label.font = UIFont.getRegularFont(.regular_16)
        label.textColor = UIColor.getColor(.defaultTextColor)
        return label
    }()
    
    let monthTextField : UITextField = {
       let textField = UITextField()
        return textField
    }()
    
    let dayView: UIView = {
       let view = UIView()
       view.backgroundColor = .systemBackground
       return view
    }()

    let dayLabel : UILabel = {
        let label = UILabel()
        label.text = "일"
        label.font = UIFont.getRegularFont(.regular_16)
        label.textColor = UIColor.getColor(.defaultTextColor)
        return label
    }()
    
    let dayTextField : UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    let nextButton : UIButton = {
       let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.backgroundColor = UIColor.getColor(.inactiveColor)
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handelDoneBtn), for: .touchUpInside)
        return button
    }()
    
    let datePicker : UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(onDidChangeDate), for: .valueChanged)
        return datePicker
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraint()
        onDidChangeDate()
    }
    

    override func viewDidLayoutSubviews() {
        
        self.yearTextField.setUnderLine()
        self.monthTextField.setUnderLine()
        self.dayTextField.setUnderLine()
    }
    
    func setup() {
        
        self.birthViewStack = UIStackView(arrangedSubviews: [yearView,monthView,dayView])
        self.birthViewStack.spacing = 5
        self.birthViewStack.axis = .horizontal
        self.birthViewStack.distribution = .fillEqually
        
        [
         birthLabel,
         birthViewStack,
         nextButton,
         datePicker
        ].forEach { self.view.addSubview($0)}
        
        [
         yearLabel,
         yearTextField
        ].forEach { self.yearView.addSubview($0) }

        [
         monthLabel,
         monthTextField
        ].forEach { self.monthView.addSubview($0) }
        
        [
         dayLabel,
         dayTextField
        ].forEach { self.dayView.addSubview($0) }
        
        
        
    }
    
    func setupConstraint() {
        
        birthLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(96)
            $0.top.equalToSuperview().offset(185)
        }
        
        birthViewStack.snp.makeConstraints {
            $0.top.equalTo(birthLabel.snp.bottom).offset(80)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(UIScreen.main.bounds.size.width - 32)
            $0.height.equalTo(48)
        }
    
        
        yearTextField.snp.makeConstraints {
            $0.top.equalTo(yearView.snp.top)
            $0.leading.equalTo(yearView.snp.leading).offset(15)
            $0.trailing.equalTo(yearView.snp.trailing).inset(19)
            $0.bottom.equalToSuperview()
            
        }
        
        yearLabel.snp.makeConstraints{
            $0.trailing.equalTo(yearView.snp.trailing).inset(10)
            $0.top.equalTo(yearView.snp.top).offset(10)
        }
        
        monthTextField.snp.makeConstraints {
            $0.top.equalTo(monthView.snp.top)
            $0.leading.equalTo(monthView.snp.leading).offset(15)
            $0.trailing.equalTo(monthView.snp.trailing).inset(19)
            $0.bottom.equalTo(monthView.snp.bottom)
        }
        
        monthLabel.snp.makeConstraints {
            $0.trailing.equalTo(monthView.snp.trailing).inset(10)
            $0.top.equalTo(monthView.snp.top).offset(10)
            
        }
        
        dayTextField.snp.makeConstraints {
            $0.top.equalTo(dayView.snp.top)
            $0.leading.equalTo(dayView.snp.leading).offset(15)
            $0.trailing.equalTo(dayView.snp.trailing).inset(19)
            $0.bottom.equalTo(dayView.snp.bottom)
        }
        
        dayLabel.snp.makeConstraints {
            $0.trailing.equalTo(dayView.snp.trailing).inset(10)
            $0.top.equalTo(dayView.snp.top).offset(10)
        }
        
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(birthViewStack).offset(72)
            $0.leading.equalTo(birthViewStack.snp.leading)
            $0.trailing.equalTo(birthViewStack.snp.trailing)
            $0.height.equalTo(48)
        }
    
        datePicker.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom).offset(131)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(220)
        }
        
    }
    
    
}

private extension LoginBirthViewController {
    
    
    @objc func onDidChangeDate()  {
                
        let calendar = Calendar.current
        
        let birthDayDate = calendar.dateComponents([.day,.year,.month], from: datePicker.date)

        self.yearTextField.text = String(birthDayDate.year!)
        self.monthTextField.text = String(birthDayDate.month!)
        self.dayTextField.text = String(birthDayDate.day!)
    
        
        let now = calendar.dateComponents([.year ,.month,.day], from: Date())
        
        let ageComponets = calendar.dateComponents([.year], from: birthDayDate,to : now)
        
        
        age = ageComponets.year!
        
        nextButton.setTitleColor(UIColor.getColor(.activeColor), for: .normal)
        
        
    }
    
    
    @objc func handelDoneBtn() {
        
        
        /// 만 17세이상만
        if age < 17 {
            self.view.makeToast("새싹친구는 만 17세 이상만 사용할 수 있습니다.")
        } else {
            print("성공")
            
        }
        
        
        
        
    }
    
    
    
    
}
