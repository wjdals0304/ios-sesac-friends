//
//  LoginBirthViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/21.
//

import Foundation
import UIKit
import SnapKit
import Toast_Swift

final class SignUpBirthViewController : BaseViewController {
        
    let signUpBirthView = SignUpBirthView()

    override func loadView() {
        self.view = signUpBirthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        signUpBirthView.yearTextField.setUnderLine()
        signUpBirthView.monthTextField.setUnderLine()
        signUpBirthView.dayTextField.setUnderLine()
    }
    
    override func addTarget() {
        signUpBirthView.nextButton.addTarget(self, action: #selector(handelDoneBtn), for: .touchUpInside)
        signUpBirthView.datePicker.addTarget(self, action: #selector(onDidChangeDate), for: .valueChanged)
    }
    
    override func setupNavigationBar() {
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.leftBarButtonItem?.tintColor = .black

    }



    
}

private extension SignUpBirthViewController {
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func onDidChangeDate()  {
                
        let calendar = Calendar.current

        let birthDayDate = calendar.dateComponents([.day,.year,.month], from: signUpBirthView.datePicker.date)

        signUpBirthView.yearTextField.text = String(birthDayDate.year!)
        signUpBirthView.monthTextField.text = String(birthDayDate.month!)
        signUpBirthView.dayTextField.text = String(birthDayDate.day!)
                
        signUpBirthView.nextButton.setBackgroundColor(UIColor.getColor(.activeColor), for: .normal)
        
        
    }
    
    
    @objc func handelDoneBtn() {
        
        
        let calendar = Calendar.current

        let birthDayDate = calendar.dateComponents([.day,.year,.month], from: signUpBirthView.datePicker.date)
        let now = calendar.dateComponents([.year ,.month,.day], from: Date())
        let ageComponets = calendar.dateComponents([.year], from: birthDayDate,to : now)
        let age = ageComponets.year!

        let dateString = signUpBirthView.datePicker.date.dateToString(format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        UserManager.birthday = dateString
        
        /// 만 17세이상만 
        if age < 17 {
            self.view.makeToast("새싹친구는 만 17세 이상만 사용할 수 있습니다.")
        } else {
            
            let vc = SignUpEmailViewController()
            self.navigationController?.pushViewController(vc, animated: true)
                        
        }
        
    
    }
    
    
    
    
}
