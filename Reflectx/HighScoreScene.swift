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
    let soundOn: Bool = UserDefaults.standard.bool(forKey: "soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        backButton = self.childNode(withName: "backButton") as! MSButtonNode
        highScoreLabel = self.childNode(withName: "highScoreLabel") as! SKLabelNode
        gamesPlayedLabel = self.childNode(withName: "gamesPlayedLabel") as! SKLabelNode
        rankLabel = self.childNode(withName: "rankLabel") as! SKLabelNode
        
        let savedScore: Int = UserDefaults.standard.integer(forKey: "highScore")
        highScoreLabel.text = "\(savedScore)"
        
        let savedRank: Int = UserDefaults.standard.integer(forKey: "highScore")
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
        
        let savedGames: Int = UserDefaults.standard.integer(forKey: "savedGames2")
        gamesPlayedLabel.text = "Games played - \(savedGames)"
        
        backButton.selectedHandler = {
            
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
            
        }
        
    }
    
}
