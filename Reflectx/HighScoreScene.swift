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
    var highScoreLabel: SKLabelNode!
    var gamesPlayedLabel: SKLabelNode!
    var rankLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        highScoreLabel = self.childNodeWithName("highScoreLabel") as! SKLabelNode
        gamesPlayedLabel = self.childNodeWithName("gamesPlayedLabel") as! SKLabelNode
        rankLabel = self.childNodeWithName("rankLabel") as! SKLabelNode
        
        let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("highScore") as! Int
        highScoreLabel.text = "\(savedScore)"
        
        let savedRank: Int = NSUserDefaults.standardUserDefaults().objectForKey("highScore") as! Int
        if savedRank >= 0 && savedRank <= 19 {
            rankLabel.text = "Novice"
        }
    
        if savedRank >= 20 && savedRank <= 39 {
            rankLabel.text = "Apprentice"
        }
        
        if savedRank >= 40 && savedRank <= 69 {
            rankLabel.text = "Regular"
        }
        
        if savedRank >= 70 && savedRank <= 99 {
            rankLabel.text = "Expert"
        }
        
        if savedRank >= 100 && savedRank <= 149 {
            rankLabel.text = "Master"
        }
        
        if savedRank >= 150 && savedRank <= 199 {
            rankLabel.text = "Completer"
        }
        
        if savedRank >= 200 {
            rankLabel.text = "Transcender"
        }
        
        let savedGames3: Int = NSUserDefaults.standardUserDefaults().objectForKey("savedGames2") as! Int
        gamesPlayedLabel.text = "Games played - \(savedGames3)"
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
    }
    
}