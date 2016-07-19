//
//  MainScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class MainScene: SKScene {
    
    var playButton: MSButtonNode!
    var leftArrow: MSButtonNode!
    var rightArrow: MSButtonNode!
    var highScoreButton: MSButtonNode!
    var rateButton: MSButtonNode!
    var shopButton: MSButtonNode!
    var infoButton: MSButtonNode!
    var selectLevelBack: MSButtonNode!
    var goldNumber: SKLabelNode!
    var selectLevel: SKLabelNode!
    var state: GameState = .Title
    var index = 0
    let difficulties = ["Easy", "Medium", "Hard"]
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        leftArrow = self.childNodeWithName("leftArrow") as! MSButtonNode
        rightArrow = self.childNodeWithName("rightArrow") as! MSButtonNode
        highScoreButton = self.childNodeWithName("highScoreButton") as! MSButtonNode
        rateButton = self.childNodeWithName("rateButton") as! MSButtonNode
        shopButton = self.childNodeWithName("shopButton") as! MSButtonNode
        infoButton = self.childNodeWithName("infoButton") as! MSButtonNode
        selectLevelBack = self.childNodeWithName("selectLevelBack") as! MSButtonNode
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        selectLevel = self.childNodeWithName("selectLevel") as! SKLabelNode
    
        func playButtonClicked () {
            
            self.state = .Playing
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            skView.presentScene(scene)
            
        }
        
        func highScoreButtonClicked () {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        func shopButtonClicked () {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        func infoButtonClicked () {
            
            self.state = .Browse
            let skView = self.view as SKView!
            let scene = InfoScene(fileNamed:"InfoScene") as InfoScene!
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
        
        func rightArrowClicked () {
            
            self.state = .Browse
            self.index += 1
            if self.index > 2 {
                self.index = 2
            }
            self.selectLevel.text = String(self.difficulties[self.index])
            
        }
        
        func leftArrowClicked () {
            
            self.state = .Browse
            self.index -= 1
            if self.index < 0 {
                self.index = 0
            }
            self.selectLevel.text = String(self.difficulties[self.index])
            
        }
        
        leftArrow.selectedHandler = leftArrowClicked
        rightArrow.selectedHandler = rightArrowClicked
        playButton.selectedHandler = playButtonClicked
        highScoreButton.selectedHandler = highScoreButtonClicked
        shopButton.selectedHandler = shopButtonClicked
        infoButton.selectedHandler = infoButtonClicked

    }
    
}


    