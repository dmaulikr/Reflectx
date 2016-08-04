//
//  GameScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright (c) 2016 Jacky. All rights reserved.
//

import SpriteKit

enum GameState {
    case Title, Browse, Playing, GameOver, Restart
}

public let BallTwoCategory : UInt32 = 16
public let BulletCategory : UInt32 = 8
public let BallCategory : UInt32 = 4
public let EnemyCategory : UInt32 = 2
public let PaddleCategory : UInt32 = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundMusic: SKAudioNode!
    var sinceTouch : CFTimeInterval = 0
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0 // 60 FPS, fix later on (phones with 40 fps etc)
    var obstacleLayer: SKNode!
    var music: SKNode!
    var wavesDone = 0
    var wavesDoneNumber = 0
    var savedGames = 0
    var savedCoins = 0
    var points = 0
    var pointsNumber = 0
    var musicNumber = 0
    var health: Int = 1
    var isFingerOnPaddle = false
    var state: GameState = .Title
    let paddleName: String = "paddle"
    let popSFX = SKAction.playSoundFileNamed("pop", waitForCompletion: false)
    let pop2SFX = SKAction.playSoundFileNamed("pop2", waitForCompletion: false)
    let successSFX = SKAction.playSoundFileNamed("success", waitForCompletion: false)
    var waveFinished: Bool = true
    var hitFirstDoubleScore: Bool = false
    var previousNumber: UInt32?
    var bulletJoint: SKPhysicsJoint?
    var paddle: SKSpriteNode!
    var dimPanel: SKSpriteNode!
    var dimLeft: SKSpriteNode!
    var dimRight: SKSpriteNode!
    var dimPanelUp: SKSpriteNode!
    var dimLeftUp: SKSpriteNode!
    var dimRightUp: SKSpriteNode!
    var UILayer: UIClass!
    
    override func didMoveToView(view: SKView) {
        /* Set up your scene here */
        
        physicsWorld.contactDelegate = self
        paddle = self.childNodeWithName("//paddle") as! SKSpriteNode
        obstacleLayer = self.childNodeWithName("obstacleLayer")
        dimPanel = self.childNodeWithName("dimPanel") as! SKSpriteNode
        dimLeft = self.childNodeWithName("dimLeft") as! SKSpriteNode
        dimRight = self.childNodeWithName("dimRight") as! SKSpriteNode
        dimPanelUp = self.childNodeWithName("dimPanelUp") as! SKSpriteNode
        dimLeftUp = self.childNodeWithName("dimLeftUp") as! SKSpriteNode
        dimRightUp = self.childNodeWithName("dimRightUp") as! SKSpriteNode
        UILayer = self.childNodeWithName("UI") as! UIClass
        
        dimPanel.zPosition = -2
        dimLeft.zPosition = -2
        dimRight.zPosition = -2
        dimPanel.alpha = 0
        dimLeft.alpha = 0
        dimRight.alpha = 0
        dimPanelUp.zPosition = -2
        dimLeftUp.zPosition = -2
        dimRightUp.zPosition = -2
        dimPanelUp.alpha = 0
        dimLeftUp.alpha = 0
        dimRightUp.alpha = 0
        
        /* if paddleSelected == 0 {
        self.paddle.texture = SKTexture(imageNamed: "paddleBlue")
        } */
        
        
 
 
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "localScore")
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "wavesDone2")
        savedGames = NSUserDefaults.standardUserDefaults().integerForKey("savedGames2")
        savedCoins = NSUserDefaults.standardUserDefaults().integerForKey("savedCoins2")
        
        self.state = .Playing
    
    }
    
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if state == .GameOver || state == .Title { return }
        
        state = .Playing
        
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        
        if nodeAtPoint(touchLocation).name == paddleName {
            
            isFingerOnPaddle = true
            
            /* Reset touch timer */
            sinceTouch = 0
            
        }
        
        if let musicURL = NSBundle.mainBundle().URLForResource("music1", withExtension: "mp3") {
            if musicNumber == 0 {
            backgroundMusic = SKAudioNode(URL: musicURL)
            backgroundMusic.runAction(SKAction.changeVolumeTo(Float(0.5), duration: 0))
            addChild(backgroundMusic)
            musicNumber += 1
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if isFingerOnPaddle {
            let touch = touches.first
            let touchLocation = touch!.locationInNode(self)
            let previousLocation = touch!.previousLocationInNode(self)
            let paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            /* print("paddle-> " + String(paddleX) + " vs " + String(size.width - paddle.size.width/2))
             paddleX = min(paddleX, size.width - paddle.size.width/2)
             print("paddle-> " + String(paddleX))
             
             paddleX = max(paddleX, paddle.size.width/2)
             print("paddle-> " + String(paddleX))
             print(String(paddle.size.width/2)) */
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
            
            UILayer.hideArrows ()
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnPaddle = false
        
        if let bulletJoint = bulletJoint {
            
            if let bullet = bulletJoint.bodyA.node as? Bullet {
                bullet.physicsBody?.velocity = CGVectorMake(0, 600)
            }
                
            else if let bullet = bulletJoint.bodyB.node as? Bullet {
                bullet.physicsBody?.velocity = CGVectorMake(0, 600)
            }
            
            physicsWorld.removeJoint(bulletJoint)
            self.bulletJoint = nil
            
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if state != .Playing {
            return
        }
        
        /* Update last touch timer */
        sinceTouch+=fixedDelta
        
        /* Process obstacles */
        
        // stage 1
        if wavesDone <= 3 {
            spawnNewWave()
        }
        
        // stage 2
        if wavesDone > 3 {
            spawnNewWave2()
        }
        
        updateObstacles()
        
        spawnTimer += fixedDelta
        
        if health <= 0 {
            savedGames += 1
            savedGamesUpdate()
            gameOver()
        }
        
        if (wavesDone == 7 && wavesDoneNumber == 0) || (wavesDone == 14 && wavesDoneNumber == 1) {
            UILayer.fastForwardAnimation ()
            wavesDoneNumber += 1
        }
        
        if wavesDone == 21 && wavesDoneNumber == 2 {
            dimPanel.zPosition = 50
            dimLeft.zPosition = 51
            dimRight.zPosition = 51
            dimPanelUp.zPosition = 50
            dimLeftUp.zPosition = 51
            dimRightUp.zPosition = 51
            
            UILayer.hiddenLabelAnimation()
            
            dimPanel.runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(1, duration: 30)
                ]))
            
            dimLeft.runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(1, duration: 30)
                ]))
            
            dimRight.runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(1, duration: 30)
                ]))
            
            dimPanelUp.runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(0.65, duration: 30)
                ]))
            
            dimLeftUp.runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(0.65, duration: 30)
                ]))
            
            dimRightUp.runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(0.65, duration: 30)
                ]))
            wavesDoneNumber += 1
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
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
    
    func collisionCheck (enemy: Enemy, shootable: Shootable) {
        if enemy.shootable != shootable {
            return
        }
        
        if shootable.doubleScore {
            killedEnemy2()
            if hitFirstDoubleScore == false {
                hitFirstDouble()
            }
        }
            
        else {
            killedEnemy()
        }
        dieEnemy(enemy)
        dieEnemy(shootable)
    }
    
    func hitFirstDouble() {
        hitFirstDoubleScore = true
        for obstacle in obstacleLayer.children as! [SKSpriteNode] {
            if let ballTwo = obstacle as? Ball {
                ballTwo.doubleScore = true
            }
        }
    }
    
    func killedEnemy () {
        points += 1
        UILayer.updateScoreLabel(points)
        
        self.runAction(popSFX) //popSFX
        
        if points == 5 || points == 10 || points == 20 || points == 40 || points == 80 {
            
            self.runAction(successSFX)
            
        }
        
        if points >= 5 && pointsNumber == 0 || points >= 15 && pointsNumber == 1 || points >= 30 && pointsNumber == 2 || points >= 50 && pointsNumber == 3 || points >= 70 && pointsNumber == 4 || points >= 90 && pointsNumber == 5 || points >= 110 && pointsNumber == 6 || points >= 130 && pointsNumber == 7 || points >= 150 && pointsNumber == 8 || points >= 170 && pointsNumber == 9 || points >= 190 && pointsNumber == 10 || points >= 210 && pointsNumber == 11 || points >= 230 && pointsNumber == 12 || points >= 250 && pointsNumber == 13 || points >= 270 && pointsNumber == 14 || points >= 290 && pointsNumber == 15 {
            
            savedCoins += 1
            pointsNumber += 1
            savedCoinsUpdate()
        }
        
        UILayer.scoreColor(points)
    }
    
    func killedEnemy2 () {
        points += 2
        UILayer.updateScoreLabel(points)
        
        self.runAction(popSFX)
        
        UILayer.setBuffLabel()
        
        if points >= 5 && points <= 6 || points >= 10 && points <= 11 || points >= 20 && points <= 21 || points >= 40 && points <= 41 || points >= 80 && points <= 81 {
            
            self.runAction(successSFX)
        }
        UILayer.scoreColor(points)
    }
    
    func addBulletJoint (bullet: Bullet) {
        bullet.physicsBody?.velocity = CGVectorMake(0, 0)
        bulletJoint = SKPhysicsJointPin.jointWithBodyA(paddle.physicsBody!, bodyB: bullet.physicsBody!, anchor: bullet.position)
        
        physicsWorld.addJoint(bulletJoint!)
    }
    
    func dieEnemy(node: SKNode) {
        /* Enemy death*/
        node.removeFromParent()
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        for obstacle in obstacleLayer.children as! [SKSpriteNode] {
            
            if let bullet = obstacle as? Bullet {
                
                if bullet.position.y <= 70 || bullet.position.y > 660  {
                    health -= 1
                    self.runAction(pop2SFX)
                }
                
                if wavesDone <= 8 {
                    bullet.updateBulletSpeed()
                }
                    
                else if wavesDone > 8 && wavesDone <= 16 {
                    bullet.updateBulletSpeed2()
                }
                    
                else if wavesDone > 16 {
                    bullet.updateBulletSpeed3()
                }
            }
            else if let enemy = obstacle as? Enemy {
                if enemy.position.y < 180 {
                    health -= 1
                    self.runAction(pop2SFX)
                }
                if wavesDone <= 6 {
                    enemy.updateVelocity()
                }
                    
                else if wavesDone > 6 && wavesDone <= 13 {
                    enemy.updateVelocity2()
                }
                    
                else if wavesDone > 13 {
                    enemy.updateVelocity3()
                }
            }
            else if let ball = obstacle as? Ball {
                if ball.position.y <= 70 {
                    health -= 1
                    self.runAction(pop2SFX)
                }
                if wavesDone <= 6 {
                    ball.updateBallSpeed()
                }
                    
                else if wavesDone > 6 && wavesDone <= 13 {
                    ball.updateBallSpeed2()
                }
                    
                else if wavesDone > 13 {
                    ball.updateBallSpeed3()
                }
            }
        }
    }
    
    func gameOver() {
        /* Game over! */
        
        playerLocalScoreUpdate()
        playerHighScoreUpdate()
        state = .GameOver
        let skView = self.view as SKView!
        let scene = EndScene(fileNamed:"EndScene") as EndScene!
        scene.scaleMode = .AspectFill
        self.runAction(pop2SFX)
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)
        
    }
    
    func playerHighScoreUpdate() {
        let highScore = NSUserDefaults().integerForKey("highScore")
        if points > highScore {
            NSUserDefaults().setInteger(points, forKey: "highScore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func playerLocalScoreUpdate() {
        let localScore = NSUserDefaults().integerForKey("localScore")
        if points > localScore {
            NSUserDefaults().setInteger(points, forKey: "localScore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func wavesDone2Update() {
        let wavesDone2 = NSUserDefaults().integerForKey("wavesDone2")
        if wavesDone > wavesDone2 {
            NSUserDefaults().setInteger(wavesDone, forKey: "wavesDone2")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func savedGamesUpdate() {
        let savedGames2 = NSUserDefaults().integerForKey("savedGames2")
        if savedGames > savedGames2 {
            NSUserDefaults().setInteger(savedGames, forKey: "savedGames2")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func savedCoinsUpdate() {
        let savedCoins2 = NSUserDefaults().integerForKey("savedCoins2")
        if savedCoins > savedCoins2 {
            NSUserDefaults().setInteger(savedCoins, forKey: "savedCoins2")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func spawnNewWave(){
        if spawnTimer >= 0.8 && waveFinished {
            
            var random = arc4random_uniform(4)
            while previousNumber == random {
                random = arc4random_uniform(4)
            }
            
            previousNumber = random
            
            switch (random) {
                
            case 0:
                wave1()
            case 1:
                wave2()
            case 2:
                wave3()
            case 3:
                wave4()
            default:
                break
                
            }
            
            spawnTimer = 0
        }
    }
    
    func spawnNewWave2(){
        if spawnTimer >= 0.8 && waveFinished {
            
            var random = arc4random_uniform(9)
            while previousNumber == random {
                random = arc4random_uniform(9)
            }
            
            previousNumber = random
            
            switch (random) {
                
            case 0:
                wave1()
            case 1:
                wave2()
            case 2:
                wave3()
            case 3:
                wave4()
            case 4:
                wave5()
            case 5:
                wave6()
            case 6:
                wave7()
            case 7:
                wave8()
            case 8:
                wave9()
            default:
                break
                
            }
            spawnTimer = 0
        }
    }
    
    func createBallGroup(position: CGPoint){
        let newBall = createBall(position)
        let newEnemy = Enemy(imageName: "cloud")
        let enemyPosition = CGPoint (x: newBall.position.x+0, y: newBall.position.y+105)
        newEnemy.position = enemyPosition
        obstacleLayer.addChild(newEnemy)
        newEnemy.goDown()
        newEnemy.shootable = newBall
    }
    
    // 2x score
    func createBallGroup2(position: CGPoint){
        let newBall2 = createBallDoubleScore(position)
        let newEnemy2 = Enemy(imageName: "cloud")
        let enemyPosition = CGPoint (x: newBall2.position.x+0, y: newBall2.position.y+105)
        newEnemy2.position = enemyPosition
        obstacleLayer.addChild(newEnemy2)
        newEnemy2.goDown()
        newEnemy2.shootable = newBall2
        hitFirstDoubleScore = false
    }
    
    func createBulletGroup(position: CGPoint) -> Enemy{
        UILayer.instructionsUpdate()
        let bullet = createBullet(position)
        let enemy = createEnemy(CGPoint(x: bullet.position.x+40, y: bullet.position.y+120)) 
        enemy.shootable = bullet
        return enemy
    }
    
    func createBall(position: CGPoint) -> Ball {
        let newBall = Ball()
        newBall.position = position
        obstacleLayer.addChild(newBall)
        return newBall
    }
    
    func createBallDoubleScore(position: CGPoint) -> Ball {
        let newBall = createBall(position)
        newBall.doubleScore = true
        return newBall
    }
    
    func createBullet(position: CGPoint) -> Bullet {
        let newBullet = Bullet()
        newBullet.position = position
        obstacleLayer.addChild(newBullet)
        return newBullet
    }
    
    func createEnemy(position: CGPoint) -> Enemy {
        let newEnemy = Enemy(imageName: "wingMan3")
        newEnemy.position = position
        obstacleLayer.addChild(newEnemy)
        return newEnemy
    }
    
    func wave1() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 335, 280, 220]
        var index = 0
        let wait = SKAction.waitForDuration(0.35)
        let run = SKAction.runBlock {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }

        self.runAction(SKAction.sequence([run, wait, run, wait, run, wait, run, wait, run, wait, run, finish]))
        
    }
    
    func wave2() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 90, 335, 280]
        var index = 0
        let wait = SKAction.waitForDuration(0.4)
        let run = SKAction.runBlock {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }
        
        self.runAction(SKAction.sequence([run, run, wait, run, wait, run, finish]))
        
    }
    
    func wave3() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 280, 100, 220, 140, 180]
        var index = 0
        let wait = SKAction.waitForDuration(0.4)
        let run = SKAction.runBlock {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }
        
        self.runAction(SKAction.sequence([run, wait, run, wait, run, wait, run, wait, run, run, finish]))
        
    }
    
    func wave4() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 60, 60, 100, 250]
        var index = 0
        let wait = SKAction.waitForDuration(0.3)
        let wait2 = SKAction.waitForDuration(0.2)
        let run = SKAction.runBlock {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }
        
        self.runAction(SKAction.sequence([run, wait2, run, wait2, run, wait, run, wait, run, finish]))
        
    }
    
    func wave5() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 100, 160]
        let wavePositionsX2 = [40, 120, 200]
        var index = 0
        var index2 = 0
        let wait = SKAction.waitForDuration(0.4)
        let wait2 = SKAction.waitForDuration(1)
        
        let run = SKAction.runBlock {
            
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        
        let run2 = SKAction.runBlock {
            
            let enemy = self.createBulletGroup(CGPoint(x: wavePositionsX2[index2], y: 650))
            
            if self.wavesDone <= 6 {
                enemy.goDown()
            }
                
            else if self.wavesDone > 6 && self.wavesDone <= 13 {
                enemy.go2Down2()
            }
                
            else if self.wavesDone > 13 {
                enemy.go2Down3()
            }
            
            index2 += 1
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }
        
        self.runAction(SKAction.sequence([wait, wait, run, wait, run, wait, run, wait2, run2, wait2, run2, wait2, run2, wait, wait, finish]))
        
    }
    
    func wave6() {
        
        let wavePositionsX = [200, 160, 120]
        var index = 0
        self.waveFinished = false
        
        let wait = SKAction.waitForDuration(0.4)
        let wait2 = SKAction.waitForDuration(3.5)
        let wait3 = SKAction.waitForDuration(1.2)
        let wait4 = SKAction.waitForDuration(1)
        
        let run = SKAction.runBlock {
            let enemy = self.createBulletGroup(CGPoint(x: 25, y: 500))
            
            if self.wavesDone <= 6 {
                enemy.goRight()
            }
                
            else if self.wavesDone > 6  && self.wavesDone <= 13 {
                enemy.goRight2()
            }
                
            else if self.wavesDone > 13 {
                enemy.goRight3()
            }
        }
        
        let run2 = SKAction.runBlock {
            let enemy = self.createBulletGroup(CGPoint(x: 345, y: 500))
            
            if self.wavesDone <= 6 {
                enemy.goLeft()
            }
                
            else if self.wavesDone > 6 && self.wavesDone <= 13 {
                enemy.goLeft2()
            }
                
            else if self.wavesDone > 13 {
                enemy.goLeft3()
            }
        }
        
        let run3 = SKAction.runBlock {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }
        
        self.runAction(SKAction.sequence([wait4, run, wait4, wait4, run3, wait, run3, wait, run3, wait3, wait, run2, wait2, finish]))
        
    }
    
    func wave7() {
        
        self.waveFinished = false
        
        let wavePositionsX = [100, 200]
        var index = 0
        let wait = SKAction.waitForDuration(0.4)
        let wait2 = SKAction.waitForDuration(2.3)
        let wait3 = SKAction.waitForDuration(1)
        let wait4 = SKAction.waitForDuration(1.5)
        
        let run = SKAction.runBlock {
            
            let enemy = self.createBulletGroup(CGPoint(x: wavePositionsX[index], y: 650))
            
            if self.wavesDone <= 6 {
                enemy.goDown()
            }
                
            else if self.wavesDone > 6 && self.wavesDone <= 13 {
                enemy.go2Down2()
            }
                
            else if self.wavesDone > 13 {
                enemy.go2Down3()
            }
            index += 1
        }
        
        let run2 = SKAction.runBlock {
            
            let enemy = self.createBulletGroup(CGPoint(x: 25, y: 420))
            
            if self.wavesDone <= 6 {
                enemy.goRight()
            }
                
            else if self.wavesDone > 6 && self.wavesDone <= 13 {
                enemy.goRight2()
            }
                
            else if self.wavesDone > 13 {
                enemy.goRight3()
            }
        }
        
        let run3 = SKAction.runBlock {
            
            let enemy = self.createBulletGroup(CGPoint(x: 345, y: 500))
            
            if self.wavesDone <= 6 {
                enemy.goLeft()
            }
                
            else if self.wavesDone > 6 && self.wavesDone <= 13 {
                enemy.goLeft2()
            }
                
            else if self.wavesDone > 13 {
                enemy.goLeft3()
            }
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }
        
        self.runAction(SKAction.sequence([wait3, run, wait2, run2, wait2, run3, wait2, wait, run, wait4, wait3, finish]))
        
    }
    
    func wave8() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 220, 280, 340, 280, 220, 160, 100, 40]
        var index = 0
        let wait = SKAction.waitForDuration(0.2)
        let wait2 = SKAction.waitForDuration(0.4)
        let wait3 = SKAction.waitForDuration(1.5)
        let run = SKAction.runBlock {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }
        
        self.runAction(SKAction.sequence([wait2, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait3, finish]))
        
    }
    
    func wave9() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 220]
        let wavePositionsX2 = [40]
        var index = 0
        var index2 = 0
        let wait = SKAction.waitForDuration(0.4)
        let wait2 = SKAction.waitForDuration(0.3)
        let run = SKAction.runBlock {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let run2 = SKAction.runBlock {
            self.createBallGroup2(CGPoint(x: wavePositionsX2[index2], y: 650))
            index2 += 1
            
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
            self.wavesDone2Update()
        }
        
        self.runAction(SKAction.sequence([wait, wait2, run, wait, run, wait2, run, wait2, run, wait2, run2, finish]))
        
    }
    
    
}


