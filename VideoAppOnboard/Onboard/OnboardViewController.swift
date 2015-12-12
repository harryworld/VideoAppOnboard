//
//  OnboardViewController.swift
//  VideoAppOnboard
//
//  Created by Harry Ng on 23/11/15.
//  Copyright © 2015 STAY REAL. All rights reserved.
//

import UIKit
import AssetsLibrary
import PermissionScope

public class OnboardViewController: UIViewController {

    public var albumName: String? = "Moments"
    
    let pscope = PermissionScope()
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var photosView: UIView!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var photosImageView: UIImageView!
    
    public class func loadFromNib() -> OnboardViewController {
        let bundle = NSBundle(forClass: OnboardViewController.self)
        let storyboard = UIStoryboard(name: "Onboard", bundle: bundle)
        return storyboard.instantiateViewControllerWithIdentifier("OnboardViewController") as! OnboardViewController
    }
    
    override public func viewDidLoad() {
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
                    dispatch_async(dispatch_get_main_queue(), {
                        if result.type == .Camera {
                            self.animateCircle(self.cameraImageView)
                        }
                        if result.type == .Microphone {
                            self.animateCircle(self.audioImageView)
                        }
                        if result.type == .Photos {
                            self.createAlbum()
                            self.animateCircle(self.photosImageView)
                        }
                    })
                }
            }
            self.allAllowed()
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
    
    override public func viewDidAppear(animated: Bool) {
        if pscope.statusCamera() == .Authorized {
            animateCircle(cameraImageView)
        }
        if pscope.statusMicrophone() == .Authorized {
            animateCircle(audioImageView)
        }
        if pscope.statusPhotos() == .Authorized {
            animateCircle(photosImageView)
        }
        allAllowed()
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
        print("photos")
        pscope.requestPhotos()
    }
    
    private func animateCircle(currentView: UIView) {
        let circleView = CircleView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        currentView.superview?.addSubview(circleView)
        circleView.center = currentView.center
        circleView.animateCircle(0.5)
    }
    
    private func allAllowed() -> Bool {
        let statusCamera = pscope.statusCamera()
        let statusMicrophone = pscope.statusMicrophone()
        let statusPhotos = pscope.statusPhotos()
        
        if (statusCamera == .Authorized && statusMicrophone == .Authorized && statusPhotos == .Authorized) {
            dismissViewControllerAnimated(true, completion: nil)
            return true
        } else {
            return false
        }
    }
    
    private func createAlbum() {
        guard albumName != nil else {
            print("Album name is not set")
            return
        }
        
        let library = ALAssetsLibrary()
        library.addAssetsGroupAlbumWithName(albumName, resultBlock: { (group) -> Void in
            print("Album added: \(self.albumName!)")
            }, failureBlock: { (error) -> Void in
                print("Error adding album \(error)")
        })
    }

}
