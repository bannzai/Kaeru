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

internal extension UIView {
    static func nib() -> UINib {
        return UINib(nibName: className, bundle: nil)
    }
}
