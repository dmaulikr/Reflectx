//
//  TutorialScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit
import AVFoundation

class TutorialScene: SKScene, SKPhysicsContactDelegate {
    
    var state: GameState = .title
    var wavesNumber = 0
    var wavesDoneNumber = 0
    var health: Int = 1
    var points = 0
    var homeButton: MSButtonNode!
    var paddle: SKSpriteNode!
    var sinceTouch : CFTimeInterval = 0
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0 // 60 FPS, fix later on (phones with 40 fps etc)
    var isFingerOnPaddle = false
    var waveFinished: Bool = true
    var hitFirstDoubleScore: Bool = false
    let paddleName: String = "paddle"
    let popSFX = SKAction.playSoundFileNamed("pop", waitForCompletion: false)
    let pop2SFX = SKAction.playSoundFileNamed("pop2", waitForCompletion: false)
    let successSFX = SKAction.playSoundFileNamed("success", waitForCompletion: false)
    var bulletJoint: SKPhysicsJoint?
    var obstacleLayer: SKNode!
    var UILayer2: UIClassTutorial!
    var playButton2: MSButtonNode!
    var playButtonBack2: MSButtonNode!
    let soundOn: Bool = UserDefaults.standard.bool(forKey: "soundOn")
    let buttonSFX = SKAction.playSoundFileNamed("button1", waitForCompletion: false)
    var player = AVAudioPlayer()
    var nowPlaying = false
    
