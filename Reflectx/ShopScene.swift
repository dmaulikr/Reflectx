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
    var checkMarks: [SKSpriteNode] = []
    var greenBought : Bool = false
    var redBought: Bool = false
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
    var paddleGreenPic: SKSpriteNode!
    var paddleRedPic: SKSpriteNode!
    let soundOn: Bool = NSUserDefaults.standardUserDefaults().boolForKey("soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        paddleBoxBlue = self.childNodeWithName("paddleBoxBlue") as! MSButtonNode
        paddleBoxGreen = self.childNodeWithName("paddleBoxGreen") as! MSButtonNode
        paddleBoxRed = self.childNodeWithName("paddleBoxRed") as! MSButtonNode
        paddleBoxYellow = self.childNodeWithName("paddleBoxYellow") as! MSButtonNode
        paddleBoxBlue2 = self.childNodeWithName("paddleBoxBlue2") as! MSButtonNode
        paddleBoxGreen2 = self.childNodeWithName("paddleBoxGreen2") as! MSButtonNode
        for index in 1...6 {
            checkMarks.append(self.childNodeWithName("checkMark\(index)") as! SKSpriteNode)
        }
        ten = paddleBoxGreen.childNodeWithName("ten") as! SKLabelNode
        twenty = paddleBoxRed.childNodeWithName("twenty") as! SKLabelNode
        forty = paddleBoxYellow.childNodeWithName("forty") as! SKLabelNode
        eighty = paddleBoxBlue2.childNodeWithName("eighty") as! SKLabelNode
        twoHundred = paddleBoxGreen2.childNodeWithName("twoHundred") as! SKLabelNode
        smallGold2 = paddleBoxGreen.childNodeWithName("smallGold2") as! SKSpriteNode
        smallGold3 = paddleBoxRed.childNodeWithName("smallGold3") as! SKSpriteNode
        smallGold4 = paddleBoxYellow.childNodeWithName("smallGold4") as! SKSpriteNode
        smallGold5 = paddleBoxBlue2.childNodeWithName("smallGold5") as! SKSpriteNode
        smallGold6 = paddleBoxGreen2.childNodeWithName("smallGold6") as! SKSpriteNode
        paddleGreenPic = paddleBoxGreen.childNodeWithName("paddleGreenPic") as! SKSpriteNode
        paddleRedPic = paddleBoxRed.childNodeWithName("paddleRedPic") as! SKSpriteNode
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        
        var savedCoins: Int = NSUserDefaults.standardUserDefaults().integerForKey("savedCoins")
        goldNumber.text = "\(savedCoins)"
        
        paddleSelected = Constants.PaddleColor(rawValue: NSUserDefaults.standardUserDefaults().integerForKey("paddleSelected"))!
        greenBought = NSUserDefaults.standardUserDefaults().boolForKey("greenBought")
        redBought = NSUserDefaults.standardUserDefaults().boolForKey("redBought")
        
        self.paddleGreenPic.hidden = true
        self.paddleRedPic.hidden = true
        
        backButton.selectedHandler = {
            
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFit
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        func updateCheckMark () {
            for index in 0...5 {
                let checkMark = checkMarks[index]
                if paddleSelected.rawValue == index {
                    checkMark.hidden = false
                }
                else {
                    checkMark.hidden = true
                }
            }
        }
        
        updateCheckMark()
        if redBought {
            self.redBoughtUpdate()
        }
        if greenBought {
            self.greenBoughtUpdate()
        }
        self.paddleSelectedUpdate()
        
        paddleBoxBlue.selectedHandler = {
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            self.paddleSelected = .Blue
            updateCheckMark()
            self.paddleSelectedUpdate()
        }
        
        paddleBoxGreen.selectedHandler = {
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            if savedCoins >= 10 && !self.greenBought {
                savedCoins -= 10
                self.goldNumber.text = "\(savedCoins)"
                NSUserDefaults.standardUserDefaults().setInteger(savedCoins, forKey: Constants.savedCoins)
                self.greenBought = true
                self.paddleSelected = .Green
                updateCheckMark()
                self.greenBoughtUpdate()
                self.paddleSelectedUpdate()
            }
            else if self.greenBought {
                self.paddleSelected = .Green
                updateCheckMark()
                self.greenBoughtUpdate()
                self.paddleSelectedUpdate()
            }
        }
        
        paddleBoxRed.selectedHandler = {
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            if savedCoins >= 20 && !self.redBought {
                    savedCoins -= 20
                    self.goldNumber.text = "\(savedCoins)"
                    NSUserDefaults.standardUserDefaults().setInteger(savedCoins, forKey: Constants.savedCoins)
                    self.redBought = true
                    self.paddleSelected = .Red
                    updateCheckMark()
                    self.redBoughtUpdate()
                    self.paddleSelectedUpdate()
            }
            else if self.redBought == true {
                self.paddleSelected = .Red
                updateCheckMark()
                self.redBoughtUpdate()
                self.paddleSelectedUpdate()
            }
        }
        
        
        paddleBoxYellow.selectedHandler = {
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            if savedCoins >= 40 {
                
            }
        }
        
        paddleBoxBlue2.selectedHandler = {
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            if savedCoins >= 80 {
                
            }
        }
        
        paddleBoxGreen2.selectedHandler = {
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            if savedCoins >= 200 {
                
            }
        }
    }
    
    func paddleSelectedUpdate() {
        NSUserDefaults().setInteger(paddleSelected.rawValue, forKey: "paddleSelected")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func greenBoughtUpdate() {
        NSUserDefaults().setBool(greenBought, forKey: "greenBought")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.ten.hidden = true
        self.smallGold2.hidden = true
        self.paddleGreenPic.hidden = false
    }
    
    func redBoughtUpdate() {
        NSUserDefaults().setBool(redBought, forKey: "redBought")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.twenty.hidden = true
        self.smallGold3.hidden = true
        self.paddleRedPic.hidden = false
        
    }
    
}