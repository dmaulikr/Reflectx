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
    
    override func didMoveToView(view: SKView) {
        
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        retryButton = self.childNodeWithName("retryButton") as! MSButtonNode
        highScoreButton = self.childNodeWithName("highScoreButton") as! MSButtonNode
        rateButton = self.childNodeWithName("rateButton") as! MSButtonNode
        shopButton = self.childNodeWithName("shopButton") as! MSButtonNode
        shareButton = self.childNodeWithName("shareButton") as! MSButtonNode
        
        homeButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        retryButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        highScoreButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        shopButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
    }
    
}