//
//  GameScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright (c) 2016 Jacky. All rights reserved.
//

import SpriteKit

enum GameState {
    case Title, Browse, Playing, GameOver
}

public let BulletCategory : UInt32 = 8
public let BallCategory : UInt32 = 4
public let EnemyCategory : UInt32 = 2
public let PaddleCategory : UInt32 = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddleBlue: SKSpriteNode!
    var sinceTouch : CFTimeInterval = 0
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0 // 60 FPS, fix later on (phones with 40 fps etc)
    var obstacleLayer: SKNode!
    var obstacleLayer2: SKNode!
    var obstacleLayer3: SKNode!
    var obstacleLayer4: SKNode!
    var scoreLabel: SKLabelNode!
    var points = 0
    var instructionsNumber = 0
    var wavesDone = 0
    var isFingerOnPaddle = false
    var pauseButton: MSButtonNode!
    var instructions: SKLabelNode!
    var instructions2: SKLabelNode!
    var smallLeftArrow: SKSpriteNode!
    var smallRightArrow: SKSpriteNode!
    var health: Int = 1
    var state: GameState = .Title
    let paddleName: String = "paddleBlue"
    let popSFX = SKAction.playSoundFileNamed("pop", waitForCompletion: false)
    let pop2SFX = SKAction.playSoundFileNamed("pop2", waitForCompletion: false)
    let successSFX = SKAction.playSoundFileNamed("success", waitForCompletion: false)
    var waveFinished: Bool = true
    var previousNumber: UInt32?
    var bulletJoint: SKPhysicsJoint?
    var bulletJoint2: SKPhysicsJoint?
    var bulletJoint3: SKPhysicsJoint?
    var difficulty: MainScene.DifficultyState!
    
    override func didMoveToView(view: SKView) {
        /* Set up your scene here */
        
        physicsWorld.contactDelegate = self
        paddleBlue = self.childNodeWithName("//paddleBlue") as! SKSpriteNode
        obstacleLayer = self.childNodeWithName("obstacleLayer")
        obstacleLayer2 = self.childNodeWithName("obstacleLayer2")
        obstacleLayer3 = self.childNodeWithName("obstacleLayer3")
        obstacleLayer4 = self.childNodeWithName("obstacleLayer4")
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        smallLeftArrow = self.childNodeWithName("smallLeftArrow") as! SKSpriteNode
        smallRightArrow = self.childNodeWithName("smallRightArrow") as! SKSpriteNode
        instructions = self.childNodeWithName("instructions") as! SKLabelNode
        instructions2 = self.childNodeWithName("instructions2") as! SKLabelNode
        scoreLabel.text = String(points)
        pauseButton = childNodeWithName("pauseButton") as! MSButtonNode
        
        self.instructions2.hidden = true
        
        pauseButton.selectedHandler = {
            self.paused = !self.paused
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "localScore")
        
        self.state = .Playing
        
        self.runAction(SKAction.waitForDuration(1.5), completion: {() -> Void in
            self.instructions.hidden = true
        })
        
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
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if isFingerOnPaddle {
            let touch = touches.first
            let touchLocation = touch!.locationInNode(self)
            let previousLocation = touch!.previousLocationInNode(self)
            let paddleX = paddleBlue.position.x + (touchLocation.x - previousLocation.x)
            
            /* print("paddle-> " + String(paddleX) + " vs " + String(size.width - paddle.size.width/2))
             paddleX = min(paddleX, size.width - paddle.size.width/2)
             print("paddle-> " + String(paddleX))
             
             paddleX = max(paddleX, paddle.size.width/2)
             print("paddle-> " + String(paddleX))
             print(String(paddle.size.width/2)) */
            
            paddleBlue.position = CGPoint(x: paddleX, y: paddleBlue.position.y)
            
            smallLeftArrow.hidden = true
            smallRightArrow.hidden = true
            
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
        
        if let bulletJoint2 = bulletJoint2 {
            
            if let bullet2 = bulletJoint2.bodyA.node as? Bullet2 {
                bullet2.physicsBody?.velocity = CGVectorMake(0, 600)
            }
                
            else if let bullet2 = bulletJoint2.bodyB.node as? Bullet2 {
                bullet2.physicsBody?.velocity = CGVectorMake(0, 600)
            }
            
            physicsWorld.removeJoint(bulletJoint2)
            self.bulletJoint2 = nil
        }
        
        
        if let bulletJoint3 = bulletJoint3 {
            
            if let bullet3 = bulletJoint3.bodyA.node as? Bullet3 {
                bullet3.physicsBody?.velocity = CGVectorMake(0, 600)
            }
                
            else if let bullet3 = bulletJoint3.bodyB.node as? Bullet3 {
                bullet3.physicsBody?.velocity = CGVectorMake(0, 600)
            }
            
            physicsWorld.removeJoint(bulletJoint3)
            self.bulletJoint3 = nil
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
        
        // stage 1 & 2
        if wavesDone <= 7 {
            updateObstacles()
        }
        
        // stage 3
        if wavesDone > 7 {
            updateObstacles2()
        }
        
        spawnTimer += fixedDelta
        
        if health <= 0 {
            gameOver()
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
        
        if bulletJoint2 == nil {
            
            if (contactA.categoryBitMask == PaddleCategory && contactB.categoryBitMask == BulletCategory) || (contactA.categoryBitMask == BulletCategory && contactB.categoryBitMask == PaddleCategory) {
                
                if let bullet2 = nodeA as? Bullet2 {
                    addBulletJoint2(bullet2)
                }
                    
                else if let bullet2 = nodeB as? Bullet2 {
                    addBulletJoint2(bullet2)
                }
            }
        }
        
        if bulletJoint3 == nil {
            
            if (contactA.categoryBitMask == PaddleCategory && contactB.categoryBitMask == BulletCategory) || (contactA.categoryBitMask == BulletCategory && contactB.categoryBitMask == PaddleCategory) {
                
                if let bullet3 = nodeA as? Bullet3 {
                    addBulletJoint3(bullet3)
                }
                    
                else if let bullet3 = nodeB as? Bullet3 {
                    addBulletJoint3(bullet3)
                }
            }
        }
        
        /* Check if either physics bodies was an enemy */
        if contactA.categoryBitMask == EnemyCategory || contactB.categoryBitMask == EnemyCategory {
            
            if contact.collisionImpulse > 0 {
                dieEnemy(nodeA)
                dieEnemy(nodeB)
                
                points += 1
                
                playerLocalScoreUpdate()
                playerHighScoreUpdate()
                print(NSUserDefaults().integerForKey("highScore"))
                
                self.runAction(popSFX)
                
                if points == 5 || points == 10 || points == 20 || points == 40 || points == 80 {
                    
                    self.runAction(successSFX)
                    
                }
                
                scoreColor()
                
            }
            
        }
        
    }
    
    func addBulletJoint (bullet: Bullet) {
        bullet.physicsBody?.velocity = CGVectorMake(0, 0)
        bulletJoint = SKPhysicsJointPin.jointWithBodyA(paddleBlue.physicsBody!, bodyB: bullet.physicsBody!, anchor: bullet.position)
        
        physicsWorld.addJoint(bulletJoint!)
    }
    
    func addBulletJoint2 (bullet2: Bullet2) {
        bullet2.physicsBody?.velocity = CGVectorMake(0, 0)
        bulletJoint2 = SKPhysicsJointPin.jointWithBodyA(paddleBlue.physicsBody!, bodyB: bullet2.physicsBody!, anchor: bullet2.position)
        
        physicsWorld.addJoint(bulletJoint2!)
    }
    
    func addBulletJoint3 (bullet3: Bullet3) {
        bullet3.physicsBody?.velocity = CGVectorMake(0, 0)
        bulletJoint3 = SKPhysicsJointPin.jointWithBodyA(paddleBlue.physicsBody!, bodyB: bullet3.physicsBody!, anchor: bullet3.position)
        
        physicsWorld.addJoint(bulletJoint3!)
    }
    
    func scoreColor () {
        switch (points) {
            
        case 5...9:
            scoreLabel.fontColor = UIColor.greenColor()
        case 10...19:
            scoreLabel.fontColor = UIColor.orangeColor()
        case 20...39:
            scoreLabel.fontColor = UIColor.blueColor()
        case 40...79:
            scoreLabel.fontColor = UIColor.redColor()
        case 80:
            scoreLabel.fontColor = UIColor.yellowColor()
        default:
            break
            
        }
        
    }
    
    func dieEnemy(node: SKNode) {
        /* Enemy death*/
        node.removeFromParent()
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        for bullet3 in obstacleLayer4.children as! [Bullet3] {
            
            let bullet3Position = obstacleLayer4.convertPoint(bullet3.position, toNode: self)
            
            if bullet3.connectedEnemy4?.position.x <= 40  {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet3Position.y > bullet3.connectedEnemy4?.position.y {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet3Position.y < 70 {
                self.health -= 1
                self.runAction(pop2SFX)
            }
            
        }
        
        for bullet2 in obstacleLayer3.children as! [Bullet2] {
            
            let bullet2Position = obstacleLayer3.convertPoint(bullet2.position, toNode: self)
            
            if bullet2.connectedEnemy3?.position.x >= 335  {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet2Position.y > bullet2.connectedEnemy3?.position.y {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet2Position.y < 70 {
                self.health -= 1
                self.runAction(pop2SFX)
            }
            
        }
        
        for bullet in obstacleLayer2.children as! [Bullet] {
            
            let bulletPosition = obstacleLayer2.convertPoint(bullet.position, toNode: self)
            
            if bulletPosition.y <= 70 {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bulletPosition.y > 660 {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet.connectedEnemy2?.position.y < 600 && bullet.connectedEnemy2?.position.y > 550 {
                bullet.connectedEnemy2?.physicsBody?.velocity = CGVector(dx: 0, dy: -105)
            }
            
            if bullet.connectedEnemy2?.position.y <= 500 {
                bullet.connectedEnemy2?.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            }
            
            if bulletPosition.y < 600 && bulletPosition.y > 550 {
                bullet.physicsBody?.velocity = CGVector(dx: 0, dy: -120)
            }
            
            if bulletPosition.y <= 500 && bulletPosition.y >= 450 {
                bullet.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
            }
            
            if bulletPosition.y > bullet.connectedEnemy2?.position.y {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet.connectedEnemy2?.position.y < 180 {
                self.health -= 1
                self.runAction(pop2SFX)
            }
            
        }
        
        for ball in obstacleLayer.children as! [Ball] {
            /* Get obstacle node position, convert node position to scene space */
            let ballPosition = obstacleLayer.convertPoint(ball.position, toNode: self)
            
            /* Check if obstacle has left the scene */
            if ballPosition.y <= 70 {
                
                health -= 1
                self.runAction(pop2SFX)
                
            }
            
            if ball.connectedEnemy?.position.y < 70  {
                self.health -= 1
            }
            
            if ball.connectedEnemy?.position.y < 600 && ball.connectedEnemy?.position.y > 550 {
                ball.connectedEnemy?.physicsBody?.velocity = CGVector(dx: 0, dy: -105)
            }
            
            if ball.connectedEnemy?.position.y <= 500 {
                ball.connectedEnemy?.physicsBody?.velocity = CGVector(dx: 0, dy: -330)
            }
            
            if ballPosition.y < 600 && ballPosition.y > 550 {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: -120)
            }
            
            if ballPosition.y <= 500 && ballPosition.y >= 450 {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
            }
            
        }
    }
    
    func updateObstacles2() {
        /* Update Obstacles */
        
        for bullet3 in obstacleLayer4.children as! [Bullet3] {
            
            let bullet3Position = obstacleLayer4.convertPoint(bullet3.position, toNode: self)
            
            if bullet3.connectedEnemy4?.position.x <= 40  {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet3Position.y > bullet3.connectedEnemy4?.position.y {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet3Position.y < 70 {
                self.health -= 1
                self.runAction(pop2SFX)
            }
            
            bullet3.connectedEnemy4?.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
            
        }
        
        for bullet2 in obstacleLayer3.children as! [Bullet2] {
            
            let bullet2Position = obstacleLayer3.convertPoint(bullet2.position, toNode: self)
            
            if bullet2.connectedEnemy3?.position.x >= 335  {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet2Position.y > bullet2.connectedEnemy3?.position.y {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet2Position.y < 70 {
                self.health -= 1
                self.runAction(pop2SFX)
            }
            
            bullet2.connectedEnemy3?.physicsBody?.velocity = CGVector(dx: 100, dy: 0)
            
        }
        
        for bullet in obstacleLayer2.children as! [Bullet] {
            
            let bulletPosition = obstacleLayer2.convertPoint(bullet.position, toNode: self)
            
            if bulletPosition.y <= 70 {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bulletPosition.y > 660 {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet.connectedEnemy2?.position.y < 600 && bullet.connectedEnemy2?.position.y > 550 {
                bullet.connectedEnemy2?.physicsBody?.velocity = CGVector(dx: 0, dy: -125)
            }
            
            if bullet.connectedEnemy2?.position.y <= 500 {
                bullet.connectedEnemy2?.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
            }
            
            if bulletPosition.y < 600 && bulletPosition.y > 550 {
                bullet.physicsBody?.velocity = CGVector(dx: 0, dy: -140)
            }
            
            if bulletPosition.y <= 500 && bulletPosition.y >= 450 {
                bullet.physicsBody?.velocity = CGVector(dx: 0, dy: -350)
            }
            
            if bulletPosition.y > bullet.connectedEnemy2?.position.y {
                health -= 1
                self.runAction(pop2SFX)
            }
            
            if bullet.connectedEnemy2?.position.y < 180 {
                self.health -= 1
                self.runAction(pop2SFX)
            }
            
        }
        
        for ball in obstacleLayer.children as! [Ball] {
            /* Get obstacle node position, convert node position to scene space */
            let ballPosition = obstacleLayer.convertPoint(ball.position, toNode: self)
            
            /* Check if obstacle has left the scene */
            if ballPosition.y <= 70 {
                
                health -= 1
                self.runAction(pop2SFX)
                
            }
            
            if ball.connectedEnemy?.position.y < 70  {
                self.health -= 1
            }
            
            if ball.connectedEnemy?.position.y < 600 && ball.connectedEnemy?.position.y > 550 {
                ball.connectedEnemy?.physicsBody?.velocity = CGVector(dx: 0, dy: -125)
            }
            
            if ball.connectedEnemy?.position.y <= 500 {
                ball.connectedEnemy?.physicsBody?.velocity = CGVector(dx: 0, dy: -380)
            }
            
            if ballPosition.y < 600 && ballPosition.y > 550 {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: -140)
            }
            
            if ballPosition.y <= 500 && ballPosition.y >= 450 {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: -350)
            }
            
        }
    }
    
    func gameOver() {
        /* Game over! */
        
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
        scoreLabel.text = "\(points)"
    }
    
    func playerLocalScoreUpdate() {
        let localScore = NSUserDefaults().integerForKey("localScore")
        if points > localScore {
            NSUserDefaults().setInteger(points, forKey: "localScore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        scoreLabel.text = "\(points)"
    }
    
    func spawnNewWave(){
        if spawnTimer >= 0.9 && waveFinished {
            
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
        if spawnTimer >= 0.9 && waveFinished {
            
            var random = arc4random_uniform(7)
            while previousNumber == random {
                random = arc4random_uniform(7)
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
            default:
                break
                
            }
            
            spawnTimer = 0
        }
    }
    
    func createNewGroup(position: CGPoint){
        
        let newBall = Ball()
        let randomPosition = position
        newBall.position = self.convertPoint(randomPosition, toNode: obstacleLayer)
        obstacleLayer.addChild(newBall)
        let newEnemy = Enemy()
        let enemyPosition = CGPoint (x: newBall.position.x+0, y: newBall.position.y+110)
        newEnemy.position = enemyPosition
        self.addChild(newEnemy)
        newBall.connectedEnemy = newEnemy
        
    }
    
    // trying to set specific x values
    /* let bulletPositionsX = [60, 100, 160]
     var index3 = 0 */
    
    func createNewBullet(position: CGPoint) {
        
        instructionsNumber += 1
        instructionsUpdate()
        let newBullet = Bullet()
        let randomPosition = position
        newBullet.position = self.convertPoint(randomPosition, toNode: obstacleLayer2)
        obstacleLayer2.addChild(newBullet)
        let newEnemy2 = Enemy2()
        // trying to set specific x values where enemies spawn compared to bullets
        let enemyPosition = CGPoint (x: newBullet.position.x+40 /* self.bulletPositionsX[index3] */, y: newBullet.position.y+200)
        newEnemy2.position = enemyPosition
        self.addChild(newEnemy2)
        newBullet.connectedEnemy2 = newEnemy2
        
    }
    
    func instructionsUpdate() {
        if instructionsNumber > 1 {
            self.instructions2.hidden = true
        }
        else if instructionsNumber <= 1 {
            self.runAction(SKAction.waitForDuration(1), completion: {() -> Void in
                self.instructions2.hidden = false
            })
        }
        
    }
    
    func createNewBullet2(position: CGPoint) {
        
        instructionsNumber += 1
        instructionsUpdate()
        let newBullet2 = Bullet2()
        let randomPosition = position
        newBullet2.position = self.convertPoint(randomPosition, toNode: obstacleLayer3)
        obstacleLayer3.addChild(newBullet2)
        let newEnemy3 = Enemy3()
        let enemyPosition = CGPoint (x: newBullet2.position.x, y: newBullet2.position.y+150)
        newEnemy3.position = enemyPosition
        self.addChild(newEnemy3)
        newBullet2.connectedEnemy3 = newEnemy3
        
    }
    
    func createNewBullet3(position: CGPoint) {
        
        instructionsNumber += 1
        instructionsUpdate()
        let newBullet3 = Bullet3()
        let randomPosition = position
        newBullet3.position = self.convertPoint(randomPosition, toNode: obstacleLayer4)
        obstacleLayer4.addChild(newBullet3)
        let newEnemy4 = Enemy4()
        let enemyPosition = CGPoint (x: newBullet3.position.x, y: newBullet3.position.y+150)
        newEnemy4.position = enemyPosition
        self.addChild(newEnemy4)
        newBullet3.connectedEnemy4 = newEnemy4
        
    }
    
    func wave1() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 335, 280, 220]
        var index = 0
        let wait = SKAction.waitForDuration(0.35)
        let wait2 = SKAction.waitForDuration(0.15)
        let run = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([wait2, run, wait, run, wait, run, wait, run, wait, run, wait, run, finish]))
        
    }
    
    func wave2() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 80, 335, 100, 280]
        var index = 0
        let wait = SKAction.waitForDuration(0.35)
        let wait2 = SKAction.waitForDuration(0.15)
        let run = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([wait2, run, run, wait, wait, run, wait, run, wait, run, finish]))
        
    }
    
    func wave3() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 280, 100, 220, 140, 180]
        var index = 0
        let wait = SKAction.waitForDuration(0.4)
        let wait2 = SKAction.waitForDuration(0.15)
        let run = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([wait2, run, wait, run, wait, run, wait, run, wait, run, run, finish]))
        
    }
    
    func wave4() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 60, 100, 250]
        var index = 0
        let wait = SKAction.waitForDuration(0.2)
        let wait2 = SKAction.waitForDuration(0.15)
        let run = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([wait2, run, wait2, run, wait, run, wait, run, finish]))
        
    }
    
    func wave5() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 100, 160]
        let wavePositionsX2 = [40, 120, 200]
        var index = 0
        var index2 = 0
        let wait = SKAction.waitForDuration(0.3)
        let wait2 = SKAction.waitForDuration(1)
        
        let run = SKAction.runBlock {
            
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        
        let run2 = SKAction.runBlock {
            
            self.createNewBullet(CGPoint(x: wavePositionsX2[index2], y: 650))
            index2 += 1
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([wait, run, wait, run, wait, run, wait2, run2, wait2, run2, wait2, run2, wait2, finish]))
        
    }
    
    func wave6() {
        
        let wavePositionsX = [200, 160, 120]
        var index = 0
        self.waveFinished = false
        
        let wait = SKAction.waitForDuration(0.3)
        let wait2 = SKAction.waitForDuration(2.1)
        let wait3 = SKAction.waitForDuration(1.2)
        let wait4 = SKAction.waitForDuration(0.4)
        
        let run = SKAction.runBlock {
            self.createNewBullet2(CGPoint(x: 40, y: 370))
            
        }
        
        let run2 = SKAction.runBlock {
            self.createNewBullet3(CGPoint(x: 335, y: 420))
            
        }
        
        let run3 = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([wait3, run, wait3, wait4, run3, wait, run3, wait, run3, wait3, wait, run2, wait2, wait4, finish]))
        
    }
    
    func wave7() {
        
        self.waveFinished = false
        
        let wavePositionsX = [100, 200]
        var index = 0
        let wait = SKAction.waitForDuration(0.3)
        let wait2 = SKAction.waitForDuration(2.3)
        let wait4 = SKAction.waitForDuration(1.5)
        let wait5 = SKAction.waitForDuration(0.2)
        let wait6 = SKAction.waitForDuration(1.2)
        
        let run = SKAction.runBlock {
            
            self.createNewBullet(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
        }
        
        let run2 = SKAction.runBlock {
            
            self.createNewBullet2(CGPoint(x: 40, y: 370))
        }
        
        let run3 = SKAction.runBlock {
            
            self.createNewBullet3(CGPoint(x: 335, y: 420))
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([wait, run, wait2, run2, wait2, run3, wait4, wait5, run, wait6, finish]))
        
    }
    
    
}