    override func didMove(to view: SKView) {
        /* Set up your scene here */
        
        physicsWorld.contactDelegate = self
        paddle = self.childNode(withName: "//paddle") as! SKSpriteNode
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        UILayer2 = self.childNode(withName: "UI") as! UIClassTutorial
        homeButton = self.childNode(withName: "homeButton") as! MSButtonNode
        playButton2 = self.childNode(withName: "playButton2") as! MSButtonNode
        playButtonBack2 = self.childNode(withName: "playButtonBack2") as! MSButtonNode
        
        let urlPath = Bundle.main.url(forResource: "music2", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: urlPath!)
        
        homeButton.selectedHandler = {
            
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            self.player.pause()
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
        }
        
        playButton2.selectedHandler = {
            
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            self.player.pause()
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
            
        }
        
        playButtonBack2.selectedHandler = {
            
            if self.soundOn {
                self.run(self.buttonSFX)
            }
            self.player.pause()
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene?.scaleMode = .aspectFit
            let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
            skView?.presentScene(scene!, transition: transition)
            
        }
        
        playButton2.isHidden = true
        playButtonBack2.isHidden = true
        
        self.state = .playing
        
        if self.soundOn {
            player.play()
        }
        else {
            player.pause()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if state == .gameOver || state == .title { return }
        
        state = .playing
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if atPoint(touchLocation).name == paddleName {
            
            isFingerOnPaddle = true
            
            /* Reset touch timer */
            sinceTouch = 0
            
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isFingerOnPaddle {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            let paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
            
            UILayer2.hideArrows ()
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
        
        if let bulletJoint = bulletJoint {
            
            if let bullet = bulletJoint.bodyA.node as? Bullet {
                bullet.physicsBody?.velocity = CGVector(dx: 0, dy: 650)
            }
                
            else if let bullet = bulletJoint.bodyB.node as? Bullet {
                bullet.physicsBody?.velocity = CGVector(dx: 0, dy: 650)
            }
            
            physicsWorld.remove(bulletJoint)
            self.bulletJoint = nil
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if state != .playing {
            return
        }
        
        /* Update last touch timer */
        sinceTouch+=fixedDelta
        
        /* Process obstacles */
        
        // stage 1
        if wavesNumber < 1 {
            spawnNewWave()
        }
        
        // stage 2
        if wavesNumber == 1 {
            spawnNewWave2()
        }
        
        if wavesNumber == 2 {
            spawnNewWave3()
        }
        
        updateObstacles()
        
        if points == 8 {
            gameDone()
        }
        
        spawnTimer += fixedDelta
        
        if health <= 0 {
            gameOver()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        
        /* Get references to the bodies involved in the collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        if bulletJoint == nil {
            if (contactA.categoryBitMask == PaddleCategory && contactB.categoryBitMask == BulletCategory) || (contactA.categoryBitMask == BulletCategory && contactB.categoryBitMask == PaddleCategory) {
                
                if let bullet = nodeA as? Bullet {
                    addBulletJoint(bullet)
                }
                else if let bullet = nodeB as? Bullet {
                    addBulletJoint(bullet)
                }
            }
        }
        
        /* Check if either physics bodies was an enemy */
        if contactA.categoryBitMask == EnemyCategory || contactB.categoryBitMask == EnemyCategory {
            
            if let enemy = nodeA as? Enemy {
                if let shootable = nodeB as? Shootable {
                    collisionCheck(enemy, shootable: shootable)
                }
            }
            else if let enemy = nodeB as? Enemy {
                if let shootable = nodeA as? Shootable {
                    collisionCheck(enemy, shootable: shootable)
                }
            }
        }
    }
    
    func collisionCheck (_ enemy: Enemy, shootable: Shootable) {
        if enemy.shootable != shootable {
            return
        }
        points += 1
        if self.soundOn {
        self.run(popSFX)
        }
        dieEnemy(enemy)
        dieEnemy(shootable)
    }
    
    func addBulletJoint (_ bullet: Bullet) {
        bullet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bulletJoint = SKPhysicsJointPin.joint(withBodyA: paddle.physicsBody!, bodyB: bullet.physicsBody!, anchor: bullet.position)
        
        physicsWorld.add(bulletJoint!)
    }
    
    func dieEnemy(_ node: SKNode) {
        /* Enemy death*/
        node.removeFromParent()
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        for obstacle in obstacleLayer.children as! [SKSpriteNode] {
            
            if let bullet = obstacle as? Bullet {
                
                if bullet.position.y <= 70 || bullet.position.y > 660  {
                    health -= 1
                    if self.soundOn {
                    self.run(pop2SFX)
                    }
                }
                bullet.updateBulletSpeedSlow(self.wavesNumber)
            }
                
            else if let enemy = obstacle as? Enemy {
                if enemy.position.y < 180 {
                    health -= 1
                    if self.soundOn {
                    self.run(pop2SFX)
                    }
                }
                //ball.updateEnemySpeed(self.wavesNumber)
            }
                
            else if let ball = obstacle as? Ball {
                if ball.position.y <= 70 {
                    health -= 1
                    if self.soundOn {
                    self.run(pop2SFX)
                    }
                }
                //ball.updateBallSpeed(self.wavesNumber)
            }
        }
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .restart
        player.pause()
        let skView = self.view as SKView!
        let scene = TutorialScene(fileNamed:"TutorialScene") as TutorialScene!
        scene?.scaleMode = .aspectFit
        if self.soundOn {
        self.run(pop2SFX)
        }
        let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
        skView?.presentScene(scene!, transition: transition)

    }
    
    func gameDone() {
        playButton2.isHidden = false
        playButtonBack2.isHidden = false
    }
    
    func spawnNewWave(){
        if spawnTimer >= 3 && waveFinished {
            
            wave1()
            spawnTimer = 0
            
        }
    }
    
    func spawnNewWave2(){
        
        if spawnTimer >= 4 {
            UILayer2.instructionsUpdate()
        } 
        
        if spawnTimer >= 5 && waveFinished {
            
            wave2()
            spawnTimer = 0
            
        }
    }
    
    func spawnNewWave3(){
        if spawnTimer >= 3 && waveFinished {
            
            wave3()
            spawnTimer = 0
            
        }
    }
    
    func createBallGroup(_ position: CGPoint){
        let newBall = createBall(position)
        let newEnemy = Enemy(imageName: "cloud")
        let enemyPosition = CGPoint (x: newBall.position.x+0, y: newBall.position.y+100)
        newEnemy.position = enemyPosition
        obstacleLayer.addChild(newEnemy)
        newEnemy.goDown(wavesNumber)
        newEnemy.shootable = newBall
    }
    
    func createBulletGroup(_ position: CGPoint) -> Enemy{
        let bullet = createBullet(position)
        let enemy = createEnemy(CGPoint(x: bullet.position.x+40, y: bullet.position.y+100))
        enemy.shootable = bullet
        return enemy
    }
    
    func createBall(_ position: CGPoint) -> Ball {
        let newBall = Ball()
        newBall.position = position
        obstacleLayer.addChild(newBall)
        return newBall
    }
    
    func createBullet(_ position: CGPoint) -> Bullet {
        let newBullet = Bullet(waveNumber: wavesNumber)
        newBullet.position = position
        obstacleLayer.addChild(newBullet)
        return newBullet
    }
    
    func createEnemy(_ position: CGPoint) -> Enemy {
        let newEnemy = Enemy(imageName: "wingMan3")
        newEnemy.position = position
        obstacleLayer.addChild(newEnemy)
        return newEnemy
    }
    
    func wave1() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 150, 240, 140, 190]
        var index = 0
        let wait = SKAction.wait(forDuration: 1.6)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait, run, wait, run, wait, run, run, finish]))
        
    }
    
    func wave2() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 155]
        var index = 0
        let wait = SKAction.wait(forDuration: 4.5)
        
        let run = SKAction.run {
            
            let enemy = self.createBulletGroup(CGPoint(x: wavePositionsX[index], y: 650))
            
            enemy.goDownSlow()
            
            index += 1
        }
        
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait, run, wait, finish]))
        
    }
    
    func wave3() {
        
        self.waveFinished = false
        
        let run = SKAction.run {
            let enemy = self.createBulletGroup(CGPoint(x: 240, y: 490))
            enemy.goLeftSlow()
        }
        
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, finish]))
        
    }
    
    
}


