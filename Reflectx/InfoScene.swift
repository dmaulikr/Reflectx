//
//  InfoScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class InfoScene: SKScene {
    
    var backButton: MSButtonNode!
    let soundOn: Bool = NSUserDefaults.standardUserDefaults().boolForKey("soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        
        backButton.selectedHandler = {
            
            if self.soundOn {
                self.runAction(self.buttonSFX)
            }
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
    }
    
}