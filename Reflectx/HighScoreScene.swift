//
//  HighScoreScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class HighScoreScene: SKScene {
    
    var backButton: MSButtonNode!
    var highScoreLabel1: SKLabelNode!
    var highScoreLabel2: SKLabelNode!
    var highScoreLabel3: SKLabelNode!
    var gamesPlayedLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        highScoreLabel1 = self.childNodeWithName("highScoreLabel1") as! SKLabelNode
        highScoreLabel2 = self.childNodeWithName("highScoreLabel2") as! SKLabelNode
        highScoreLabel3 = self.childNodeWithName("highScoreLabel3") as! SKLabelNode
        gamesPlayedLabel = self.childNodeWithName("gamesPlayedLabel") as! SKLabelNode
        
        let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("highScore") as! Int
        highScoreLabel1.text = "Easy -  \(savedScore)"
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
    }
    
}