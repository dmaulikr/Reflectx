//
//  GameScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright (c) 2016 Jacky. All rights reserved.
//

import SpriteKit
import AVFoundation

enum GameState {
    case title, browse, playing, gameOver, restart
}

public let BallTwoCategory : UInt32 = 16
public let BulletCategory : UInt32 = 8
public let BallCategory : UInt32 = 4
public let EnemyCategory : UInt32 = 2
public let PaddleCategory : UInt32 = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sinceTouch : CFTimeInterval = 0
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0
    var obstacleLayer: SKNode!
    var music: SKNode!
    var wavesNumber = 0
    var wavesDoneNumber = 0
    var savedGames = 0
    var savedCoins = 0
    var earnedCoins = 0
    var points = 0
    var pointsNumber = 0
    var musicNumber = 0
    var health: Int = 1
    var isFingerOnPaddle = false
    var state: GameState = .title
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
    let soundOn: Bool = UserDefaults.standard.bool(forKey: "soundOn")
    let shakeScene:SKAction = SKAction.init(named: "Shake")!
    let shakeScene2:SKAction = SKAction.init(named: "Shake2")!
    var player = AVAudioPlayer()
    var nowPlaying = false
    
    override func didMove(to view: SKView) {
        /* Set up your scene here */
        
        physicsWorld.contactDelegate = self
        paddle = self.childNode(withName: "//paddle") as! SKSpriteNode
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        dimPanel = self.childNode(withName: "dimPanel") as! SKSpriteNode
        dimLeft = self.childNode(withName: "dimLeft") as! SKSpriteNode
        dimRight = self.childNode(withName: "dimRight") as! SKSpriteNode
        dimPanelUp = self.childNode(withName: "dimPanelUp") as! SKSpriteNode
        dimLeftUp = self.childNode(withName: "dimLeftUp") as! SKSpriteNode
        dimRightUp = self.childNode(withName: "dimRightUp") as! SKSpriteNode
        UILayer = self.childNode(withName: "UI") as! UIClass
        
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
        
        UILayer.setupPauseButton(self)
        savedGames = UserDefaults.standard.integer(forKey: "savedGames2")
        savedCoins = UserDefaults.standard.integer(forKey: "savedCoins")
        let paddleSelected: Constants.PaddleColor = Constants.PaddleColor(rawValue: UserDefaults.standard.integer(forKey: "paddleSelected"))!
        let greenBought: Int = UserDefaults.standard.integer(forKey: "greenBought")
        let redBought: Int = UserDefaults.standard.integer(forKey: "redBought")
        
        self.state = .playing
        
        if paddleSelected == .blue {
            self.paddle.texture = SKTexture(imageNamed: "paddleBlue")
        }
        
        if paddleSelected == .green && greenBought == 1 {
            self.paddle.texture = SKTexture(imageNamed: "paddleGreen")
        }
        
        if paddleSelected == .red && redBought == 1 {
            self.paddle.texture = SKTexture(imageNamed: "paddleRed")
        }
        
        let urlPath = Bundle.main.url(forResource: "music1", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: urlPath!)
        
        if soundOn {
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
        if wavesNumber <= 4 {
            spawnNewWave()
        }
        
        // stage 2
        if wavesNumber > 4 && wavesNumber <= 10 {
            spawnNewWave2()
        }
        
        if wavesNumber > 10 {
            spawnNewWave3()
        }
        
        if wavesNumber > 13 {
            spawnNewWave4()
        }
        
        updateObstacles()
        
        spawnTimer += fixedDelta
        
        if health <= 0 {
            savedGames += 1
            savedGamesUpdate()
            player.pause()
            gameOver()
        }
        
        if (wavesNumber == 5 && wavesDoneNumber == 0) || (wavesNumber == 8 && wavesDoneNumber == 1) || (wavesNumber == 11 && wavesDoneNumber == 2) || (wavesNumber == 14 && wavesDoneNumber == 3) {
            UILayer.fastForwardAnimation ()
            wavesDoneNumber += 1
        }
        
        if wavesNumber == 17 && wavesDoneNumber == 4 {
            dimPanel.zPosition = 50
            dimLeft.zPosition = 51
            dimRight.zPosition = 51
            dimPanelUp.zPosition = 50
            dimLeftUp.zPosition = 51
            dimRightUp.zPosition = 51
            
            UILayer.hiddenLabelAnimation()
            
            dimPanel.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 1, duration: 30)
                ]))
            
            dimLeft.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 1, duration: 30)
                ]))
            
            dimRight.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 1, duration: 30)
                ]))
            
            dimPanelUp.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 0.65, duration: 30)
                ]))
            
            dimLeftUp.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 0.65, duration: 30)
                ]))
            
            dimRightUp.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 0.65, duration: 30)
                ]))
            wavesDoneNumber += 1
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
                    self.run(SKAction.wait(forDuration: 0), completion: {() -> Void in
                        let spark = SKEmitterNode(fileNamed: "Spark.sks")
                        spark!.targetNode = self;
                        self.paddle.addChild(spark!)
                        self.run(SKAction.wait(forDuration: 1), completion: {() -> Void in
                            spark!.removeFromParent()
                        })
                    })
                }
                else if let bullet = nodeB as? Bullet {
                    addBulletJoint(bullet)
                    self.run(SKAction.wait(forDuration: 0), completion: {() -> Void in
                        let spark = SKEmitterNode(fileNamed: "Spark.sks")
                        spark!.targetNode = self;
                        self.paddle.addChild(spark!)
                        self.run(SKAction.wait(forDuration: 1), completion: {() -> Void in
                            spark!.removeFromParent()
                        })
                    })
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
            self.run(SKAction.wait(forDuration: 0), completion: {() -> Void in
                let magic = SKEmitterNode(fileNamed: "Magic.sks")
                magic!.targetNode = self;
                self.paddle.addChild(magic!)
                self.run(SKAction.wait(forDuration: 1), completion: {() -> Void in
                    magic!.removeFromParent()
                })
            })
        }
    }
    
    func killedEnemy () {
        points += 1
        UILayer.updateScoreLabel(points)
        
        if soundOn {
            self.run(popSFX)
        }
        
        if points == 5 || points == 10 || points == 20 || points == 40 || points == 80 {
            
            if soundOn {
                self.run(successSFX)
            }
        }
        
        if points >= 5 && pointsNumber == 0 || points >= 10 && pointsNumber == 1 || points >= 20 && pointsNumber == 2 || points >= 40 && pointsNumber == 3 || points >= 60 && pointsNumber == 4 || points >= 80 && pointsNumber == 5 || points >= 100 && pointsNumber == 6 || points >= 120 && pointsNumber == 7 || points >= 140 && pointsNumber == 8 || points >= 160 && pointsNumber == 9 || points >= 180 && pointsNumber == 10 || points >= 200 && pointsNumber == 11 || points >= 220 && pointsNumber == 12 || points >= 240 && pointsNumber == 13 || points >= 260 && pointsNumber == 14 || points >= 280 && pointsNumber == 15 {
            
            savedCoins += 1
            earnedCoins += 1
            pointsNumber += 1
            savedCoinsUpdate()
            
            var random = arc4random_uniform(2)
            while previousNumber == random {
                random = arc4random_uniform(2)
            }
            
            previousNumber = random
            
            switch (random) {
                
            case 0:
                shake1()
            case 1:
                shake2()
            default:
                break
                
            }
        }
        
        UILayer.scoreColor(points)
    }
    
    func killedEnemy2 () {
        points += 2
        UILayer.updateScoreLabel(points)
        
        if soundOn {
            self.run(popSFX)
        }
        
        UILayer.setBuffLabel()
        
        if points >= 5 && points <= 6 || points >= 10 && points <= 11 || points >= 20 && points <= 21 || points >= 40 && points <= 41 || points >= 80 && points <= 81 || points >= 160 && points <= 161 {
            
            if soundOn {
                self.run(successSFX)
            }
        }
        UILayer.scoreColor(points)
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
                    if soundOn {
                        self.run(pop2SFX)
                    }
                }
                
                bullet.updateBulletSpeed(self.wavesNumber)
                
            }
            else if let enemy = obstacle as? Enemy {
                if enemy.position.y < 180 {
                    health -= 1
                    if soundOn {
                        self.run(pop2SFX)
                    }
                }
                if enemy.position.x > 400 {
                    health -= 1
                    if soundOn {
                        self.run(pop2SFX)
                    }
                }
                if enemy.position.x < 0 {
                    health -= 1
                    if soundOn {
                        self.run(pop2SFX)
                    }
                }
                enemy.updateVelocity(self.wavesNumber)
            }
                
            else if let ball = obstacle as? Ball {
                if ball.position.y <= 70 {
                    health -= 1
                    if soundOn {
                        self.run(pop2SFX)
                    }
                }
                ball.updateBallSpeed(self.wavesNumber)
            }
        }
    }
    
    func gameOver() {
        /* Game over! */
        playerHighScoreUpdate()
        state = .gameOver
        let skView = self.view as SKView!
        let scene = EndScene(fileNamed:"EndScene") as EndScene!
        scene?.localScore = points
        scene?.earnedCoins = earnedCoins
        scene?.scaleMode = .aspectFit
        if soundOn {
            self.run(pop2SFX)
        }
        let transition = SKTransition.fade(with: UIColor.darkGray, duration: 0.6)
        skView?.presentScene(scene!, transition: transition)
        
    }
    
    func playerHighScoreUpdate() {
        let highScore = UserDefaults().integer(forKey: "highScore")
        if points > highScore {
            UserDefaults().set(points, forKey: "highScore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func savedGamesUpdate() {
        let savedGames2 = UserDefaults().integer(forKey: "savedGames2")
        if savedGames > savedGames2 {
            UserDefaults().set(savedGames, forKey: "savedGames2")
            UserDefaults.standard.synchronize()
        }
    }
    
    func savedCoinsUpdate() {
        UserDefaults().set(savedCoins, forKey: "savedCoins")
        UserDefaults.standard.synchronize()
        
    }
    
    func spawnNewWave(){
        if spawnTimer >= 2.8 && waveFinished {
            
            var random = arc4random_uniform(4)
            while previousNumber == random {
                random = arc4random_uniform(4)
            }
            
            previousNumber = random
            
            switch (random) {
                
            case 0:
                wave11()
            case 1:
                wave12()
            case 2:
                wave13()
            case 3:
                wave14()
            default:
                break
                
            }
            
            spawnTimer = 0
        }
    }
    
    func spawnNewWave2(){
        if spawnTimer >= 2.8 && waveFinished {
            
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
                wave7()
            case 6:
                wave8()
            case 7:
                wave9()
            case 8:
                wave10()
            default:
                break
                
            }
            spawnTimer = 0
        }
    }
    
    func spawnNewWave3(){
        if spawnTimer >= 2.5 && waveFinished {
            
            var random = arc4random_uniform(10)
            while previousNumber == random {
                random = arc4random_uniform(10)
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
            case 9:
                wave10()
            default:
                break
                
            }
            spawnTimer = 0
        }
    }
    
    func spawnNewWave4(){
        if spawnTimer >= 2.3 && waveFinished {
            
            var random = arc4random_uniform(10)
            while previousNumber == random {
                random = arc4random_uniform(10)
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
            case 9:
                wave10()
            default:
                break
                
            }
            spawnTimer = 0
        }
    }
    
    func createBallGroup(_ position: CGPoint){
        let newBall = createBall(position)
        let newEnemy = Enemy(imageName: "cloud")
        let enemyPosition = CGPoint (x: newBall.position.x+0, y: newBall.position.y+105)
        newEnemy.position = enemyPosition
        obstacleLayer.addChild(newEnemy)
        newEnemy.goDown(wavesNumber)
        newEnemy.shootable = newBall
    }
    
    // 2x score
    func createBallGroup2(_ position: CGPoint){
        let newBall2 = createBallDoubleScore(position)
        let newEnemy2 = Enemy(imageName: "cloud")
        let enemyPosition = CGPoint (x: newBall2.position.x+0, y: newBall2.position.y+105)
        newEnemy2.position = enemyPosition
        obstacleLayer.addChild(newEnemy2)
        newEnemy2.goDown(wavesNumber)
        newEnemy2.shootable = newBall2
        hitFirstDoubleScore = false
    }
    
    func createBulletGroup(_ position: CGPoint) -> Enemy{
        UILayer.instructionsUpdate()
        let bullet = createBullet(position)
        let enemy = createEnemy(CGPoint(x: bullet.position.x+40, y: bullet.position.y+120))
        enemy.shootable = bullet
        return enemy
    }
    
    func createBulletGroup2(_ position: CGPoint) -> Enemy{
        UILayer.instructionsUpdate()
        let bullet = createBullet(position)
        let enemy = createEnemy(CGPoint(x: bullet.position.x-40, y: bullet.position.y+120))
        enemy.shootable = bullet
        return enemy
    }
    
    func createBall(_ position: CGPoint) -> Ball {
        let newBall = Ball()
        newBall.position = position
        obstacleLayer.addChild(newBall)
        return newBall
    }
    
    func createBallDoubleScore(_ position: CGPoint) -> Ball {
        let newBall = createBall(position)
        newBall.doubleScore = true
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
        
        let wavePositionsX = [40, 100, 160, 335, 280, 220]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.35)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait, run, wait, run, wait, run, wait, run, wait, run, finish]))
        
    }
    
    func wave2() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 90, 335, 280]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.4)
        let wait2 = SKAction.wait(forDuration: 1)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        
        let run2 = SKAction.run {
            let enemy = self.createBulletGroup2(CGPoint(x: 135, y: 650))
            
            enemy.goDown(self.wavesNumber)
            
        }
        
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, run, wait, run, wait, run, wait2, run2, finish]))
        
    }
    
    func wave3() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 280, 100, 220, 140, 180]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.4)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait, run, wait, run, wait, run, wait, run, run, finish]))
        
    }
    
    func wave4() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 60, 60, 100, 250, 335, 335, 160, 200, 335]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.3)
        let wait2 = SKAction.wait(forDuration: 0.2)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait2, run, wait2, run, wait, run, wait, run, wait, run, wait2, run, wait, run, run, wait, run, finish]))
        
    }
    
    func wave5() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 100, 160]
        let wavePositionsX2 = [40, 120, 200]
        var index = 0
        var index2 = 0
        let wait = SKAction.wait(forDuration: 0.4)
        let wait2 = SKAction.wait(forDuration: 1)
        
        let run = SKAction.run {
            
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        
        let run2 = SKAction.run {
            
            let enemy = self.createBulletGroup(CGPoint(x: wavePositionsX2[index2], y: 650))
            
            enemy.goDown(self.wavesNumber)
            index2 += 1
        }
        
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([wait, wait, run, wait, run, wait, run, wait2, run2, wait2, run2, wait2, run2, wait, wait, finish]))
        
    }
    
    func wave6() {
        
        let wavePositionsX = [200, 160, 120]
        var index = 0
        self.waveFinished = false
        
        let wait = SKAction.wait(forDuration: 0.4)
        let wait2 = SKAction.wait(forDuration: 3.5)
        let wait3 = SKAction.wait(forDuration: 1.2)
        let wait4 = SKAction.wait(forDuration: 1)
        
        let run = SKAction.run {
            let enemy = self.createBulletGroup(CGPoint(x: 25, y: 500))
            
            enemy.goRightSpecial(self.wavesNumber)
            
        }
        
        let run2 = SKAction.run {
            let enemy = self.createBulletGroup(CGPoint(x: 345, y: 500))
            
            enemy.goLeftSpecial(self.wavesNumber)
            
        }
        
        let run3 = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([wait4, run, wait4, wait4, run3, wait, run3, wait, run3, wait3, wait, run2, wait2, finish]))
        
    }
    
    func wave7() {
        
        self.waveFinished = false
        
        let wavePositionsX = [100, 200]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.4)
        let wait2 = SKAction.wait(forDuration: 2.3)
        let wait3 = SKAction.wait(forDuration: 1)
        let wait4 = SKAction.wait(forDuration: 1.5)
        
        let run = SKAction.run {
            
            let enemy = self.createBulletGroup(CGPoint(x: wavePositionsX[index], y: 650))
            enemy.goDown(self.wavesNumber)
            index += 1
        }
        
        let run2 = SKAction.run {
            
            let enemy = self.createBulletGroup(CGPoint(x: 25, y: 420))
            enemy.goRight(self.wavesNumber)
        }
        
        let run3 = SKAction.run {
            
            let enemy = self.createBulletGroup(CGPoint(x: 345, y: 500))
            enemy.goLeft(self.wavesNumber)
        }
        
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([wait3, run, wait2, run2, wait2, run3, wait2, wait, run, wait4, wait3, finish]))
        
    }
    
    func wave8() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 220, 280, 340, 280, 220, 160, 100, 40]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.2)
        let wait2 = SKAction.wait(forDuration: 0.4)
        let wait3 = SKAction.wait(forDuration: 1.5)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([wait2, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, wait3, finish]))
        
    }
    
    func wave9() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 220]
        let wavePositionsX2 = [40]
        var index = 0
        var index2 = 0
        let wait = SKAction.wait(forDuration: 0.4)
        let wait2 = SKAction.wait(forDuration: 0.3)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let run2 = SKAction.run {
            self.createBallGroup2(CGPoint(x: wavePositionsX2[index2], y: 650))
            index2 += 1
            
        }
        
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([wait, wait2, run, wait, run, wait2, run, wait2, run, wait2, run2, wait, finish]))
        
    }
    
    func wave10() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 120, 180, 340, 280, 220, 80, 320]
        let wavePositionsX2 = [40]
        var index = 0
        var index2 = 0
        let wait = SKAction.wait(forDuration: 0.4)
        let wait2 = SKAction.wait(forDuration: 0.3)
        let wait3 = SKAction.wait(forDuration: 1.05)
        
        let run = SKAction.run {
            
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        
        let run2 = SKAction.run {
            
            let enemy = self.createBulletGroup(CGPoint(x: wavePositionsX2[index2], y: 650))
            
            enemy.goDown(self.wavesNumber)
            index2 += 1
        }
        
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([wait, run, wait2, run, wait2, run, wait2, run, wait2, run, wait2, run, wait2, run, wait2, run, wait3, run2, wait, finish]))
        
    }
    
    func wave11() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 220, 60]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.55)
        let wait2 = SKAction.wait(forDuration: 0.8)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait, run, wait, run, wait, run, wait2, run, finish]))
        
    }
    
    func wave12() {
        
        self.waveFinished = false
        
        let wavePositionsX = [335, 220, 105]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.65)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait, run, wait, run, finish]))
        
    }
    
    func wave13() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 280, 100, 220, 140, 180]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.85)
        let wait2 = SKAction.wait(forDuration: 0.55)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait, run, wait, run, wait, run, wait2, run, wait2, run, finish]))
        
    }
    
    func wave14() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 335, 280, 220]
        var index = 0
        let wait = SKAction.wait(forDuration: 0.45)
        let wait2 = SKAction.wait(forDuration: 0.9)
        let run = SKAction.run {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.run {
            self.waveFinished = true
            self.wavesNumber += 1
        }
        
        self.run(SKAction.sequence([run, wait, run, wait, run, wait2, run, wait, run, wait, run, finish]))
        
    }
    
    func shake1 () {
        for node in self.children {
            node.run(shakeScene)
        }
    }
    
    func shake2 () {
        for node in self.children {
            node.run(shakeScene2)
        }
    }
}


