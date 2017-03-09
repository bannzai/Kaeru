//
//  Helper.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/07/29.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit
import CoreImage

internal extension UIViewController {
    func snapShotFromWindow() -> UIImage? {
        return view.snapShotFromWindow()
    }
}

internal extension UIView {
    func snapShotFromWindow() -> UIImage {
        guard let window = UIApplication.shared.keyWindow else {
            fatalError()
        }
        
        UIGraphicsBeginImageContextWithOptions(window.frame.size, false, 1)
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

internal extension UIView {
    func configureSnapShotLayer() {
        layer.cornerRadius = 4.0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
    }
}


internal extension UIView {
    func addWholeConstraint(_ view: UIView) {
        [.top, .bottom, .left, .right].forEach {
            NSLayoutConstraint(
                item: self,
                attribute: $0,
                relatedBy: .equal,
                toItem: view,
                attribute: $0,
                multiplier: 1,
                constant: 0)
                .isActive = true
        }
    }
    
}

internal extension UIView {
    var className: String {
        let className = NSStringFromClass(type(of: self))
        let range = className.range(of: ".")
        return className.substring(from: range!.upperBound)
    }
    class var className: String {
        let className = NSStringFromClass(self)
        let range = className.range(of: ".")
        return className.substring(from: range!.upperBound)
    }
}

internal extension Array {
    mutating func removeToLast(from index: Int) {
        removeSubrange(index..<count)
    }
    mutating func removeToLastIfPossible(from index: Int) {
        if index >= count {
            return
        }
        removeToLast(from: index)
    }
}
