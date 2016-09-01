//
//  Helper.swift
//  KaeruDemo
//
//  Created by kingkong999yhirose on 2016/09/01.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

internal extension UIView {
    var className: String {
        let className = NSStringFromClass(self.dynamicType)
        let range = className.rangeOfString(".")
        return className.substringFromIndex(range!.endIndex)
    }
    class var className: String {
        let className = NSStringFromClass(self)
        let range = className.rangeOfString(".")
        return className.substringFromIndex(range!.endIndex)
    }
}

internal extension UIView {
    static func nib() -> UINib {
        return UINib(nibName: className, bundle: nil)
    }
}