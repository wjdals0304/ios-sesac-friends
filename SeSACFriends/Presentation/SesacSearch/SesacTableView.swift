//
//  SesacTableViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/11.
//

import Foundation
import UIKit
import SnapKit

class SesacTableView : UIView {
    
    lazy var tableview: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SesacTableViewCell.self, forCellReuseIdentifier: SesacTableViewCell.identifier)
        return tableView
    }()
    
    var queueData : [FromQueueDB]
    
    init(queue : [FromQueueDB] ){
        self.queueData = queue
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        

        setup()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        
    
        [
         tableview
        ].forEach{ addSubview($0) }
            
    }
    
    func setupConstraint() {
        
        tableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
}

extension SesacTableView: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.queueData.count
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacTableViewCell.identifier, for: indexPath) as? SesacTableViewCell else {
            return UITableViewCell()
        }

        let data = queueData[indexPath.row]
        cell.selectionStyle = .none
        cell.setupViews(with: data)
    
        return cell
    
        
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



