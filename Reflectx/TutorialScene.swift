//
//  TutorialScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene {
    
    var homeButton: MSButtonNode!
    
    override func didMoveToView(view: SKView) {
        
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        
        homeButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
    }
    
}