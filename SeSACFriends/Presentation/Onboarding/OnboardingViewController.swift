//
//  OnboardingViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/24.
//

import Foundation
import UIKit
import SnapKit

class OnboardingViewController : UIViewController {
 
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
    lazy var dataViewControllers : [UIViewController] = {
       return [ OnboardingFirstViewController() , OnboardingSecondViewController() ]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl: UIPageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
        pageControl.backgroundColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor  = .black
           
       return pageControl
    }()
    
    override func viewDidLoad() {
        setup()
        setupConstraint()
    }
    
    func setup() {
        
        [
          pageViewController.view,
          pageControl
        ].forEach{ view.addSubview($0) }
        
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    
    func setupConstraint() {
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        pageViewController.didMove(toParent: self)
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(pageViewController.view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            
        }
        
    
    }
    
}

extension OnboardingViewController : UIPageViewControllerDataSource {


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("before")
        
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        
        if previousIndex < 0 {
            return nil
        }
        
        return dataViewControllers[previousIndex]
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("after")
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        
        return dataViewControllers[nextIndex]
        
    }


}


extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed {
            if let currentViewController = pageViewController.viewControllers?.first as? OnboardingFirstViewController {
                pageControl.currentPage = dataViewControllers.firstIndex(of: currentViewController)!
                
            } else if let currentViewController = pageViewController.viewControllers?.first as? OnboardingSecondViewController {
                pageControl.currentPage = dataViewControllers.firstIndex(of: currentViewController)!
                
            }
        }
    }
}
