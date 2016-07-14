//
//  MainScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class MainScene: SKScene {
    
    var playButton: MSButtonNode!
    var leftArrow: MSButtonNode!
    var rightArrow: MSButtonNode!
    var highScoreButton: MSButtonNode!
    var rateButton: MSButtonNode!
    var shopButton: MSButtonNode!
    var infoButton: MSButtonNode!
    var selectLevelBack: MSButtonNode!
    var state: GameState = .Title
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        leftArrow = self.childNodeWithName("leftArrow") as! MSButtonNode
        rightArrow = self.childNodeWithName("rightArrow") as! MSButtonNode
        highScoreButton = self.childNodeWithName("highScoreButton") as! MSButtonNode
        rateButton = self.childNodeWithName("rateButton") as! MSButtonNode
        shopButton = self.childNodeWithName("shopButton") as! MSButtonNode
        infoButton = self.childNodeWithName("infoButton") as! MSButtonNode
        selectLevelBack = self.childNodeWithName("selectLevelBack") as! MSButtonNode
    
        playButton.selectedHandler = {
            
            self.state = .Playing
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            skView.presentScene(scene)
            
        }
        
        highScoreButton.selectedHandler = {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        shopButton.selectedHandler = {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        infoButton.selectedHandler = {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = InfoScene(fileNamed:"InfoScene") as InfoScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
    }
    
}
    