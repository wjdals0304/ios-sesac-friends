//
//  SesacBackgroundView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/22.
//

import Foundation
import UIKit
import StoreKit

final class SesacBackgroundView : BaseUIView {
    
    let sesacShopViewModel = SesacShopViewModel()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 165)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SesacBackgroundCollectionViewCell.self, forCellWithReuseIdentifier: SesacBackgroundCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func setup() {
        backgroundColor = .systemBackground
        [
            collectionView
        ].forEach { addSubview($0)}
        
        getShopMyinfo()
        requestProductData()
    }
    
    override func setupConstraint() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
 
private extension SesacBackgroundView {

    func requestProductData() {
        
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: self.sesacShopViewModel.sesacBackgroundProductIdentifiers as Set<String>)
            request.delegate = self
            request.start()
            
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            
        } else {
            print("")
        }
    }
    
    func getShopMyinfo() {
        
        sesacShopViewModel.getShopMyinfo { APIStatus in

            switch APIStatus {
                
            case .success:
                print("success")
 
            case .expiredToken:
                
                AuthNetwork.getIdToken { error in
                    switch error {
                    case .success :
                        self.getShopMyinfo()
                    case .failed :
                        self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                    default :
                        self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
            case .failed :
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)

            default :
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
            }
            
            
        }
        
        
    }
    // 영수증 검증
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        sesacShopViewModel.postShopIos(receipt: receiptString!, product: productIdentifier) { APIStatus in
            
            switch APIStatus {
                
            case .success :
                // 영수증 검증이 끝난 이후 트랜잭션 종료
                SKPaymentQueue.default().finishTransaction(transaction)
                self.getShopMyinfo()
                self.collectionView.reloadData()
            case .failedReceipt :
                print("faildRecepit")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .expiredToken:
                AuthNetwork.getIdToken { error in
                    switch error {
                    case .success :
                        self.receiptValidation(transaction: transaction, productIdentifier: productIdentifier)
                    case .failed :
                         self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                    default :
                         self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
                
            default :
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                
            
            }
        }
    }
}

extension SesacBackgroundView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sesacShopViewModel.sesacBackgroundProductsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacBackgroundCollectionViewCell.identifier, for: indexPath) as? SesacBackgroundCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row == 0 {
            guard let data = self.sesacShopViewModel.sesacBackgroundProductsArray[indexPath.row] as? CustomProduct else {
                return UICollectionViewCell()
            }
            cell.setup(title: data.localizedTitle, price: data.localizedPrice, desc: data.localizedDescription, sesacCollection: self.sesacShopViewModel.sesacCollection, backgroundCollection: self.sesacShopViewModel.backgroundCollection, indexPath: indexPath.row )

        } else {
            guard let data = self.sesacShopViewModel.sesacBackgroundProductsArray[indexPath.row] as? SKProduct else {
                return UICollectionViewCell()
            }
            cell.setup(title: data.localizedTitle, price: data.localizedPrice, desc: data.localizedDescription, sesacCollection: self.sesacShopViewModel.sesacCollection, backgroundCollection: self.sesacShopViewModel.backgroundCollection, indexPath: indexPath.row)
        }
        
        cell.imageView.image = UIImage(named: sesacShopViewModel.setBackground(index: indexPath.row))
        cell.priceButton.addTarget(self, action: #selector(priceButtonClicked(_:)), for: .touchUpInside)

        return cell
    }
    
    @objc func priceButtonClicked(_ sender: UIButton ) {
        
        if sender.tag == 0 {
            return
        }
        
        let product  = self.sesacShopViewModel.sesacBackgroundProductsArray[sender.tag] as! SKProduct
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: .changeBackgroundImage, object: indexPath.row)
    }

}

extension SesacBackgroundView: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // 구매가 승인되면 상품을 사용자에게 전송하고 거래내역(transaction) 을 큐에서 제거
        for transaction in transactions {
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased :
                print("transaction approved product identifier: \(transaction.payment.productIdentifier)")
                self.receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
            case SKPaymentTransactionState.failed:
                print("transaction faild")
                
                if let transactionError = transaction.error as NSError?,
                   let localizedDescription = transaction.error?.localizedDescription ,
                   transactionError.code != SKError.paymentCancelled.rawValue {
                    print("Transaction error : \(localizedDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
                
            }
            
        }
        
    }
    
}

extension SesacBackgroundView: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        let products = response.products
        
        let product = CustomProduct(localizedTitle: "하늘 공원", localizedPrice: "보유", localizedDescription: "새싹들을 많이 마주치는 매력적인 하늘 공원입니다.")
        
        self.sesacShopViewModel.sesacBackgroundProductsArray.append(product)
        
        if products.count > 0 {
        
            for product in products {

                self.sesacShopViewModel.sesacBackgroundProductsArray.append(product)
                
            }
            print(self.sesacShopViewModel.sesacBackgroundProductsArray)
            
        } else {
            print("no product found")
        }
        
    }
    
}
