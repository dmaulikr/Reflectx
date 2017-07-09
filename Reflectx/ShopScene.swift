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
    var paddleSelected : Constants.PaddleColor = .blue
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
    let soundOn: Bool = UserDefaults.standard.bool(forKey: "soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        backButton = self.childNode(withName: "backButton") as! MSButtonNode
        paddleBoxBlue = self.childNode(withName: "paddleBoxBlue") as! MSButtonNode
        paddleBoxGreen = self.childNode(withName: "paddleBoxGreen") as! MSButtonNode
        paddleBoxRed = self.childNode(withName: "paddleBoxRed") as! MSButtonNode
        paddleBoxYellow = self.childNode(withName: "paddleBoxYellow") as! MSButtonNode
        paddleBoxBlue2 = self.childNode(withName: "paddleBoxBlue2") as! MSButtonNode
        paddleBoxGreen2 = self.childNode(withName: "paddleBoxGreen2") as! MSButtonNode
        for index in 1...6 {
            checkMarks.append(self.childNode(withName: "checkMark\(index)") as! SKSpriteNode)
        }
        ten = paddleBoxGreen.childNode(withName: "ten") as! SKLabelNode
        twenty = paddleBoxRed.childNode(withName: "twenty") as! SKLabelNode
        forty = paddleBoxYellow.childNode(withName: "forty") as! SKLabelNode
        eighty = paddleBoxBlue2.childNode(withName: "eighty") as! SKLabelNode
        twoHundred = paddleBoxGreen2.childNode(withName: "twoHundred") as! SKLabelNode
        smallGold2 = paddleBoxGreen.childNode(withName: "smallGold2") as! SKSpriteNode
        smallGold3 = paddleBoxRed.childNode(withName: "smallGold3") as! SKSpriteNode
        smallGold4 = paddleBoxYellow.childNode(withName: "smallGold4") as! SKSpriteNode
        smallGold5 = paddleBoxBlue2.childNode(withName: "smallGold5") as! SKSpriteNode
        smallGold6 = paddleBoxGreen2.childNode(withName: "smallGold6") as! SKSpriteNode
        paddleGreenPic = paddleBoxGreen.childNode(withName: "paddleGreenPic") as! SKSpriteNode
        paddleRedPic = paddleBoxRed.childNode(withName: "paddleRedPic") as! SKSpriteNode
        goldNumber = self.childNode(withName: "goldNumber") as! SKLabelNode
        
        var savedCoins: Int = UserDefaults.standard.integer(forKey: "savedCoins")
        goldNumber.text = "\(savedCoins)"
        
        paddleSelected = Constants.PaddleColor(rawValue: UserDefaults.standard.integer(forKey: "paddleSelected"))!
        greenBought = UserDefaults.standard.bool(forKey: "greenBought")
        redBought = UserDefaults.standard.bool(forKey: "redBought")
        
        self.paddleGreenPic.isHidden = true
        self.paddleRedPic.isHidden = true
        
        backButton.selectedHandler = {
            
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
            
        }
        
        func updateCheckMark () {
            for index in 0...5 {
                let checkMark = checkMarks[index]
                if paddleSelected.rawValue == index {
                    checkMark.isHidden = false
                }
                else {
                    checkMark.isHidden = true
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
                self.run(self.buttonSFX)
            }
            self.paddleSelected = .blue
            updateCheckMark()
            self.paddleSelectedUpdate()
        }
        
        paddleBoxGreen.selectedHandler = {
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            if savedCoins >= 10 && !self.greenBought {
                savedCoins -= 10
                self.goldNumber.text = "\(savedCoins)"
                UserDefaults.standard.set(savedCoins, forKey: Constants.savedCoins)
                self.greenBought = true
                self.paddleSelected = .green
                updateCheckMark()
                self.greenBoughtUpdate()
                self.paddleSelectedUpdate()
            }
            else if self.greenBought {
                self.paddleSelected = .green
                updateCheckMark()
                self.greenBoughtUpdate()
                self.paddleSelectedUpdate()
            }
        }
        
        paddleBoxRed.selectedHandler = {
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            if savedCoins >= 20 && !self.redBought {
                    savedCoins -= 20
                    self.goldNumber.text = "\(savedCoins)"
                    UserDefaults.standard.set(savedCoins, forKey: Constants.savedCoins)
                    self.redBought = true
                    self.paddleSelected = .red
                    updateCheckMark()
                    self.redBoughtUpdate()
                    self.paddleSelectedUpdate()
            }
            else if self.redBought == true {
                self.paddleSelected = .red
                updateCheckMark()
                self.redBoughtUpdate()
                self.paddleSelectedUpdate()
            }
        }
        
        
        paddleBoxYellow.selectedHandler = {
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            if savedCoins >= 40 {
                
            }
        }
        
        paddleBoxBlue2.selectedHandler = {
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            if savedCoins >= 80 {
                
            }
        }
        
        paddleBoxGreen2.selectedHandler = {
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            if savedCoins >= 200 {
                
            }
        }
    }
    
    func paddleSelectedUpdate() {
        UserDefaults().set(paddleSelected.rawValue, forKey: "paddleSelected")
        UserDefaults.standard.synchronize()
    }
    
    func greenBoughtUpdate() {
        UserDefaults().set(greenBought, forKey: "greenBought")
        UserDefaults.standard.synchronize()
        self.ten.isHidden = true
        self.smallGold2.isHidden = true
        self.paddleGreenPic.isHidden = false
    }
    
    func redBoughtUpdate() {
        UserDefaults().set(redBought, forKey: "redBought")
        UserDefaults.standard.synchronize()
        self.twenty.isHidden = true
        self.smallGold3.isHidden = true
        self.paddleRedPic.isHidden = false
        
    }
    
}
