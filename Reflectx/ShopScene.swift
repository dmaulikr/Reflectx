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
    var greenBought = 0
    var yellowBought = 0
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
        
        var savedCoins3: Int = NSUserDefaults.standardUserDefaults().integerForKey("savedCoins2")
        goldNumber.text = "\(savedCoins3)"
        
        paddleSelected = NSUserDefaults.standardUserDefaults().integerForKey("paddleSelected2")
        greenBought = NSUserDefaults.standardUserDefaults().integerForKey("greenBought2")
        yellowBought = NSUserDefaults.standardUserDefaults().integerForKey("yellowBought2")
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        // fix pause button
        // save greenbought & yellowbought 
        // fix savedCoins minus
        
        rectangleBlue.selectedHandler = {
            self.paddleSelected = 0
            self.paddleSelectedUpdate()
        }
        
        rectangleGreen.selectedHandler = {
            if savedCoins3 >= 10 {
                if self.greenBought == 0 {
                    savedCoins3 -= 10
                    self.greenBought = 1
                    self.paddleSelected = 1
                    self.paddleSelectedUpdate()
                }
                else if self.greenBought == 1 {
                    self.paddleSelected = 1
                    self.paddleSelectedUpdate()
                }
            }
            
        }
        
        rectangleYellow.selectedHandler = {
            if savedCoins3 >= 10 {
                if self.yellowBought == 0 {
                    savedCoins3 -= 10
                    self.yellowBought = 1
                    self.paddleSelected = 2
                    self.paddleSelectedUpdate()
                }
                else if self.yellowBought == 1 {
                    self.paddleSelected = 2
                    self.paddleSelectedUpdate()
                }
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
    
    func paddleSelectedUpdate() {
        let paddleSelected2 = NSUserDefaults().integerForKey("paddleSelected2")
        if paddleSelected != paddleSelected2 {
            NSUserDefaults().setInteger(paddleSelected, forKey: "paddleSelected2")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func greenBoughtUpdate() {
        let greenBought2 = NSUserDefaults().integerForKey("greenBought2")
        if greenBought != greenBought2 {
            NSUserDefaults().setInteger(greenBought, forKey: "greenBought2")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func yellowBoughtUpdate() {
        let yellowBought2 = NSUserDefaults().integerForKey("yellowBought2")
        if yellowBought != yellowBought2 {
            NSUserDefaults().setInteger(yellowBought, forKey: "yellowBought2")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    
}