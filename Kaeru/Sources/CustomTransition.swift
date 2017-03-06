//
//  CustomTransition.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/08/10.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var isPresent: Bool = false
    fileprivate let imageViewTag = 10000
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
    
    init(isPresent: Bool) {
        self.isPresent = isPresent
    }
    
    final func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    final func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let transition = isPresent ? show : hide
        self.transitionContext = transitionContext
        transition(transitionContext)
    }
    
    fileprivate func extractContextInfoFrom(_ transitionContext: UIViewControllerContextTransitioning) -> (containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController)? {
        
        
        guard
            let containerView = Optional(transitionContext.containerView),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else  {
                return nil
        }
        
        return (containerView, fromViewController, toViewController)
    }
    
    fileprivate func show(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let (containerView, fromViewController, toViewController) = extractContextInfoFrom(transitionContext) else {
            return
        }
        
        guard let collectionViewController = toViewController as? CollectionViewController else {
            return
        }
        
        do { // prepare for transition
            containerView.addSubview(collectionViewController.view)
            containerView.addSubview(fromViewController.view)
            
            fromViewController.view.frame = containerView.frame
            collectionViewController.view.frame = containerView.bounds
            
            collectionViewController.viewWillAppear(false)
        }
        
        do { // setup collection view layout
            collectionViewController.collectionView.layout.isTransitioning = true
            collectionViewController.collectionView.layout.reset()
            collectionViewController.setContentOffsetRight()
            collectionViewController.collectionView.reloadData()
            collectionViewController.collectionView.layoutIfNeeded()
            collectionViewController.collectionView.layout.isTransitioning = false
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: {
            fromViewController.view.isHidden = true
            self.appearAnimation(collectionViewController)
        }) { finished in
            fromViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.isHidden = true
            fromViewController.view.removeFromSuperview()
            collectionViewController.collectionView.reloadData()
            transitionContext.completeTransition(true)
        }
    }
    
    fileprivate func appearAnimation(_ collectionViewController: CollectionViewController) {
        let collectionView = collectionViewController.collectionView
        collectionViewController.collectionView.layout.attributesList.enumerated().forEach { index, attributes in
            guard let cell = collectionView.cellForItem(at: attributes.indexPath) else {
                fatalError()
            }
            
            do { // configure appearing cells animation
                let layout = collectionViewController.collectionView.layout
                
                let scaleX = attributes.transform.a * 0.8
                let scaleY = attributes.transform.d * 0.8
                let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
                
                let startAttributes = layout.startAttributesList[index]
                let translateX = ceil(attributes.center.x + attributes.transform.tx - startAttributes.center.x)
                let translateY = ceil(attributes.center.y - attributes.transform.ty - startAttributes.center.y)
                
                let translate = CGAffineTransform(translationX: translateX, y: translateY)
                let concat = scale.concatenating(translate)
                let transform = CATransform3DMakeAffineTransform(concat)
                
                cell.layer.setValue(
                    NSValue(caTransform3D: transform)
                    , forKey: "transform"
                )
            }
        }
    }
    
    fileprivate func hide(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let (containerView, fromViewController, toViewController) = extractContextInfoFrom(transitionContext) else {
            return
        }
        
        guard let collectionViewController = fromViewController as? CollectionViewController else {
            return
        }
        
        guard let navigationController = toViewController as? UINavigationController else {
            return
        }
        
        guard let selectedIndexPath = collectionViewController.collectionView.layout.selectedIndexPath else {
            return
        }
        
        do { // prepare for transition
            containerView.addSubview(toViewController.view)
            containerView.addSubview(fromViewController.view)
            
            toViewController.view.isHidden = true
            toViewController.view.frame = containerView.bounds
            
            collectionViewController.view.frame = containerView.bounds
            collectionViewController.collectionView.transform = CGAffineTransform.identity
        }
        
        do {
            let viewController = navigationController.viewControllers[(selectedIndexPath as NSIndexPath).item]
            navigationController.popToViewController(viewController, animated: false)
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: {
            collectionViewController.collectionView.layout.attributesList.forEach { attributes in
                guard (selectedIndexPath as NSIndexPath).item == (attributes.indexPath as NSIndexPath).item else {
                    return
                }
                
                guard let cell = collectionViewController.collectionView.cellForItem(at: attributes.indexPath) else {
                    return
                }
                
                attributes.zIndex = collectionViewController.collectionView.layout.attributesList.count
                collectionViewController.collectionView.bringSubview(toFront: cell)
            }
            
            let scale = 1 / CustomLayout.adjustCellSize
            collectionViewController.collectionView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { finished in
            toViewController.view.isHidden = false
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
