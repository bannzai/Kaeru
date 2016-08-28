//
//  CustomTransition.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/08/10.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var isPresent: Bool = false
    private let imageViewTag = 10000
    private var transitionContext: UIViewControllerContextTransitioning?
    
    init(isPresent: Bool) {
        self.isPresent = isPresent
    }
    
    final func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }

    final func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let transition = isPresent ? show : hide
        self.transitionContext = transitionContext
        transition(transitionContext)
    }
    
    private func extractContextInfoFrom(transitionContext: UIViewControllerContextTransitioning) -> (containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController)? {
        guard let containerView = transitionContext.containerView(),
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else {
                return nil
        }
        
        return (containerView, fromViewController, toViewController)
    }
    
    private func show(transitionContext: UIViewControllerContextTransitioning) {
        guard let (containerView, fromViewController, toViewController) = extractContextInfoFrom(transitionContext) else {
            return
        }
        
        guard let KaeruViewController = toViewController as? CollectionViewController else {
            return
        }
        
        do { // prepare for transition
            containerView.addSubview(KaeruViewController.view)
            containerView.addSubview(fromViewController.view)
            fromViewController.view.hidden = true
            fromViewController.view.frame = containerView.frame
            KaeruViewController.view.frame = containerView.bounds
            
            KaeruViewController.viewWillAppear(false)
        }
        
        do { // setup collection view layout
            KaeruViewController.collectionView.layout.isTransitioning = true
            KaeruViewController.collectionView.layout.reset()
            KaeruViewController.setContentOffsetRight()
            KaeruViewController.collectionView.reloadData()
            KaeruViewController.collectionView.layoutIfNeeded()
            KaeruViewController.collectionView.layout.isTransitioning = false
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 1, options: .CurveEaseInOut, animations: {
            self.appearAnimation(KaeruViewController)
        }) { finished in
            fromViewController.view.transform = CGAffineTransformIdentity
            fromViewController.view.hidden = true
            fromViewController.view.removeFromSuperview()
            KaeruViewController.collectionView.reloadData()
            transitionContext.completeTransition(true)
        }
    }
    
    private func appearAnimation(KaeruViewController: CollectionViewController) {
        let collectionView = KaeruViewController.collectionView
        KaeruViewController.collectionView.layout.attributesList.enumerate().forEach { index, attributes in
            guard let cell = collectionView.cellForItemAtIndexPath(attributes.indexPath) else {
                fatalError()
            }
            
            do { // configure appearing cells animation
                let layout = KaeruViewController.collectionView.layout
                
                let scaleX = attributes.transform.a * 0.8
                let scaleY = attributes.transform.d * 0.8
                let scale = CGAffineTransformMakeScale(scaleX, scaleY)
                
                let startAttributes = layout.startAttributesList[index]
                let translateX = ceil(attributes.center.x + attributes.transform.tx - startAttributes.center.x)
                let translateY = ceil(attributes.center.y - attributes.transform.ty - startAttributes.center.y)
                
                let translate = CGAffineTransformMakeTranslation(translateX, translateY)
                let concat = CGAffineTransformConcat(scale, translate)
                let transform = CATransform3DMakeAffineTransform(concat)
                
                cell.layer.setValue(
                    NSValue(CATransform3D: transform)
                    , forKey: "transform"
                )
            }
        }
    }
    
    private func hide(transitionContext: UIViewControllerContextTransitioning) {
        guard let (containerView, fromViewController, toViewController) = extractContextInfoFrom(transitionContext) else {
            return
        }
        
        guard let KaeruViewController = fromViewController as? CollectionViewController else {
            return
        }
        
        guard let navigationController = toViewController as? UINavigationController else {
            return
        }
        
        guard let selectedIndexPath = KaeruViewController.collectionView.layout.selectedIndexPath else {
            return
        }
        
        do { // prepare for transition
            containerView.addSubview(toViewController.view)
            containerView.addSubview(fromViewController.view)
            
            toViewController.view.hidden = true
            toViewController.view.frame = containerView.bounds
            
            KaeruViewController.view.frame = containerView.bounds
            KaeruViewController.collectionView.transform = CGAffineTransformIdentity
        }
        
        do {
            let viewController = navigationController.viewControllers[selectedIndexPath.item]
            navigationController.popToViewController(viewController, animated: false)
        }
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            KaeruViewController.collectionView.layout.attributesList.forEach { attributes in
                guard selectedIndexPath.item == attributes.indexPath.item else {
                    return
                }
                
                guard let cell = KaeruViewController.collectionView.cellForItemAtIndexPath(attributes.indexPath) else {
                    return
                }
                
                attributes.zIndex = KaeruViewController.collectionView.layout.attributesList.count
                KaeruViewController.collectionView.bringSubviewToFront(cell)
            }
            
            let scale = 1 / CustomLayout.adjustCellSize
            KaeruViewController.collectionView.transform = CGAffineTransformMakeScale(scale, scale)
        }) { finished in
            toViewController.view.hidden = false
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}