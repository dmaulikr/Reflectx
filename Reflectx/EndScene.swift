//
//  EndScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

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
        
        let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("highScore") as! Int
        highScoreLabel.text = String(savedScore)
        
        let savedScore2: Int = NSUserDefaults.standardUserDefaults().objectForKey("localScore") as! Int
        scoreLabel2.text = String(savedScore2)
        
        homeButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        retryButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        highScoreButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        shopButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
    }
    
}