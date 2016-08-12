//
//  UIClass.swift
//  Reflectx
//
//  Created by Jacky Chen on 8/2/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class UIClass: SKNode{
    
    var scoreLabel: SKLabelNode!
    var buffLabel: SKLabelNode!
    var pauseButton: MSButtonNode!
    var countLabel: SKLabelNode!
    var instructions: SKLabelNode!
    var hiddenLabel: SKLabelNode!
    var pauseLabel: SKLabelNode!
    var fastForwardWhite: SKSpriteNode!
    var smallLeftArrow: SKSpriteNode!
    var smallRightArrow: SKSpriteNode!
    var instructionsNumber = 0
    let powerupSFX = SKAction.playSoundFileNamed("powerup", waitForCompletion: false)
    var soundOn: Bool = NSUserDefaults.standardUserDefaults().boolForKey("soundOn")
    var pause: Bool = false
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        buffLabel = childNodeWithName("buffLabel") as! SKLabelNode
        pauseButton = childNodeWithName("pauseButton") as! MSButtonNode
        countLabel = childNodeWithName("countLabel") as! SKLabelNode
        hiddenLabel = childNodeWithName("hiddenLabel") as! SKLabelNode
        fastForwardWhite = childNodeWithName("fastForwardWhite") as! SKSpriteNode
        smallLeftArrow = childNodeWithName("smallLeftArrow") as! SKSpriteNode
        smallRightArrow = childNodeWithName("smallRightArrow") as! SKSpriteNode
        instructions = childNodeWithName("instructions") as! SKLabelNode
        pauseLabel = childNodeWithName("pauseLabel") as! SKLabelNode
        
        buffLabel.hidden = true
        countLabel.hidden = true
        fastForwardWhite.hidden = true
        hiddenLabel.hidden = true
        pauseLabel.hidden = true
        
        self.runAction(SKAction.waitForDuration(1.3), completion: {() -> Void in
            self.instructions.hidden = true
        })
    }
    
    func setupPauseButton (scene: GameScene) {
        pauseButton.selectedHandler = {
            self.pause = !self.pause
            
            // when music on, press pause = music on, press unpause = music off 
            // also always music when die
            
            if self.pause {
                if self.soundOn {
                    self.runAction(self.buttonSFX)
                }
                self.pauseButton.texture = SKTexture(imageNamed: "rightTriangleWhite")
                self.setpauseLabel1 ()
                scene.paused = true
                scene.player.pause()
            }
                
            else if !self.pause {
                if self.soundOn {
                    self.runAction(self.buttonSFX)
                }
                self.countLabel.hidden = false
                self.countLabel.text = "3"
                SKAction.waitForDuration(1)
                self.countLabel.text = "2"
                SKAction.waitForDuration(1)
                self.countLabel.text = "1"
                SKAction.waitForDuration(1)
                self.countLabel.hidden = true
                self.pauseButton.texture = SKTexture(imageNamed: "pauseButtonWhite")
                self.setpauseLabel2 ()
                scene.paused = false
                if self.soundOn {
                scene.player.play()
                }
            }
        }
    }
    
    func setpauseLabel1 () {
        self.pauseLabel.text = "-paused-"
        self.pauseLabel.hidden = false
    }
    
    func setpauseLabel2 () {
        self.pauseLabel.text = "-paused-"
        self.pauseLabel.hidden = true
    }
    
    func setBuffLabel () {
        self.buffLabel.text = "2x"
        self.buffLabel.hidden = false
        self.runAction(SKAction.waitForDuration(1.3), completion: {() -> Void in
            self.buffLabel.hidden = true
        })
        self.runAction(powerupSFX)
    }
    
    func scoreColor (points: Int) {
        switch (points) {
            
        case 5...9:
            scoreLabel.fontColor = UIColor.greenColor()
        case 10...19:
            scoreLabel.fontColor = UIColor.orangeColor()
        case 20...39:
            scoreLabel.fontColor = UIColor.blueColor()
        case 40...79:
            scoreLabel.fontColor = UIColor.redColor()
        case 80...159:
            scoreLabel.fontColor = UIColor.yellowColor()
        case 160:
            scoreLabel.fontColor = UIColor.blackColor()
        default:
            break
            
        }
        
    }
    
    func hideArrows () {
        smallLeftArrow.hidden = true
        smallRightArrow.hidden = true
    }
    
    func fastForwardAnimation () {
        self.fastForwardWhite.hidden = false
        self.runAction(SKAction.waitForDuration(1.3), completion: {() -> Void in
            self.fastForwardWhite.hidden = true
        })
    }
    
    func hiddenLabelAnimation () {
        self.hiddenLabel.hidden = false
        self.runAction(SKAction.waitForDuration(3), completion: {() -> Void in
            self.hiddenLabel.hidden = true
        })
    }
    
    func instructionsUpdate() {
        instructionsNumber += 1
        if instructionsNumber > 1 {
            self.instructions.hidden = true
        }
        else if instructionsNumber <= 1 {
            self.runAction(SKAction.waitForDuration(2), completion: {() -> Void in
                self.instructions.text = "Let go to shoot"
                self.instructions.hidden = false
                self.runAction(SKAction.waitForDuration(2), completion: {() -> Void in
                    self.instructions.hidden = true
                })
            })
        }
        
    }
    
    func updateScoreLabel (points: Int) {
        scoreLabel.text = "\(points)"
    }
    
}
