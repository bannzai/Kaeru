 //
//  HistoryNavigationController.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/07/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit
 
open class HistoryNavigationController: UINavigationController {
    fileprivate var snapShots = [UIImage]()
    
    // MARK: - Interface
    open override func presentHistory(_ backgroundView: UIView? = nil) {
        if snapShots.isEmpty {
            return
        }
        
        guard let image = visibleViewController?.snapShotFromWindow() else {
            return
        }
        
        snapShots.append(image)
        let viewController = CollectionViewController(snapShots: snapShots, backgroundView: backgroundView)
        viewController.transitioningDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Override For Transition
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let image = visibleViewController?.snapShotFromWindow() {
            snapShots.append(image)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        snapShots.removeAll()
        return super.popToRootViewController(animated: animated)
    }
    
    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if let index = viewControllers.index(of: viewController) {
            snapShots.removeToLastIfPossible(from: index)
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    // MARK: - Override For Change ViewController
    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        snapShots.removeAll()
        snapShots.append(contentsOf: viewControllers.flatMap { $0.snapShotFromWindow() })
        super.setViewControllers(viewControllers, animated: animated)
    }
}

// MARK: - UINavigationBarDelegate
extension HistoryNavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        guard let items = navigationBar.items else {
            return
        }
        snapShots.removeToLastIfPossible(from: items.count)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HistoryNavigationController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(isPresent: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(isPresent: false)
    }
}
 
