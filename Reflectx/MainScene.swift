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
    var playButtonBack: MSButtonNode!
    var highScoreButton: MSButtonNode!
    var rateButton: MSButtonNode!
    var shopButton: MSButtonNode!
    var infoButton: MSButtonNode!
    var tutorialButton: MSButtonNode!
    var audioButton: MSButtonNode!
    var goldNumber: SKLabelNode!
    var audio: Bool = true
    var state: GameState = .Title
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        playButtonBack = self.childNodeWithName("playButtonBack") as! MSButtonNode
        highScoreButton = self.childNodeWithName("highScoreButton") as! MSButtonNode
        rateButton = self.childNodeWithName("rateButton") as! MSButtonNode
        shopButton = self.childNodeWithName("shopButton") as! MSButtonNode
        infoButton = self.childNodeWithName("infoButton") as! MSButtonNode
        tutorialButton = self.childNodeWithName("tutorialButton") as! MSButtonNode
        audioButton = self.childNodeWithName("audioButton") as! MSButtonNode
        goldNumber = self.childNodeWithName("goldNumber") as! SKLabelNode
        
        let savedCoins: Int = NSUserDefaults.standardUserDefaults().integerForKey("savedCoins")
        goldNumber.text = "\(savedCoins)"
        
        playButton.selectedHandler = playButtonClicked
        playButtonBack.selectedHandler = playButtonBackClicked
        highScoreButton.selectedHandler = highScoreButtonClicked
        shopButton.selectedHandler = shopButtonClicked
        infoButton.selectedHandler = infoButtonClicked
        tutorialButton.selectedHandler = tutorialButtonClicked
        audioButton.selectedHandler = audioButtonClicked

    }
    
    func playButtonClicked () {
        
        self.state = .Playing
        let skView = self.view as SKView!
        let scene = GameScene(fileNamed:"GameScene") as GameScene!
        scene.scaleMode = .AspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func audioButtonClicked () {
        audioButton.selectedHandler = {
            self.audio = !self.audio
            
            // set volume for all scenes, save when close app
            
            if self.audio {
                self.audioButton.texture = SKTexture(imageNamed: "audioOnWhite")
            }
                
            else if !self.audio {
                self.audioButton.texture = SKTexture(imageNamed: "audioOffWhite")
            }
        }
    }
    
    func playButtonBackClicked () {
        
        self.state = .Playing
        let skView = self.view as SKView!
        let scene = GameScene(fileNamed:"GameScene") as GameScene!
        scene.scaleMode = .AspectFill
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func highScoreButtonClicked () {
        
        self.state = .Browse
        let skView = self.view as SKView!
        let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
        scene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func tutorialButtonClicked () {
        
        self.state = .Browse
        let skView = self.view as SKView!
        let scene = TutorialScene(fileNamed:"TutorialScene") as TutorialScene!
        scene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func shopButtonClicked () {
        
        self.state = .Browse
        let skView = self.view as SKView!
        let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
        scene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func infoButtonClicked () {
        
        self.state = .Browse
        let skView = self.view as SKView!
        let scene = InfoScene(fileNamed:"InfoScene") as InfoScene!
        scene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
}


    