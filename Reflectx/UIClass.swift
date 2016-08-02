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
    var fastForwardWhite: SKSpriteNode!
    var smallLeftArrow: SKSpriteNode!
    var smallRightArrow: SKSpriteNode!
    var instructionsNumber = 0
    
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
        
        buffLabel.hidden = true
        countLabel.hidden = true
        fastForwardWhite.hidden = true
        hiddenLabel.hidden = true
        
        self.runAction(SKAction.waitForDuration(1.5), completion: {() -> Void in
            self.instructions.hidden = true
        })
        
        pauseButton.selectedHandler = {
            self.paused = !self.paused
            
            if self.paused {
                self.pauseButton.texture = SKTexture(imageNamed: "rightTriangleWhite")
            }
                
            else if !self.paused {
                self.countLabel.hidden = false
                self.countLabel.text = "3"
                SKAction.waitForDuration(1)
                self.countLabel.text = "2"
                SKAction.waitForDuration(1)
                self.countLabel.text = "1"
                SKAction.waitForDuration(1)
                self.pauseButton.texture = SKTexture(imageNamed: "pauseButtonWhite")
                self.countLabel.hidden = true 
            }
        }
    }
    
    func setBuffLabel () {
        self.buffLabel.text = "2x"
        self.buffLabel.hidden = false
        self.runAction(SKAction.waitForDuration(2), completion: {() -> Void in
            self.buffLabel.hidden = true
        })
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
        case 80:
            scoreLabel.fontColor = UIColor.yellowColor()
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
        self.runAction(SKAction.waitForDuration(1.5), completion: {() -> Void in
            self.fastForwardWhite.hidden = true
        })
    }
    
    func hiddenLabelAnimation () {
        self.hiddenLabel.hidden = false
        self.runAction(SKAction.waitForDuration(4), completion: {() -> Void in
            self.hiddenLabel.hidden = true
        })
    }
    
    func instructionsUpdate() {
        instructionsNumber += 1
        if instructionsNumber > 1 {
            self.instructions.hidden = true
        }
        else if instructionsNumber <= 1 {
            self.runAction(SKAction.waitForDuration(1), completion: {() -> Void in
                self.instructions.text = "Let it go"
                self.instructions.hidden = false
            })
        }
        
    }
    
    func updateScoreLabel (points: Int) {
        scoreLabel.text = "\(points)"
    }
    
}
