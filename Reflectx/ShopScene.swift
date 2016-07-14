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
    
    var paddlePic: MSButtonNode!
    
    var paddleBox1: MSButtonNode!
    var paddleBox2: MSButtonNode!
    var paddleBox3: MSButtonNode!
    var paddleBox4: MSButtonNode!
    var paddleBox5: MSButtonNode!
    var paddleBox6: MSButtonNode!

    var rectangle1: MSButtonNode!
    var rectangle2: MSButtonNode!
    var rectangle3: MSButtonNode!
    var rectangle4: MSButtonNode!
    var rectangle5: MSButtonNode!
    var rectangle6: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        
        paddlePic = self.childNodeWithName("paddlePic") as! MSButtonNode

        paddleBox1 = self.childNodeWithName("paddleBox1") as! MSButtonNode
        paddleBox2 = self.childNodeWithName("paddleBox2") as! MSButtonNode
        paddleBox3 = self.childNodeWithName("paddleBox3") as! MSButtonNode
        paddleBox4 = self.childNodeWithName("paddleBox4") as! MSButtonNode
        paddleBox5 = self.childNodeWithName("paddleBox5") as! MSButtonNode
        paddleBox6 = self.childNodeWithName("paddleBox6") as! MSButtonNode

        rectangle1 = self.childNodeWithName("rectangle1") as! MSButtonNode
        rectangle2 = self.childNodeWithName("rectangle2") as! MSButtonNode
        rectangle3 = self.childNodeWithName("rectangle3") as! MSButtonNode
        rectangle4 = self.childNodeWithName("rectangle4") as! MSButtonNode
        rectangle5 = self.childNodeWithName("rectangle5") as! MSButtonNode
        rectangle6 = self.childNodeWithName("rectangle6") as! MSButtonNode
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
    }
    
}