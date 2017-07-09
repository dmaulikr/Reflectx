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
    var soundOn: Bool = UserDefaults.standard.bool(forKey: "soundOn")
    var pause: Bool = false
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        buffLabel = childNode(withName: "buffLabel") as! SKLabelNode
        pauseButton = childNode(withName: "pauseButton") as! MSButtonNode
        countLabel = childNode(withName: "countLabel") as! SKLabelNode
        hiddenLabel = childNode(withName: "hiddenLabel") as! SKLabelNode
        fastForwardWhite = childNode(withName: "fastForwardWhite") as! SKSpriteNode
        smallLeftArrow = childNode(withName: "smallLeftArrow") as! SKSpriteNode
        smallRightArrow = childNode(withName: "smallRightArrow") as! SKSpriteNode
        instructions = childNode(withName: "instructions") as! SKLabelNode
        pauseLabel = childNode(withName: "pauseLabel") as! SKLabelNode
        
        buffLabel.isHidden = true
        countLabel.isHidden = true
        fastForwardWhite.isHidden = true
        hiddenLabel.isHidden = true
        pauseLabel.isHidden = true
        
        self.run(SKAction.wait(forDuration: 1.3), completion: {() -> Void in
            self.instructions.isHidden = true
        })
    }
    
    func setupPauseButton (_ scene: GameScene) {
        pauseButton.selectedHandler = {
            self.pause = !self.pause
            
            if self.pause {
                if self.soundOn {
                    self.run(self.buttonSFX)
                }
                self.pauseButton.texture = SKTexture(imageNamed: "rightTriangleWhite")
                self.setpauseLabel1 ()
                scene.isPaused = true
                scene.player.pause()
            }
                
            else if !self.pause {
                if self.soundOn {
                    self.run(self.buttonSFX)
                }
                self.countLabel.isHidden = false
                self.countLabel.text = "3"
                SKAction.wait(forDuration: 1)
                self.countLabel.text = "2"
                SKAction.wait(forDuration: 1)
                self.countLabel.text = "1"
                SKAction.wait(forDuration: 1)
                self.countLabel.isHidden = true
                self.pauseButton.texture = SKTexture(imageNamed: "pauseButtonWhite")
                self.setpauseLabel2 ()
                scene.isPaused = false
                if self.soundOn {
                scene.player.play()
                }
            }
        }
    }
    
    func setpauseLabel1 () {
        self.pauseLabel.text = "-paused-"
        self.pauseLabel.isHidden = false
    }
    
    func setpauseLabel2 () {
        self.pauseLabel.text = "-paused-"
        self.pauseLabel.isHidden = true
    }
    
    func setBuffLabel () {
        self.buffLabel.text = "2x"
        self.buffLabel.isHidden = false
        self.run(SKAction.wait(forDuration: 1.3), completion: {() -> Void in
            self.buffLabel.isHidden = true
        })
        self.run(powerupSFX)
    }
    
    func scoreColor (_ points: Int) {
        switch (points) {
            
        case 5...9:
            scoreLabel.fontColor = UIColor.green
        case 10...19:
            scoreLabel.fontColor = UIColor.orange
        case 20...39:
            scoreLabel.fontColor = UIColor.blue
        case 40...79:
            scoreLabel.fontColor = UIColor.red
        case 80...159:
            scoreLabel.fontColor = UIColor.yellow
        case 160:
            scoreLabel.fontColor = UIColor.black
        default:
            break
            
        }
        
    }
    
    func hideArrows () {
        smallLeftArrow.isHidden = true
        smallRightArrow.isHidden = true
    }
    
    func fastForwardAnimation () {
        self.fastForwardWhite.isHidden = false
        self.run(SKAction.wait(forDuration: 1.3), completion: {() -> Void in
            self.fastForwardWhite.isHidden = true
        })
    }
    
    func hiddenLabelAnimation () {
        self.hiddenLabel.isHidden = false
        self.run(SKAction.wait(forDuration: 3), completion: {() -> Void in
            self.hiddenLabel.isHidden = true
        })
    }
    
    func instructionsUpdate() {
        instructionsNumber += 1
        if instructionsNumber > 1 {
            self.instructions.isHidden = true
        }
        else if instructionsNumber <= 1 {
            self.run(SKAction.wait(forDuration: 2), completion: {() -> Void in
                self.instructions.text = "Let go to shoot"
                self.instructions.isHidden = false
                self.run(SKAction.wait(forDuration: 2), completion: {() -> Void in
                    self.instructions.isHidden = true
                })
            })
        }
        
    }
    
    func updateScoreLabel (_ points: Int) {
        scoreLabel.text = "\(points)"
    }
    
}
