//
//  ViewController.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/07/27.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit

final class Cell: UITableViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
    
    final func setup(with image: UIImage) {
        contentImageView.image = image
    }
}

final class ViewController: UITableViewController {
    class func instance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        return viewController
    }
    
    @IBOutlet weak var label: UILabel!

    private let images: [UIImage] = [
        UIImage(named: "image1")!,
        UIImage(named: "image2")!,
        UIImage(named: "image3")!,
        UIImage(named: "image4")!,
        UIImage(named: "image5")!,
        UIImage(named: "image6")!,
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .blackColor()
        navigationController?.navigationBar.barTintColor = .whiteColor()
        
        tableView.registerNib(Cell.nib(), forCellReuseIdentifier: Cell.className)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let image = sender as? UIImage,
            viewController = segue.destinationViewController as? DetailViewController
            else {
            return
        }
        
        viewController.image = image
    }
}

extension ViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.className, forIndexPath: indexPath) as! Cell
        cell.setup(with: images[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toDetail", sender: images[indexPath.row])
    }
}

