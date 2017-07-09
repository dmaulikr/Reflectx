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
    let soundOn: Bool = UserDefaults.standard.bool(forKey: "soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        backButton = self.childNode(withName: "backButton") as! MSButtonNode
        
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
        
    }
    
}
