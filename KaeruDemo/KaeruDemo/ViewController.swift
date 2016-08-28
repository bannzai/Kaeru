//
//  ViewController.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/07/27.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit
import Kaeru

final class ViewController: UIViewController {
    class func instance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        return viewController
    }
    
    @IBOutlet weak var label: UILabel!

    private let colors: [UIColor] = [
        .grayColor(),
        .whiteColor(),
        .redColor(),
        .blueColor(),
        .greenColor(),
        .yellowColor(),
        .magentaColor(),
        .purpleColor(),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .blackColor()
        navigationController?.navigationBar.barTintColor = .orangeColor()
        
        if let count = navigationController?.viewControllers.count {
            view.backgroundColor = colors[count - 1]
            label.text = "viewController: \(count - 1)"
        }
    }
    
    @IBAction func showViewerButtonPressed(sender: AnyObject) {
        guard let navigationController = navigationController as? HistoryNavigationController else {
            fatalError()
        }
        
        navigationController.showViewer()
    }
    
    @IBAction func pushButtonPressed(sender: AnyObject) {
        navigationController?.pushViewController(ViewController.instance(), animated: true)
    }
}

