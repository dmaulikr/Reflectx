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
    let soundOn: Bool = UserDefaults.standard.bool(forKey: "soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    let playSFX = SKAction.playSoundFileNamed("play", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        homeButton = self.childNode(withName: "homeButton") as! MSButtonNode
        retryButton = self.childNode(withName: "retryButton") as! MSButtonNode
        highScoreButton = self.childNode(withName: "highScoreButton") as! MSButtonNode
        rateButton = self.childNode(withName: "rateButton") as! MSButtonNode
        shopButton = self.childNode(withName: "shopButton") as! MSButtonNode
        shareButton = self.childNode(withName: "shareButton") as! MSButtonNode
        goldNumber = self.childNode(withName: "goldNumber") as! SKLabelNode
        scoreLabel2 = self.childNode(withName: "scoreLabel2") as! SKLabelNode
        highScoreLabel = self.childNode(withName: "highScoreLabel") as! SKLabelNode
        addGold = self.childNode(withName: "addGold") as! SKLabelNode
        
        let savedScore: Int = UserDefaults.standard.integer(forKey: "highScore")
        highScoreLabel.text = String(savedScore)
        
        scoreLabel2.text = String(localScore)
        addGold.text = "+\(earnedCoins)"
        
        let savedCoins: Int = UserDefaults.standard.integer(forKey: "savedCoins")
        goldNumber.text = "\(savedCoins)"

        shareButton.selectedHandler = {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "postToFacebook"), object: nil)
            if self.soundOn {
                self.run(self.playSFX)
            }
            //let socialHandler = Social()
            //socialHandler.shareScore(self)
        }
        
        rateButton.selectedHandler = {
            if self.soundOn {
                self.run(self.playSFX)
            }
            UIApplication.shared.openURL(URL(string : "itms-apps://itunes.apple.com/app/id1141987144")!);
        }
        
        homeButton.selectedHandler = {
            
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
            
        }
        
        retryButton.selectedHandler = {
            
            if self.soundOn {
                self.run(self.playSFX)
            }
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
            
        }
        
        highScoreButton.selectedHandler = {
            
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
            
        }
        
        shopButton.selectedHandler = {
            
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
            
        }
        
    }
    
}
