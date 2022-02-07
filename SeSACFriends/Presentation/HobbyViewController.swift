//
//  HobbyViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/06.
//

import Foundation
import UIKit
import SnapKit


class HobbyViewController : UIViewController {
      
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var backBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        return barButtonItem
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HobbyTableViewCell.self, forCellReuseIdentifier: HobbyTableViewCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let viewButton : UIView = {
        let view = UIView()
        return view
    }()

    let sesacSearchButton : UIButton = {
        let button = UIButton()
        button.setTitle("새싹 찾기", for: .normal)
        button.titleLabel?.tintColor = UIColor.getColor(.whiteTextColor)
        button.backgroundColor = UIColor.getColor(.activeColor)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let sections:[String] = ["지금 주변에는","내가 하고 싶은"]
    
    var aroundHobbyArray = ["아무거나","SeSAC","코딩","맛집탐방","공원산책","독서모임"
             ,"다육이","쓰레기줍기"]
    var myHobbyArray = ["코딩","클라이밍", "달리기","오일파스텔","축구","배드민턴","테니스"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
        setupConstraint()
        
        // MARK: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBG))
        tap.isEnabled = true
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setup() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = backBarButton
        
        navigationItem.leftBarButtonItem?.tintColor = .black
    
        [
         tableView,
         viewButton
        ].forEach {  view.addSubview($0) }
        
        [
            sesacSearchButton
        ].forEach { viewButton.addSubview($0) }
    }
    
    func setupConstraint() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(view.frame.width - 32)
            make.height.equalTo(324)
        }
        
        
        viewButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(view.frame.width - 32)
            make.height.equalTo(48)
        }
        
        sesacSearchButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
 
    @objc func tapBG(_ sender: Any) {
        print("tapBG")
        self.view.endEditing(true)
    }
}


extension HobbyViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}

private extension HobbyViewController  {
  
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
   
     
    @objc private func adjustButtonView(noti: Notification) {
        
        guard let userInfo = noti.userInfo else { return }
        
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom + 40
            
            viewButton.snp.removeConstraints()
            sesacSearchButton.layer.cornerRadius = 0

            viewButton.snp.makeConstraints { make in
                make.width.equalTo(self.view.snp.width)
                make.bottom.equalToSuperview().inset(adjustmentHeight)
                make.height.equalTo(48)
            }
           
            
        } else {
            viewButton.snp.removeConstraints()
            

            viewButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.bottom.equalToSuperview().inset(50)
                make.width.equalTo(view.frame.width - 32)
                make.height.equalTo(48)
            }
        }
    }
    
    
    
    
}

extension HobbyViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HobbyTableViewCell.identifier, for: indexPath) as! HobbyTableViewCell
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.configure(around: aroundHobbyArray, my: myHobbyArray,hobbyArray: aroundHobbyArray)
        } else {
            cell.configure(around: aroundHobbyArray, my: myHobbyArray,hobbyArray: myHobbyArray)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
  
  
}
