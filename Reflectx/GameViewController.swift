//
//  GameViewController.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright (c) 2016 Jacky. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GoogleMobileAds
import Social

class Social {
    func shareScore(_ scene: SKScene) {
        let postText: String = "Check out my score! Can you beat it? "
        let postImage: UIImage = getScreenshot(scene)
        let postGame: String = "https://itunes.apple.com/app/id1141987144"
        let activityItems = [postText, postImage, postGame] as [Any]
        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        let controller: UIViewController = scene.view!.window!.rootViewController!
        
        controller.present(
            activityController,
            animated: true,
            completion: nil
        )
    }
    
    func getScreenshot(_ scene: SKScene) -> UIImage {
        let snapshotView = scene.view!.snapshotView(afterScreenUpdates: true)
        let bounds = UIScreen.main.bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        snapshotView?.drawHierarchy(in: bounds, afterScreenUpdates: true)
        
        let screenshotImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return screenshotImage;
    }
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    func shareToFacebook () {
        let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.completionHandler = {
            result in
            switch result {
            case SLComposeViewControllerResult.cancelled:
                break
                
            case SLComposeViewControllerResult.done:
                break
            }
        }

        shareToFacebook.setInitialText("Check out this game: https://itunes.apple.com/app/id1141987144")
        shareToFacebook.add(UIImage(named: "IconPic.png"))
        self.present(shareToFacebook, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest()) */
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.shareToFacebook), name: NSNotification.Name(rawValue: "postToFacebook"), object: nil)

        
        if let scene = MainScene(fileNamed:"MainScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}

