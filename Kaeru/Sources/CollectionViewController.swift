// //  CollectionViewController.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/07/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController {
    fileprivate enum ScrollDirection {
        case none, left, right
    }
    
    fileprivate let snapShots: [UIImage]
    fileprivate let backgroundView: UIView
    
    init(snapShots: [UIImage], backgroundView: UIView?) {
        func defaultBackgroundView() -> UIView {
            let view = UIView(frame: UIScreen.main.bounds)
            view.backgroundColor = .gray()
            return view
        }
        
        self.snapShots = snapShots
        self.backgroundView = backgroundView ?? defaultBackgroundView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var beforeContentOffset: CGPoint?
    fileprivate var scrollDirection: ScrollDirection = .none
    
    final lazy var collectionView: CollectionView = {
        let collectionView = CollectionView(frame: UIScreen.main.bounds, collectionViewLayout: {
            let layout = CustomLayout(snapShots: self.snapShots)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
            return layout
            }()
        )
        
        collectionView.backgroundView = self.backgroundView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.addSubview(collectionView)
        collectionView.frame = view.frame
    }
    
    final func setContentOffsetRight() {
        let index = collectionView.numberOfItems(inSection: 0) - 2
        collectionView.setContentOffset(collectionView.layout.contentOffset(for: index), animated: false)
    }
}

extension CollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        defer {
            beforeContentOffset = scrollView.contentOffset
        }
        
        guard let beforeContentOffset = beforeContentOffset else {
            return
        }
        
        scrollDirection = scrollView.contentOffset.x > beforeContentOffset.x ? .left : .right
    }
    
    fileprivate func scrollAnimation() {
        self.collectionView.setContentOffset(collectionView.layout.contentOffsetForCurrentIndex(), animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollAnimation()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x == 0 {
            return
        }
        
        let maxScrollDistance = 3
        let distance = fabs(velocity.x) >= 1 ? maxScrollDistance - 1 : maxScrollDistance - 2
        let currentIndex = collectionView.layout.currentIndex
        
        var targetIndex = scrollDirection == .left ? currentIndex + distance : currentIndex - distance
        targetIndex = targetIndex >= snapShots.count - 1 ? snapShots.count - 1 : targetIndex
        targetIndex = targetIndex <= 0 ? 0 : targetIndex
        
        targetContentOffset.pointee.x = collectionView.layout.contentOffset(for: targetIndex).x
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snapShots.count
    }
    
    final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.className, for: indexPath) as! CollectionViewCell
        cell.setup(with: snapShots[(indexPath as NSIndexPath).item])
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: height)
    }
    
    final func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.layout.selectedIndexPath = indexPath
        collectionView.setContentOffset(self.collectionView.layout.contentOffset(for: (indexPath as NSIndexPath).item), animated: true)
        dismiss(animated: true, completion: nil)
    }
}
