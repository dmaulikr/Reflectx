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
    var highScoreButton: MSButtonNode!
    var rateButton: MSButtonNode!
    var shopButton: MSButtonNode!
    var infoButton: MSButtonNode!
    var goldNumber: SKLabelNode!
    var state: GameState = .Title
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        highScoreButton = self.childNodeWithName("highScoreButton") as! MSButtonNode
        rateButton = self.childNodeWithName("rateButton") as! MSButtonNode
        shopButton = self.childNodeWithName("shopButton") as! MSButtonNode
        infoButton = self.childNodeWithName("infoButton") as! MSButtonNode
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
    
        func playButtonClicked () {
            
            self.state = .Playing
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
            
        func highScoreButtonClicked () {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        func shopButtonClicked () {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        func infoButtonClicked () {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = InfoScene(fileNamed:"InfoScene") as InfoScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        playButton.selectedHandler = playButtonClicked
        highScoreButton.selectedHandler = highScoreButtonClicked
        shopButton.selectedHandler = shopButtonClicked
        infoButton.selectedHandler = infoButtonClicked

    }
    
}


    