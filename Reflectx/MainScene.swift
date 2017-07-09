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
    var state: GameState = .title
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    let playSFX = SKAction.playSoundFileNamed("play", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
                
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        playButtonBack = self.childNode(withName: "playButtonBack") as! MSButtonNode
        highScoreButton = self.childNode(withName: "highScoreButton") as! MSButtonNode
        rateButton = self.childNode(withName: "rateButton") as! MSButtonNode
        shopButton = self.childNode(withName: "shopButton") as! MSButtonNode
        infoButton = self.childNode(withName: "infoButton") as! MSButtonNode
        tutorialButton = self.childNode(withName: "tutorialButton") as! MSButtonNode
        audioButton = self.childNode(withName: "audioButton") as! MSButtonNode
        goldNumber = self.childNode(withName: "goldNumber") as! SKLabelNode
        
        if UserDefaults.standard.object(forKey: "soundOn") != nil {
            soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        }
        else {
            soundOn = true
        }
        
        audioUpdate()
        soundOnUpdate()
        
        let savedCoins: Int = UserDefaults.standard.integer(forKey: "savedCoins")
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
            self.run(playSFX)
        }
            UIApplication.shared.openURL(URL(string : "itms-apps://itunes.apple.com/app/id1141987144")!);
    }
    
    func playButtonClicked () {
        
        if soundOn == true {
        self.run(playSFX)
        }
        self.state = .playing
        let skView = self.view as SKView!
        let scene = GameScene(fileNamed:"GameScene") as GameScene!
        scene?.scaleMode = .aspectFit
        skView?.showsPhysics = false
        skView?.showsDrawCount = false
        skView?.showsFPS = false
        let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
        skView?.presentScene(scene!, transition: transition)
        
    }

    func soundOnUpdate() {
        
        UserDefaults().set(soundOn, forKey: "soundOn")
        UserDefaults.standard.synchronize()
    }
    
    func audioButtonClicked () {
        self.soundOn = !self.soundOn
        
        audioUpdate()
        if soundOn {
            self.run(buttonSFX)
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
            self.run(buttonSFX)
        }
        self.state = .playing
        let skView = self.view as SKView!
        let scene = GameScene(fileNamed:"GameScene") as GameScene!
        scene?.scaleMode = .aspectFit
        skView?.showsPhysics = false
        skView?.showsDrawCount = false
        skView?.showsFPS = false
        let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
        skView?.presentScene(scene!, transition: transition)
        
    }
    
    func highScoreButtonClicked () {
        
        if soundOn == true {
            self.run(buttonSFX)
        }
        self.state = .browse
        let skView = self.view as SKView!
        let scene = HighScoreScene(fileNamed:"HighScoreScene") as HighScoreScene!
        scene?.scaleMode = .aspectFit
        let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
        skView?.presentScene(scene!, transition: transition)
        
    }
    
    func tutorialButtonClicked () {
        
        if soundOn == true {
            self.run(buttonSFX)
        }
        self.state = .browse
        let skView = self.view as SKView!
        let scene = TutorialScene(fileNamed:"TutorialScene") as TutorialScene!
        scene?.scaleMode = .aspectFit
        let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
        skView?.presentScene(scene!, transition: transition)
        
    }
    
    func shopButtonClicked () {
        
        if soundOn == true {
            self.run(buttonSFX)
        }
        self.state = .browse
        let skView = self.view as SKView!
        let scene = ShopScene(fileNamed:"ShopScene") as ShopScene!
        scene?.scaleMode = .aspectFit
        let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
        skView?.presentScene(scene!, transition: transition)
        
    }
    
    func infoButtonClicked () {
        
        if soundOn == true {
            self.run(buttonSFX)
        }
        self.state = .browse
        let skView = self.view as SKView!
        let scene = InfoScene(fileNamed:"InfoScene") as InfoScene!
        scene?.scaleMode = .aspectFit
        let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
        skView?.presentScene(scene!, transition: transition)
        
    }
}


    
