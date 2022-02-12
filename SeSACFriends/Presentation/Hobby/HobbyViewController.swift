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
    let hobbyViewModel = HobbyViewModel()
    
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
        button.addTarget(self, action: #selector(sesacSearchButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let sections:[String] = ["지금 주변에는","내가 하고 싶은"]
    
    var hobbyArray : HobbyModel!
    
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


    override func viewDidLoad() {
        super.viewDidLoad()
        apiPostOnqueue()
        setup()
        setupConstraint()
        
        // MARK: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
            make.height.equalTo(400)
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

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
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
                self.hobbyArray = HobbyModel(objectsArray: [TableViewCellModel(category: "지금 주변에는", texts: []) , TableViewCellModel(category: "내가 하고 싶은", texts: [])])
                
                for hobby in self.aroundHobbyArray {
                    self.hobbyArray.objectsArray[HobbyCategory.arroundHobby.rawValue].texts.append(CollectionViewCellModel(name: hobby, subcategory: HobbyCategory.arroundHobby.rawValue))
                }
                
                for hobby in UserManager.myHobbyArray {
                    print("function")
                    self.hobbyArray.objectsArray[HobbyCategory.myHobby.rawValue].texts.append(CollectionViewCellModel(name: hobby, subcategory: HobbyCategory.myHobby.rawValue))
                }
                
                dispatchGroup.leave()
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
                dispatchGroup.leave()

                
            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main){
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(HobbyTableViewCell.self, forCellReuseIdentifier: HobbyTableViewCell.identifier)
            self.tableView.reloadData()
        }
        

    }
    
 
}


extension HobbyViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBarText = searchBar.text else {
            return
        }
        
        if UserManager.myHobbyArray.count > 8 {
            self.view.makeToast("취미를 더 이상 추가할 수 없습니다.")
        }
        
        UserManager.myHobbyArray.append(searchBarText)
        
        self.hobbyArray.objectsArray[HobbyCategory.myHobby.rawValue].texts.append(CollectionViewCellModel(name: searchBarText, subcategory: HobbyCategory.myHobby.rawValue))
        
        self.tableView.reloadData()

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
            sesacSearchButton.layer.cornerRadius = 8
            
            viewButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.bottom.equalToSuperview().inset(50)
                make.width.equalTo(view.frame.width - 32)
                make.height.equalTo(48)
            }
        }
    }
    
    
    @objc func sesacSearchButtonClicked() {
        
        hobbyViewModel.postQueue(region: self.region, lat: self.lat, long: self.long) { APIStatus in
            
            switch APIStatus {
                
            case .success :
                print("성공")
                let vc = SesacSearchViewController(region: self.region, lat: self.lat, long: self.long)
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .reportThreeUser :
                self.view.makeToast("신고가 누적되어 이용하실 수 없습니다.")
            case .penaltyone :
                self.view.makeToast("약속 취소 패널티로, 1분동안 이용하실 수 없습니다.")
            case .penaltytwo :
                self.view.makeToast("약속 취소 패널티로, 2분동안 이용하실 수 없습니다.")
            case .penaltyThree :
                self.view.makeToast("약속 취소 패널티로, 3분동안 이용하실 수 없습니다.")
            case .noGender :
                self.view.makeToast("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!")
            
            case .expiredToken:
                let currentUser = FirebaseAuth.Auth.auth().currentUser
                currentUser?.getIDToken(completion: { idtoken, error in
                guard let idtoken = idtoken else {
                        print(error!)
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                        return
                 }
                 UserManager.idtoken = idtoken
                })
                self.sesacSearchButtonClicked()
                
            case .clientError , .serverError , .failed:
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")

            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")

            }
        }
    }
    
    
    
    
}

extension HobbyViewController: UITableViewDataSource,UITableViewDelegate   {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: HobbyTableViewCell.identifier, for: indexPath) as! HobbyTableViewCell
        let rowArray = hobbyArray.objectsArray[indexPath.section].texts
        
        cell.updateCellWith(row: rowArray,fromRecommendArray: self.fromRecommendArray)
        
        cell.selectionStyle = .none
        cell.cellDelegate  = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return hobbyArray.objectsArray[section].category
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hobbyArray.objectsArray.count
    }
    
  
}


extension HobbyViewController : CollectionViewCellDelegate {
    
    func collectionView(collectionviewcell: HobbyCollectionViewCell?, index: Int, didTappedInTableViewCell: HobbyTableViewCell) {

    }
    
    
    // MARK: 지금 주변에는 -> 내가 하고 싶은 이동
    func changeHobby(addCollectionViewModel: CollectionViewCellModel, addCategory: Int, delCollectionViewModel: CollectionViewCellModel, delCategory: Int) {
        
        UserManager.myHobbyArray.append(addCollectionViewModel.name)
        
        self.hobbyArray.objectsArray[addCategory].texts.removeAll()
            
        for hobby in UserManager.myHobbyArray {
            self.hobbyArray.objectsArray[addCategory].texts.append(CollectionViewCellModel(name: hobby, subcategory: 1))
        }

        self.tableView.reloadData()

    }
    
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func showCountToast() {
        self.view.makeToast("취미를 더 이상 추가할 수 없습니다.")
    }
    
    func showContainToast() {
        self.view.makeToast("이미 등록된 취미입니다.")
    }
    
    
}
 
