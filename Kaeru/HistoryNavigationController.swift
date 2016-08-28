 //
//  HistoryNavigationController.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/07/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit
 
public class HistoryNavigationController: UINavigationController {
    private var snapShots = [UIImage]()
    
    // MARK: - Interface
    final func showViewer(backgroundView: UIView? = nil) {
        if snapShots.isEmpty {
            return
        }
        
        guard let image = visibleViewController?.snapShotFromWindow() else {
            return
        }
        
        snapShots.append(image)
        let viewController = CollectionViewController(snapShots: snapShots, backgroundView: backgroundView)
        viewController.transitioningDelegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Override For Transition
    override public func pushViewController(viewController: UIViewController, animated: Bool) {
        if let image = visibleViewController?.snapShotFromWindow() {
            snapShots.append(image)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override public func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        snapShots.removeAll()
        return super.popToRootViewControllerAnimated(animated)
    }
    
    override public func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if let index = viewControllers.indexOf(viewController) {
            snapShots.removeToLastIfPossible(from: index)
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    // MARK: - Override For Change ViewController
    override public func setViewControllers(viewControllers: [UIViewController], animated: Bool) {
        snapShots.removeAll()
        snapShots.appendContentsOf(viewControllers.flatMap { $0.snapShotFromWindow() })
        super.setViewControllers(viewControllers, animated: animated)
    }
}

// MARK: - UINavigationBarDelegate
extension HistoryNavigationController: UINavigationBarDelegate {
    public func navigationBar(navigationBar: UINavigationBar, didPopItem item: UINavigationItem) {
        guard let items = navigationBar.items else {
            return
        }
        snapShots.removeToLastIfPossible(from: items.count)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HistoryNavigationController: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(isPresent: true)
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(isPresent: false)
    }
}
 
