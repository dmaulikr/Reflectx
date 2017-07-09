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
        
        smallLeftArrow = childNode(withName: "smallLeftArrow") as! SKSpriteNode
        smallRightArrow = childNode(withName: "smallRightArrow") as! SKSpriteNode
        instructions = childNode(withName: "instructions") as! SKLabelNode
        
        self.run(SKAction.wait(forDuration: 1.3), completion: {() -> Void in
            self.instructions.isHidden = true
        })
        
    }
    
    func hideArrows () {
        smallLeftArrow.isHidden = true
        smallRightArrow.isHidden = true
    }
    
    func instructionsUpdate() {
        instructionsNumber += 1
        if instructionsNumber > 1 {
            self.instructions.isHidden = true
        }
        else if instructionsNumber <= 1 {
            self.run(SKAction.wait(forDuration: 4), completion: {() -> Void in
                self.instructions.text = "Let go to shoot"
                self.instructions.isHidden = false
                self.run(SKAction.wait(forDuration: 4), completion: {() -> Void in
                    self.instructions.isHidden = true
                })
            })
        }
    }
}
