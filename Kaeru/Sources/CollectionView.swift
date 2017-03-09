//
//  CollectionView.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/08/22.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit
internal let width = UIScreen.main.bounds.width
internal let height = UIScreen.main.bounds.height

final class CollectionView: UICollectionView {
    final var layout: CustomLayout {
        return collectionViewLayout as! CustomLayout
    }
}

class CustomLayout: UICollectionViewFlowLayout {
    
    static let adjustCellSize: CGFloat = 0.8
    static let coefficientOfScale: CGFloat = 0.02
    
    private let visibleCellCount = 6
    private let cellCount: Int
    
    private var needPrepareLayout: Bool {
        return attributesList.isEmpty && startAttributesList.isEmpty
    }
    
    final var currentIndex: Int {
        guard let collectionView = collectionView else {
            return 0
        }
        
        var currentIndex = Int(round(collectionView.contentOffset.x / cellSize.width))
        if currentIndex >= cellCount - 1 {
            currentIndex = cellCount - 1
        }
        if currentIndex <= 0 {
            currentIndex = 0
        }
        
        return currentIndex
    }

    final var attributesList: [LayoutAttributes] = []
    final var startAttributesList: [LayoutAttributes] = []
    final var cellSize: CGSize = CGSize.zero
    final var contentSize: CGSize = CGSize.zero
    
    final var selectedIndexPath: IndexPath?
    final var isTransitioning = true
    
    init(snapShots: [UIImage]) {
        cellCount = snapShots.count
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        prepareIfNeeded()
    }
    
    final func reset() {
        attributesList.removeAll()
        startAttributesList.removeAll()
        prepareIfNeeded()
    }
    
    private func prepareIfNeeded() {
        guard needPrepareLayout else {
            return
        }
        _prepare()
    }
    
    private func _prepare() {
        let widthEachCell = width / CGFloat(visibleCellCount)
        let heightEachCell = height
        
        cellSize = CGSize(width: widthEachCell, height: heightEachCell)
        
        let totalWidth = cellSize.width * CGFloat(cellCount - 1) + width
        contentSize = CGSize(width: totalWidth, height: height)
       
        for index in 0..<cellCount {
            let indexPath = IndexPath(item: index, section: 0)
            
            do { // setup scrolling attributes
                let attributes = LayoutAttributes(forCellWith: indexPath)
                attributes.center = CGPoint(x: center(at: index).x, y: UIScreen.main.bounds.height / 2)
                attributes.zIndex = index
                attributes.size = CGSize(width: UIScreen.main.bounds.width * 0.8
                    , height: UIScreen.main.bounds.height * 0.8)
                
                attributesList.append(attributes)
                layout(with: attributes)
            }
            
            do { // setup transition start attributes
                let attributes = LayoutAttributes(forCellWith: indexPath)
                let origin = CGPoint(x: contentOffset(for: cellCount - 2).x, y: 0)
                let size = CGSize(width: width, height: height)
                attributes.frame = CGRect(origin: origin, size: size)
                attributes.zIndex = index
                attributes.transform = CGAffineTransform.identity
                startAttributesList.append(attributes)
            }
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return contentSize
    }
    
    private func center(at index: Int) -> CGPoint {
        func convert(with index: Int) -> CGFloat {
            return CGFloat(index)
        }
        
        let convertIndex = convert(with: index)
        let y = UIScreen.main.bounds.minY
        let x = width / 2 + convertIndex * cellSize.width

        return CGPoint(x: x, y: y)
    }
    
    private var contentOffsetCenter: CGPoint {
        guard let collectionView = collectionView else {
            return CGPoint.zero
        }
        
        let x = collectionView.contentOffset.x + width / 2
        let y = UIScreen.main.bounds.minY
        return CGPoint(x: x, y: y)
    }
    
    private var contentOffsetCenterX: CGFloat {
        return contentOffsetCenter.x
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        attributesList
            .forEach(layout)
        
        if isTransitioning {
            return startAttributesList
        }
        
        return attributesList
    }
    
    final func layout(with attributes: LayoutAttributes) {
        let progress = (attributes.center.x - contentOffsetCenterX) / width * CGFloat(visibleCellCount)
        
        attributes.progress = progress
        
        do { // set transform
            let calcTranslationX: ((CGFloat) -> CGFloat) = { adjust in
                return fabs(progress) * width / adjust
            }
            let transform = CGAffineTransform.identity
            let scale: CGAffineTransform = {
                let scale = 1 + progress * CustomLayout.coefficientOfScale
                return transform.scaledBy(x: scale, y: scale)
            }()
            let translation: CGAffineTransform = {
                let translationX = progress > 0 ? calcTranslationX(2.2) : calcTranslationX(13)
                return transform.translatedBy(x: translationX , y: 0)
            }()
            
            let concat = scale.concatenating(translation)
            attributes.transform = concat
        }
        
        attributes.isLast = attributes == attributesList.last
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if isTransitioning {
            return startAttributesList[(indexPath as NSIndexPath).item]
        }
        return attributesList[(indexPath as NSIndexPath).item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    final func contentOffset(for index: Int) -> CGPoint {
        guard let collectionView = collectionView else {
            return CGPoint.zero
        }
        
        let x = CGFloat(index) * cellSize.width
        return CGPoint(x: x, y: collectionView.contentOffset.y)
    }
    
    final func contentOffsetForCurrentIndex() -> CGPoint {
        return contentOffset(for: currentIndex)
    }
    
}
