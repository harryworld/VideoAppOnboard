//
//  OnboardViewController.swift
//  VideoAppOnboard
//
//  Created by Harry Ng on 23/11/15.
//  Copyright © 2015 STAY REAL. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var photosView: UIView!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var photosImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapCamera = UITapGestureRecognizer(target: self, action: "cameraTapped:")
        cameraView.addGestureRecognizer(tapCamera)
        let tapAudio = UITapGestureRecognizer(target: self, action: "audioTapped:")
        audioView.addGestureRecognizer(tapAudio)
        let tapPhotos = UITapGestureRecognizer(target: self, action: "photosTapped:")
        photosView.addGestureRecognizer(tapPhotos)
    }
    
    func cameraTapped(gesture: UITapGestureRecognizer) {
        print("camera")
    }

    func audioTapped(gesture: UITapGestureRecognizer) {
        print("audio")
    }
    
    func photosTapped(gesture: UITapGestureRecognizer) {
        print("photos")
    }
    
}
