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
    var tutorialButton: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        
        backButton = self.childNodeWithName("backButton") as! MSButtonNode
        tutorialButton = self.childNodeWithName("tutorialButton") as! MSButtonNode
        
        backButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        tutorialButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = TutorialScene(fileNamed:"TutorialScene") as TutorialScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
    }
    
}