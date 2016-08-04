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
    var rectangleBlue: MSButtonNode!
    var rectangleGreen: MSButtonNode!
    var rectangleYellow: MSButtonNode!
    var rectangleRed: MSButtonNode!
    var rectangleBlue2: MSButtonNode!
    var rectangleGreen2: MSButtonNode!
    var paddleSelected = 0
    
    var checkMark: SKSpriteNode!
    
    var goldNumber: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        rectangleBlue = self.childNodeWithName("rectangleBlue") as! MSButtonNode
        rectangleGreen = self.childNodeWithName("rectangleGreen") as! MSButtonNode
        rectangleYellow = self.childNodeWithName("rectangleYellow") as! MSButtonNode
        rectangleRed = self.childNodeWithName("rectangleRed") as! MSButtonNode
        rectangleBlue2 = self.childNodeWithName("rectangleBlue2") as! MSButtonNode
        rectangleGreen2 = self.childNodeWithName("rectangleGreen2") as! MSButtonNode
        
        checkMark = self.childNodeWithName("checkMark") as! SKSpriteNode
        
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        
        let savedCoins3: Int = NSUserDefaults.standardUserDefaults().objectForKey("savedCoins2") as! Int
        goldNumber.text = "\(savedCoins3)"
        
        paddleSelected = NSUserDefaults.standardUserDefaults().integerForKey("paddleSelected2")
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        rectangleBlue.selectedHandler = {

        }
        
        rectangleGreen.selectedHandler = {
            if savedCoins3 >= 10 {
                
            }
        }
        
        rectangleYellow.selectedHandler = {
            if savedCoins3 >= 20 {
                
            }
        }
        
        rectangleRed.selectedHandler = {
            if savedCoins3 >= 40 {
                
            }
        }
        
        rectangleBlue2.selectedHandler = {
            if savedCoins3 >= 80 {
                
            }
        }
        
        rectangleGreen2.selectedHandler = {
            if savedCoins3 >= 200 {
                
            }
        }
    
    }
        
}