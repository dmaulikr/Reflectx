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
    var paddleBluePic: MSButtonNode!
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
    var smallGold2: SKSpriteNode!
    var smallGold3: SKSpriteNode!
    var smallGold4: SKSpriteNode!
    var smallGold5: SKSpriteNode!
    var smallGold6: SKSpriteNode!
    
    var goldNumber: SKLabelNode!
    var ten: SKLabelNode!
    var twenty: SKLabelNode!
    var forty: SKLabelNode!
    var eighty: SKLabelNode!
    var twoHundred: SKLabelNode!
    var storeBlue: SKLabelNode!
    var storeGreen: SKLabelNode!
    var storeYellow: SKLabelNode!
    var storeRed: SKLabelNode!
    var storeNeonGreen: SKLabelNode!
    var storeRainbow: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        paddleBluePic = self.childNodeWithName("paddleBluePic") as! MSButtonNode
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
        smallGold2 = self.childNodeWithName("smallGold2") as! SKSpriteNode
        smallGold3 = self.childNodeWithName("smallGold3") as! SKSpriteNode
        smallGold4 = self.childNodeWithName("smallGold4") as! SKSpriteNode
        smallGold5 = self.childNodeWithName("smallGold5") as! SKSpriteNode
        smallGold6 = self.childNodeWithName("smallGold6") as! SKSpriteNode
        
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        ten = self.childNodeWithName("ten") as! SKLabelNode
        twenty = self.childNodeWithName("twenty") as! SKLabelNode
        forty = self.childNodeWithName("forty") as! SKLabelNode
        eighty = self.childNodeWithName("eighty") as! SKLabelNode
        twoHundred = self.childNodeWithName("twoHundred") as! SKLabelNode
        storeBlue = self.childNodeWithName("storeBlue") as! SKLabelNode
        storeGreen = self.childNodeWithName("storeGreen") as! SKLabelNode
        storeYellow = self.childNodeWithName("storeYellow") as! SKLabelNode
        storeRed = self.childNodeWithName("storeRed") as! SKLabelNode
        storeNeonGreen = self.childNodeWithName("storeNeonGreen") as! SKLabelNode
        storeRainbow = self.childNodeWithName("storeRainbow") as! SKLabelNode
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
    }
    
}