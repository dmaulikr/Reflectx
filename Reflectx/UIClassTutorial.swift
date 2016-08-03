//
//  UIClass.swift
//  Reflectx
//
//  Created by Jacky Chen on 8/2/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class UIClassTutorial: SKNode{
    
    var instructions: SKLabelNode!
    var smallLeftArrow: SKSpriteNode!
    var smallRightArrow: SKSpriteNode!
    var instructionsNumber = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        smallLeftArrow = childNodeWithName("smallLeftArrow") as! SKSpriteNode
        smallRightArrow = childNodeWithName("smallRightArrow") as! SKSpriteNode
        instructions = childNodeWithName("instructions") as! SKLabelNode
        
        self.runAction(SKAction.waitForDuration(1.8), completion: {() -> Void in
            self.instructions.hidden = true
        })
        
    }
    
    func hideArrows () {
        smallLeftArrow.hidden = true
        smallRightArrow.hidden = true
    }
    
    func instructionsUpdate() {
        instructionsNumber += 1
        if instructionsNumber > 1 {
            self.instructions.hidden = true
        }
        else if instructionsNumber <= 1 {
            self.runAction(SKAction.waitForDuration(3), completion: {() -> Void in
                self.instructions.text = "Let go to shoot"
                self.instructions.hidden = false
                
            })
        }
        
    }
 
}