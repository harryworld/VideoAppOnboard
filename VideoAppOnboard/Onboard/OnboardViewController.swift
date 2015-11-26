//
//  OnboardViewController.swift
//  VideoAppOnboard
//
//  Created by Harry Ng on 23/11/15.
//  Copyright © 2015 STAY REAL. All rights reserved.
//

import UIKit
import PermissionScope

class OnboardViewController: UIViewController {

    let pscope = PermissionScope()
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var photosView: UIView!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var photosImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pscope.viewControllerForAlerts = self
        pscope.addPermission(CameraPermission(),
            message: "We want to use Camera")
        pscope.addPermission(MicrophonePermission(),
            message: "We want to use Microphone")
        pscope.addPermission(PhotosPermission(),
            message: "We want to save your memories")
        
        pscope.onAuthChange = { (finished, results) in
            print("Request was finished with results \(results)")
            for result in results {
                // Animate button
                if result.status == .Authorized {
                    if result.type == .Camera {
                        
                    }
                    if result.type == .Microphone {
                        
                    }
                    if result.type == .Photos {
                        
                    }
                }
            }
        }
        pscope.onDisabledOrDenied = { results in
            print("Request was denied or disabled with results \(results)")
        }
        
        let tapCamera = UITapGestureRecognizer(target: self, action: "cameraTapped:")
        cameraView.addGestureRecognizer(tapCamera)
        let tapAudio = UITapGestureRecognizer(target: self, action: "audioTapped:")
        audioView.addGestureRecognizer(tapAudio)
        let tapPhotos = UITapGestureRecognizer(target: self, action: "photosTapped:")
        photosView.addGestureRecognizer(tapPhotos)
    }
    
    func cameraTapped(gesture: UITapGestureRecognizer) {
        print("camera")
        pscope.requestCamera()
    }

    func audioTapped(gesture: UITapGestureRecognizer) {
        print("audio")
        pscope.requestMicrophone()
    }
    
    func photosTapped(gesture: UITapGestureRecognizer) {
        pscope.requestPhotos()
        print("photos")
    }
    
}
