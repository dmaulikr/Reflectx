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
    var soundOn: Bool = true
    var state: GameState = .Title
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    let playSFX = SKAction.playSoundFileNamed("play", waitForCompletion: false)
    
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
        
        soundOn = NSUserDefaults.standardUserDefaults().boolForKey("soundOn")
        
        audioUpdate()
        
        let savedCoins: Int = NSUserDefaults.standardUserDefaults().integerForKey("savedCoins")
        goldNumber.text = "\(savedCoins)"
        
        playButton.selectedHandler = playButtonClicked
        playButtonBack.selectedHandler = playButtonBackClicked
        highScoreButton.selectedHandler = highScoreButtonClicked
        shopButton.selectedHandler = shopButtonClicked
        infoButton.selectedHandler = infoButtonClicked
        tutorialButton.selectedHandler = tutorialButtonClicked
        audioButton.selectedHandler = audioButtonClicked
        rateButton.selectedHandler = rateButtonClicked
        
    }
    
    func rateButtonClicked () {
        if soundOn == true {
            self.runAction(playSFX)
        }
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(1141987144)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!);
    }
    
    func playButtonClicked () {
        
        if soundOn == true {
        self.runAction(playSFX)
        }
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

    func soundOnUpdate() {
        
        NSUserDefaults().setBool(soundOn, forKey: "soundOn")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func audioButtonClicked () {
        self.soundOn = !self.soundOn
        
        audioUpdate()
        if soundOn {
            self.runAction(buttonSFX)
        }
        soundOnUpdate()
    }
    
    func audioUpdate () {
        
        if soundOn {
            self.audioButton.texture = SKTexture(imageNamed: "audioOnWhite")
        }
            
        else {
            self.audioButton.texture = SKTexture(imageNamed: "audioOffWhite")
        }
    }
    
    func playButtonBackClicked () {
        
        if soundOn == true {
            self.runAction(buttonSFX)
        }
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
        
        if soundOn == true {
            self.runAction(buttonSFX)
        }
        self.state = .Browse
        let skView = self.view as SKView!
        let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
        scene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func tutorialButtonClicked () {
        
        if soundOn == true {
            self.runAction(buttonSFX)
        }
        self.state = .Browse
        let skView = self.view as SKView!
        let scene = TutorialScene(fileNamed:"TutorialScene") as TutorialScene!
        scene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func shopButtonClicked () {
        
        if soundOn == true {
            self.runAction(buttonSFX)
        }
        self.state = .Browse
        let skView = self.view as SKView!
        let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
        scene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func infoButtonClicked () {
        
        if soundOn == true {
            self.runAction(buttonSFX)
        }
        self.state = .Browse
        let skView = self.view as SKView!
        let scene = InfoScene(fileNamed:"InfoScene") as InfoScene!
        scene.scaleMode = .AspectFill
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
}


    