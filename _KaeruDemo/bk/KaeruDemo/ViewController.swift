//
//  ViewController.swift
//  Kaeru
//
//  Created by kingkong999yhirose on 2016/07/27.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit
import Kaeru

final class Cell: UITableViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
    
    final func setup(with image: UIImage) {
        contentImageView.image = image
    }
}

final class ViewController: UITableViewController {
    class func instance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        return viewController
    }
    
    @IBOutlet weak var label: UILabel!

    fileprivate let images: [UIImage] = [
        UIImage(named: "image1")!,
        UIImage(named: "image2")!,
        UIImage(named: "image3")!,
        UIImage(named: "image4")!,
        UIImage(named: "image5")!,
        UIImage(named: "image6")!,
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad( )
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        
        tableView.register(Cell.nib(), forCellReuseIdentifier: Cell.className)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let image = sender as? UIImage,
            let viewController = segue.destination as? DetailViewController
            else {
            return
        }
        
        viewController.image = image
    }
}

extension ViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.className, for: indexPath) as! Cell
        cell.setup(with: images[(indexPath as NSIndexPath).row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: images[(indexPath as NSIndexPath).row])
    }
}

