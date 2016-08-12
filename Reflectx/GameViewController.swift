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
    func shareScore(scene: SKScene) {
        let postText: String = "Check out my score! Can you beat it? "
        let postImage: UIImage = getScreenshot(scene)
        let postGame: String = "https://itunes.apple.com/app/id1141987144"
        let activityItems = [postText, postImage, postGame]
        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        let controller: UIViewController = scene.view!.window!.rootViewController!
        
        controller.presentViewController(
            activityController,
            animated: true,
            completion: nil
        )
    }
    
    func getScreenshot(scene: SKScene) -> UIImage {
        let snapshotView = scene.view!.snapshotViewAfterScreenUpdates(true)
        let bounds = UIScreen.mainScreen().bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        snapshotView.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        
        let screenshotImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
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
            case SLComposeViewControllerResult.Cancelled:
                break
                
            case SLComposeViewControllerResult.Done:
                break
            }
        }

        shareToFacebook.setInitialText("Check out this game: https://itunes.apple.com/app/id1141987144")
        shareToFacebook.addImage(UIImage(named: "IconPic.png"))
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest()) */
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.shareToFacebook), name: "postToFacebook", object: nil)

        
        if let scene = MainScene(fileNamed:"MainScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

