//
//  ViewController.swift
//  VideoAppOnboard
//
//  Created by Harry Ng on 23/11/15.
//  Copyright © 2015 STAY REAL. All rights reserved.
//

import UIKit
import PermissionScope

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        let pscope = PermissionScope()
        if pscope.statusCamera() == .Authorized &&
            pscope.statusMicrophone() == .Authorized &&
            pscope.statusPhotos() == .Authorized {
            
        } else {
            let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("OnboardViewController") as! OnboardViewController
            presentViewController(vc, animated: false, completion: nil)
        }
    }


}

