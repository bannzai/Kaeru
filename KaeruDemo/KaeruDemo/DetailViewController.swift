//
//  DetailViewController.swift
//  KaeruDemo
//
//  Created by Hirose.Yudai on 2016/08/30.
//  Copyright © 2016年 kingkong999yhirose. All rights reserved.
//

import UIKit
import Kaeru

internal extension UIImage {
    func blur(_ radius: CGFloat) -> UIImage {
        guard let cgImage = cgImage,
            let filteredImage = Optional(CoreImage.CIImage(cgImage: cgImage)),
            let blurFilter = CIFilter(name: "CIGaussianBlur")
            else {
                return self
        }
        
        blurFilter.setDefaults()
        blurFilter.setValue(filteredImage, forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let cropFilter = CIFilter(name: "CICrop") else {
            return self
        }
        
        cropFilter.setValue(blurFilter.outputImage, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: filteredImage.extent), forKey: "inputRectangle")
        
        guard let outputImage = cropFilter.outputImage else {
            return self
        }
        
        return UIImage(ciImage: outputImage)		
    }		
}		




class DetailViewController: UIViewController {
    class func instance() -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        return viewController
    }
    
    var image: UIImage?
    var blurImage: UIImage?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        label.text = [
            "Now is \(navigationController!.viewControllers.count)th page.",
            "You can press [ShowList] or [ShowHistory] buttons",
            "When [ShowList] pressed, push to List ViewController ",
            "When [ShowHistory] pressed, see the history of snapshot about ViewController from UINavigationController.viewControllers stack.",
            "And you can tap ViewController, when close history and return in choose ViewController.",
            ]
            .reduce("")
            { $0 + $1 + "\n" }
        
        setupBlurImagesInBackground()
    }
    
    
    fileprivate func setupBlurImagesInBackground() {
        DispatchQueue.global().async {
            let blurImage = self.image?.blur(10)
            DispatchQueue.main.async {
                self.blurImage = blurImage
            }
        }
    }
    
    @IBAction func showHIstoryPressed(_ sender: AnyObject) {
        guard let blurImage = blurImage else {
            navigationController?.presentHistory()
            return
        }
        let imageView = UIImageView(image: blurImage)
        imageView.clipsToBounds = true
        navigationController?.presentHistory(imageView)
    }
    
}
