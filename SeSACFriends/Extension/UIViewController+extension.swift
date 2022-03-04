//
//  UIViewController+extension.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation
import UIKit


extension UIViewController {
    
    func moveView(isNavigation: Bool, controller: UIViewController) {
        
        guard let window = self.view.window else {
            return
        }
        
        UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            if isNavigation {
                self.view.window?.rootViewController = UINavigationController(rootViewController: controller)
            } else {
              self.view.window?.rootViewController = controller
            }
            self.view.window?.makeKeyAndVisible()
        }, completion: nil)
    
    
    }
    
}
