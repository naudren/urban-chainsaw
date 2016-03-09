//
//  ViewController.swift
//  Project8
//
//  Created by Nicolas Audren on 09/03/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitTapped(sender: UIButton) {
    }
    
    @IBAction func clearTapped(sender: UIButton) {
    }

}

