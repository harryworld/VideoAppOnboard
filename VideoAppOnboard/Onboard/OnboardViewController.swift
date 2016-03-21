//
//  OnboardViewController.swift
//  VideoAppOnboard
//
//  Created by Harry Ng on 23/11/15.
//  Copyright © 2015 STAY REAL. All rights reserved.
//

let ANIMATION_TIME = 0.5

import UIKit
import AssetsLibrary
import PermissionScope
import PulsingHalo

public class OnboardViewController: UIViewController {

    public var albumName: String? = "Moments"
    
    var window: UIWindow?
    var vcToShow: UIViewController?
    var complete: (() -> Void)?
    
    let pscope = PermissionScope()
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var photosView: UIView!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var photosImageView: UIImageView!
    
    lazy var cameraPulse: PulsingHaloLayer = self.createPulse()
    lazy var audioPulse: PulsingHaloLayer = self.createPulse()
    lazy var photosPulse: PulsingHaloLayer = self.createPulse()
    
    // ===================
    // MARK: - loadFromNib
    // ===================
    
    public class func loadFromNib() -> OnboardViewController {
        let bundle = NSBundle(forClass: OnboardViewController.self)
        let storyboard = UIStoryboard(name: "Onboard", bundle: bundle)
        return storyboard.instantiateViewControllerWithIdentifier("OnboardViewController") as! OnboardViewController
    }
    
    public class func loadFromNib(window window: UIWindow?, vcToShow: UIViewController?) -> OnboardViewController {
        let vc = OnboardViewController.loadFromNib()
        vc.window = window
        vc.vcToShow = vcToShow
        return vc
    }
    
    public class func loadFromNib(complete complete: () -> Void) -> OnboardViewController {
        let vc = OnboardViewController.loadFromNib()
        vc.complete = complete
        return vc
    }
    
    // =========================
    // MARK: - Lifecycle Methods
    // =========================
    
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
                            self.animateCircle(self.cameraImageView, self.cameraPulse)
                        }
                        if result.type == .Microphone {
                            self.animateCircle(self.audioImageView, self.audioPulse)
                        }
                        if result.type == .Photos {
                            self.createAlbum()
                            self.animateCircle(self.photosImageView, self.photosPulse)
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
            animateCircle(cameraImageView, cameraPulse)
        } else {
            showPulse(cameraImageView, cameraPulse)
        }
        
        if pscope.statusMicrophone() == .Authorized {
            animateCircle(audioImageView, audioPulse)
        } else {
            showPulse(audioImageView, audioPulse)
        }
        
        if pscope.statusPhotos() == .Authorized {
            animateCircle(photosImageView, photosPulse)
        } else {
            showPulse(photosImageView, photosPulse)
        }
        
        // Check if all required permissions granted
        allAllowed()
    }
    
    // =================
    // MARK: - IBActions
    // =================

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
    
    // ======================
    // MARK: - Helper Methods
    // ======================
    
    private func createPulse() -> PulsingHaloLayer {
        let halo = PulsingHaloLayer()
        halo.haloLayerNumber = 2
        halo.backgroundColor = UIColor.redColor().CGColor
        halo.animationDuration = 8
        return halo
    }
    
    private func showPulse(currentView: UIView, _ halo: PulsingHaloLayer) {
        halo.position = currentView.center
        currentView.superview?.layer.addSublayer(halo)
        halo.start()
    }
    
    private func animateCircle(currentView: UIView, _ halo: PulsingHaloLayer) {
        halo.removeFromSuperlayer()
        
        let circleView = CircleView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        currentView.superview?.addSubview(circleView)
        circleView.center = currentView.center
        circleView.animateCircle(ANIMATION_TIME)
    }
    
    private func allAllowed() -> Bool {
        let statusCamera = pscope.statusCamera()
        let statusMicrophone = pscope.statusMicrophone()
        let statusPhotos = pscope.statusPhotos()
        
        if (statusCamera == .Authorized && statusMicrophone == .Authorized && statusPhotos == .Authorized) {
            if let window = self.window, vcToShow = self.vcToShow {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(ANIMATION_TIME * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
                    window.rootViewController = vcToShow
                })
            }
            if let complete = self.complete {
                complete()
            }
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
