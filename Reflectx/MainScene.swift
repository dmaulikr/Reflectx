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
    var goldNumber: SKLabelNode!
    var selectLevel: SKLabelNode!
    var state: GameState = .Title
    var currentDifficulty: DifficultyState = .Easy
    
    enum DifficultyState : String{
        case Easy = "Easy", Medium = "Medium", Hard = "Hard"
    }
    
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
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        selectLevel = self.childNodeWithName("selectLevel") as! SKLabelNode
    
        func playButtonClicked () {
            
            self.state = .Playing
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.difficulty = currentDifficulty
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
        
/*     func playerHighScoreUpdate() {
 let highScore = NSUserDefaults().integerForKey("highScore")
 if points > highScore {
 NSUserDefaults().setInteger(points, forKey: "highScore")
 NSUserDefaults.standardUserDefaults().synchronize()
 }
 scoreLabel.text = "\(points)"
 } 
         
         playerHighScoreUpdate()
         print(NSUserDefaults().integerForKey("highScore"))
         
         var points = 0

         */
        
        func difficultiesUpdate () {

            
        }
 
        func rightArrowClicked () {
 
            self.state = .Browse
            switch currentDifficulty {
            case .Easy:
                currentDifficulty = .Medium
                break
            case .Medium:
                currentDifficulty = .Hard
                break
            case .Hard:
                print ("already on highest")
            }
            self.selectLevel.text = currentDifficulty.rawValue
            
        }
        
        func leftArrowClicked () {
            
            self.state = .Browse
            switch currentDifficulty {
            case .Easy:
                print ("already on lowest")
                break
            case .Medium:
                currentDifficulty = .Easy
                break
            case .Hard:
                currentDifficulty = .Medium
                break
            }
            self.selectLevel.text = currentDifficulty.rawValue
            
        }
        
        leftArrow.selectedHandler = leftArrowClicked
        rightArrow.selectedHandler = rightArrowClicked
        playButton.selectedHandler = playButtonClicked
        highScoreButton.selectedHandler = highScoreButtonClicked
        shopButton.selectedHandler = shopButtonClicked
        infoButton.selectedHandler = infoButtonClicked

    }
    
}


    