//
//  ViewController.swift
//  VideoAppOnboard
//
//  Created by Harry Ng on 23/11/15.
//  Copyright © 2015 STAY REAL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().boolForKey(kPermissionGranted) {
            
        } else {
            let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("OnboardViewController") as! OnboardViewController
            presentViewController(vc, animated: false, completion: nil)
        }
    }


}

