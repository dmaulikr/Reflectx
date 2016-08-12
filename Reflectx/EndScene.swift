//
//  EndScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit
import Social

class EndScene: SKScene {
    
    var homeButton: MSButtonNode!
    var retryButton: MSButtonNode!
    var highScoreButton: MSButtonNode!
    var rateButton: MSButtonNode!
    var shopButton: MSButtonNode!
    var shareButton: MSButtonNode!
    var goldNumber: SKLabelNode!
    var scoreLabel2: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var addGold: SKLabelNode!
    var localScore = 0
    var earnedCoins = 0
    let soundOn: Bool = NSUserDefaults.standardUserDefaults().boolForKey("soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    let playSFX = SKAction.playSoundFileNamed("play", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        retryButton = self.childNodeWithName("retryButton") as! MSButtonNode
        highScoreButton = self.childNodeWithName("highScoreButton") as! MSButtonNode
        rateButton = self.childNodeWithName("rateButton") as! MSButtonNode
        shopButton = self.childNodeWithName("shopButton") as! MSButtonNode
        shareButton = self.childNodeWithName("shareButton") as! MSButtonNode
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        scoreLabel2 = self.childNodeWithName("scoreLabel2") as! SKLabelNode
        highScoreLabel = self.childNodeWithName("highScoreLabel") as! SKLabelNode
        addGold = self.childNodeWithName("addGold") as! SKLabelNode
        
        let savedScore: Int = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
        highScoreLabel.text = String(savedScore)
        
        scoreLabel2.text = String(localScore)
        addGold.text = "+\(earnedCoins)"
        
        let savedCoins: Int = NSUserDefaults.standardUserDefaults().integerForKey("savedCoins")
        goldNumber.text = "\(savedCoins)"

        shareButton.selectedHandler = {
            //NSNotificationCenter.defaultCenter().postNotificationName("postToFacebook", object: nil)
            if self.soundOn {
                self.runAction(self.playSFX)
            }
            let socialHandler = Social()
            socialHandler.shareScore(self)
        }
        
        rateButton.selectedHandler = {
            if self.soundOn {
                self.runAction(self.playSFX)
            }
            UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1141987144&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!);
        }
        
        homeButton.selectedHandler = {
            
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFit
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        retryButton.selectedHandler = {
            
            if self.soundOn {
                self.runAction(self.playSFX)
            }
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFit
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        highScoreButton.selectedHandler = {
            
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
            scene.scaleMode = .AspectFit
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        shopButton.selectedHandler = {
            
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
            scene.scaleMode = .AspectFit
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
    }
    
}