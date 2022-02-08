//
//  HobbyViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/06.
//

import Foundation
import UIKit
import SnapKit
import FirebaseAuth
import Toast_Swift

class HobbyViewController : UIViewController  {
    
    private let region : Int
    private let lat : Double
    private let long : Double
    
    let homeViewModel = HomeViewModel()
    
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
    
    var aroundHobbyArray = [String]()
    var fromRecommendArray = [String]()
    
    var myHobbyArray = UserManager.myHobbyArray

    
    init(region: Int, lat: Double ,long: Double) {
        self.region = region
        self.lat = lat
        self.long = long
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupConstraint()
        
        // MARK: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonView), name: UIResponder.keyboardWillHideNotification, object: nil)
        apiPostOnqueue()
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
    
    func apiPostOnqueue() {
        
        homeViewModel.postOnqueue(region: region, lat: lat, long: long) { queue, APIStatus in
            
            switch APIStatus {
                
            case .success :
                
                guard let queue = queue else {
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                    return
                }
                self.aroundHobbyArray += queue.fromQueueDB.flatMap{$0.hf}
                self.aroundHobbyArray += queue.fromQueueDBRequested.flatMap {$0.hf}

                self.aroundHobbyArray = Array(Set(self.aroundHobbyArray))
                
                self.fromRecommendArray = queue.fromRecommend

                for i in self.aroundHobbyArray {
                    if self.fromRecommendArray.contains(i) {
                        self.aroundHobbyArray.removeAll(where: { $0 == i} )
                    }
                }

                self.aroundHobbyArray = self.fromRecommendArray + self.aroundHobbyArray
                                
            case .expiredToken :
                let currentUser = FirebaseAuth.Auth.auth().currentUser
                currentUser?.getIDToken(completion: { idtoken, error in
                guard let idtoken = idtoken else {
                        print(error!)
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                        return
                 }
                 UserManager.idtoken = idtoken
                })
                self.apiPostOnqueue()
                
                
            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            }
        }
        
        
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
        print(searchText)
        print(#function)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBarText = searchBar.text else {
            return
        }
        
        print(searchBarText)
        UserManager.myHobbyArray.append(searchBarText)
        
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)

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

extension HobbyViewController: UITableViewDataSource,UITableViewDelegate   {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        aroundHobbyArray = ["테스트","테스트2"]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HobbyTableViewCell.identifier, for: indexPath) as! HobbyTableViewCell
        
        let hobbyType = sections[indexPath.section] == "지금 주변에는" ? "arround" : "myHobby"
        
        if indexPath.section == 0 {
            cell.configure(from: fromRecommendArray, arroundArray: aroundHobbyArray, hobbyArray: aroundHobbyArray, hobbyType: hobbyType )
        } else {
            cell.myHobbyConfigure(myHobbyArray: myHobbyArray, hobbyType: hobbyType)
        }
    
        cell.selectionStyle = .none
        cell.cellDelegate  = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
  
}


extension HobbyViewController : CollectionViewCellDelegate {
    
    func collectionView(collectionviewcell: HobbyCollectionViewCell?, index: Int, didTappedInTableViewCell: HobbyTableViewCell) {
        
        
    }
}
 
