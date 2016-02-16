//
//  DetailViewController.swift
//  Project1
//
//  Created by Nicolas Audren on 15/02/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailImageView: UIImageView!


    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let imageView = self.detailImageView {
                imageView.image = UIImage(named: detail)
                title = detail
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    func shareTapped() {
        let vc = UIActivityViewController(activityItems: [detailImageView.image!], applicationActivities: [])
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // this is for social media sharing
    // change the service type to SLServiceTypeFacebook for facebook
//    func shareTapped() {
//        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//        vc.setInitialText("Check yhis out!")
//        vc.addImage(detailImageView.image!)
//        vc.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
//        presentViewController(vc, animated: true, completion: nil)
//    }
}

