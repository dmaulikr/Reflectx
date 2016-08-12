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
    let soundOn: Bool = NSUserDefaults.standardUserDefaults().boolForKey("soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        highScoreLabel = self.childNodeWithName("highScoreLabel") as! SKLabelNode
        gamesPlayedLabel = self.childNodeWithName("gamesPlayedLabel") as! SKLabelNode
        rankLabel = self.childNodeWithName("rankLabel") as! SKLabelNode
        
        let savedScore: Int = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
        highScoreLabel.text = "\(savedScore)"
        
        let savedRank: Int = NSUserDefaults.standardUserDefaults().integerForKey("highScore")
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
        
        let savedGames: Int = NSUserDefaults.standardUserDefaults().integerForKey("savedGames2")
        gamesPlayedLabel.text = "Games played - \(savedGames)"
        
        backButton.selectedHandler = {
            
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFit
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
    }
    
}