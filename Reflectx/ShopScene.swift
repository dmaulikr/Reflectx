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
    var paddleBoxBlue: MSButtonNode!
    var paddleBoxGreen: MSButtonNode!
    var paddleBoxRed: MSButtonNode!
    var paddleBoxYellow: MSButtonNode!
    var paddleBoxBlue2: MSButtonNode!
    var paddleBoxGreen2: MSButtonNode!
    var paddleSelected : Constants.PaddleColor = .Blue
    var checkMark: SKSpriteNode!
    var greenBought = 0
    var redBought = 0
    var goldNumber: SKLabelNode!
    var ten: SKLabelNode!
    var twenty: SKLabelNode!
    var forty: SKLabelNode!
    var eighty: SKLabelNode!
    var twoHundred: SKLabelNode!
    var smallGold2: SKSpriteNode!
    var smallGold3: SKSpriteNode!
    var smallGold4: SKSpriteNode!
    var smallGold5: SKSpriteNode!
    var smallGold6: SKSpriteNode!

    // shop, show paddle when clicked/bought etc, checkmark
    // hide all other paddles
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        paddleBoxBlue = self.childNodeWithName("paddleBoxBlue") as! MSButtonNode
        paddleBoxGreen = self.childNodeWithName("paddleBoxGreen") as! MSButtonNode
        paddleBoxRed = self.childNodeWithName("paddleBoxRed") as! MSButtonNode
        paddleBoxYellow = self.childNodeWithName("paddleBoxYellow") as! MSButtonNode
        paddleBoxBlue2 = self.childNodeWithName("paddleBoxBlue2") as! MSButtonNode
        paddleBoxGreen2 = self.childNodeWithName("paddleBoxGreen2") as! MSButtonNode
        checkMark = self.childNodeWithName("checkMark") as! SKSpriteNode
        ten = self.childNodeWithName("ten") as! SKLabelNode
        twenty = self.childNodeWithName("twenty") as! SKLabelNode
        forty = self.childNodeWithName("forty") as! SKLabelNode
        eighty = self.childNodeWithName("eighty") as! SKLabelNode
        twoHundred = self.childNodeWithName("twoHundred") as! SKLabelNode
        smallGold2 = self.childNodeWithName("smallGold2") as! SKSpriteNode
        smallGold3 = self.childNodeWithName("smallGold3") as! SKSpriteNode
        smallGold4 = self.childNodeWithName("smallGold4") as! SKSpriteNode
        smallGold5 = self.childNodeWithName("smallGold5") as! SKSpriteNode
        smallGold6 = self.childNodeWithName("smallGold6") as! SKSpriteNode
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        
        var savedCoins: Int = NSUserDefaults.standardUserDefaults().integerForKey("savedCoins")
        goldNumber.text = "\(savedCoins)"
        
        paddleSelected = Constants.PaddleColor(rawValue: NSUserDefaults.standardUserDefaults().integerForKey("paddleSelected"))!
        greenBought = NSUserDefaults.standardUserDefaults().integerForKey("greenBought")
        redBought = NSUserDefaults.standardUserDefaults().integerForKey("redBought")
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        // save greenbought & yellowbought
        // fix savedCoins minus
        
        paddleBoxBlue.selectedHandler = {
            self.paddleSelected = .Blue
            self.paddleSelectedUpdate()
        }
        
        paddleBoxGreen.selectedHandler = {
            if savedCoins >= 10 {
                if self.greenBought == 0 {
                    savedCoins -= 10
                    self.goldNumber.text = "\(savedCoins)"
                    NSUserDefaults.standardUserDefaults().setInteger(savedCoins, forKey: Constants.savedCoins)
                    self.greenBought = 1
                    self.greenBoughtUpdate()
                    self.paddleSelected = .Green
                    self.paddleSelectedUpdate()
                }
                else if self.greenBought == 1 {
                    self.paddleSelected = .Green
                    self.paddleSelectedUpdate()
                }
            }
            
        }
        
        paddleBoxRed.selectedHandler = {
            if savedCoins >= 20 {
                if self.redBought == 0 {
                    savedCoins -= 20
                    self.goldNumber.text = "\(savedCoins)"
                    NSUserDefaults.standardUserDefaults().setInteger(savedCoins, forKey: Constants.savedCoins)
                    self.redBought = 1
                    self.redBoughtUpdate()
                    self.paddleSelected = .Red
                    self.paddleSelectedUpdate()
                }
                else if self.redBought == 1 {
                    self.paddleSelected = .Red
                    self.paddleSelectedUpdate()
                }
            }
        }
        
        
        paddleBoxYellow.selectedHandler = {
            if savedCoins >= 40 {
                
            }
        }
        
        paddleBoxBlue2.selectedHandler = {
            if savedCoins >= 80 {
                
            }
        }
        
        paddleBoxGreen2.selectedHandler = {
            if savedCoins >= 200 {
                
            }
        }
    }
    
    func paddleSelectedUpdate() {
        NSUserDefaults().setInteger(paddleSelected.rawValue, forKey: "paddleSelected")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func greenBoughtUpdate() {
            NSUserDefaults().setInteger(greenBought, forKey: "greenBought")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.ten.hidden = true
            self.smallGold2.hidden = true
    }
    
    func redBoughtUpdate() {
            NSUserDefaults().setInteger(redBought, forKey: "redBought")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.twenty.hidden = true
            self.smallGold3.hidden = true
    }
    
    
}