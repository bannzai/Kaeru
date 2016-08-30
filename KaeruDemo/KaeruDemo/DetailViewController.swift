//
//  DetailViewController.swift
//  KaeruDemo
//
//  Created by Hirose.Yudai on 2016/08/30.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    class func instance() -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        return viewController
    }
    
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .ScaleAspectFill
        imageView.image = image
    }
}
