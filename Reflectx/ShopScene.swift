//
//  ShopScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class ShopScene: SKScene {
    
    var backButton: MSButtonNode!
    var paddleBox1: MSButtonNode!
    var paddleBox2: MSButtonNode!
    var paddleBox3: MSButtonNode!
    var paddleBox4: MSButtonNode!
    var paddleBox5: MSButtonNode!
    var paddleBox6: MSButtonNode!
    var rectangleBlue: MSButtonNode!
    var rectangleGreen: MSButtonNode!
    var rectangleYellow: MSButtonNode!
    var rectangleRed: MSButtonNode!
    var rectangleBlue2: MSButtonNode!
    var rectangleGreen2: MSButtonNode!
    
    var checkMark: SKSpriteNode!
    
    var goldNumber: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        paddleBox1 = self.childNodeWithName("paddleBox1") as! MSButtonNode
        paddleBox2 = self.childNodeWithName("paddleBox2") as! MSButtonNode
        paddleBox3 = self.childNodeWithName("paddleBox3") as! MSButtonNode
        paddleBox4 = self.childNodeWithName("paddleBox4") as! MSButtonNode
        paddleBox5 = self.childNodeWithName("paddleBox5") as! MSButtonNode
        paddleBox6 = self.childNodeWithName("paddleBox6") as! MSButtonNode
        rectangleBlue = self.childNodeWithName("rectangleBlue") as! MSButtonNode
        rectangleGreen = self.childNodeWithName("rectangleGreen") as! MSButtonNode
        rectangleYellow = self.childNodeWithName("rectangleYellow") as! MSButtonNode
        rectangleRed = self.childNodeWithName("rectangleRed") as! MSButtonNode
        rectangleBlue2 = self.childNodeWithName("rectangleBlue2") as! MSButtonNode
        rectangleGreen2 = self.childNodeWithName("rectangleGreen2") as! MSButtonNode
        
        checkMark = self.childNodeWithName("checkMark") as! SKSpriteNode
        
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
    }
    
}