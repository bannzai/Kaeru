// //  CollectionViewController.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/07/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController {
    private enum ScrollDirection {
        case none, left, right
    }
    
    private let snapShots: [UIImage]
    private let backgroundView: UIView
    
    init(snapShots: [UIImage], backgroundView: UIView?) {
        func defaultBackgroundView() -> UIView {
            let view = UIView(frame: UIScreen.mainScreen().bounds)
            view.backgroundColor = .grayColor()
            return view
        }
        
        self.snapShots = snapShots
        self.backgroundView = backgroundView ?? defaultBackgroundView()
        
        super.init(nibName: nil, bundle: nil)
        
        setupBlurImagesInBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var beforeContentOffset: CGPoint?
    private var scrollDirection: ScrollDirection = .none
    private var blurImages: [UIImage] = []
    
    final lazy var collectionView: CollectionView = {
        let collectionView = CollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: {
            let layout = CustomLayout(snapShots: self.snapShots)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .Horizontal
            return layout
            }()
        )
        
        collectionView.backgroundView = self.backgroundView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.registerNib(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.enabled = false
        view.addSubview(collectionView)
        collectionView.frame = view.frame
    }
    
    private func setupBlurImagesInBackground() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.snapShots.forEach { snapShot in
                let blurImage = snapShot.blur(10)
                dispatch_async(dispatch_get_main_queue()) {
                    self.blurImages.append(blurImage)
                }
            }
        }
    }
    
    private func blurImageOrSnapShot(of index: Int) -> UIImage {
        if blurImages.count <= index {
            return snapShots[index]
        }
        
        return blurImages[index]
    }
    
    final func setContentOffsetRight() {
        let index = collectionView.numberOfItemsInSection(0) - 2
        collectionView.setContentOffset(collectionView.layout.contentOffset(for: index), animated: false)
    }
}

extension CollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        defer {
            beforeContentOffset = scrollView.contentOffset
        }
        
        guard let beforeContentOffset = beforeContentOffset else {
            return
        }
        
        scrollDirection = scrollView.contentOffset.x > beforeContentOffset.x ? .left : .right
    }
    
    private func scrollAnimation() {
        self.collectionView.setContentOffset(collectionView.layout.contentOffsetForCurrentIndex(), animated: true)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollAnimation()
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x == 0 {
            return
        }
        
        let maxScrollDistance = 3
        let distance = fabs(velocity.x) >= 1 ? maxScrollDistance - 1 : maxScrollDistance - 2
        let currentIndex = collectionView.layout.currentIndex
        
        var targetIndex = scrollDirection == .left ? currentIndex + distance : currentIndex - distance
        targetIndex = targetIndex >= snapShots.count - 1 ? snapShots.count - 1 : targetIndex
        targetIndex = targetIndex <= 0 ? 0 : targetIndex
        
        targetContentOffset.memory.x = collectionView.layout.contentOffset(for: targetIndex).x
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    final func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    final func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snapShots.count
    }
    
    final func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionViewCell.className, forIndexPath: indexPath) as! CollectionViewCell
        cell.setup(with: snapShots[indexPath.item], blurImage: blurImageOrSnapShot(of: indexPath.item))
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    final func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(width, height)
    }
    
    final func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.layout.selectedIndexPath = indexPath
        collectionView.setContentOffset(self.collectionView.layout.contentOffset(for: indexPath.item), animated: true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
