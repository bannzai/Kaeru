//
//  HistoryNavigationContainerView.swift
//  KaeruDemo
//
//  Created by Hirose.Yudai on 2017/03/09.
//  Copyright © 2017年 Hirose.Yudai. All rights reserved.
//

import UIKit

final class HistoryNavigationContainerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let force = touches.map { $0.force }.first
        print(force)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let force = touches.map { $0.force }.first
        print(force)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let force = touches.map { $0.force }.first
        print(force)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let force = touches.map { $0.force }.first
        print(force)
    }
}
