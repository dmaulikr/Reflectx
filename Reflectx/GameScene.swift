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
    var scoreLabel: SKLabelNode!
    var points = 0
    var isFingerOnPaddle = false
    var pauseButton: MSButtonNode!
    var instructions: SKLabelNode!
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
    
    override func didMoveToView(view: SKView) {
        /* Set up your scene here */
        
        physicsWorld.contactDelegate = self
        paddleBlue = self.childNodeWithName("//paddleBlue") as! SKSpriteNode
        obstacleLayer = self.childNodeWithName("obstacleLayer")
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        smallLeftArrow = self.childNodeWithName("smallLeftArrow") as! SKSpriteNode
        smallRightArrow = self.childNodeWithName("smallRightArrow") as! SKSpriteNode
        instructions = self.childNodeWithName("instructions") as! SKLabelNode
        scoreLabel.text = String(points)
        pauseButton = childNodeWithName("pauseButton") as! MSButtonNode
        
        pauseButton.selectedHandler = {
            self.paused = !self.paused
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "localScore")
        
        self.state = .Playing
        
        // test
        
        /* let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("highScore") as! Int
         highScoreLabel.text = String(savedScore)
         
         func playerLocalScoreUpdate() {
         let localScore = NSUserDefaults().integerForKey("localScore")
         if points > localScore {
         NSUserDefaults().setInteger(points, forKey: "localScore")
         NSUserDefaults.standardUserDefaults().synchronize()
         }
         scoreLabel.text = "\(points)"
         } */
        
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
                bullet.physicsBody?.velocity = CGVectorMake(0, 200)
            }
                
            else if let bullet = bulletJoint.bodyB.node as? Bullet {
                bullet.physicsBody?.velocity = CGVectorMake(0, 200)
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
        spawnNewWave()
        updateObstacles()
        
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
        
        /* Check if either physics bodies was an enemy */
        if contactA.categoryBitMask == BallCategory || contactB.categoryBitMask == BallCategory {
            
            if contact.collisionImpulse > 0 {
                
                if contactA.categoryBitMask == BallCategory || contactA.categoryBitMask == EnemyCategory { dieEnemy(nodeA)
                }
                if contactB.categoryBitMask == BallCategory || contactB.categoryBitMask == EnemyCategory { dieEnemy(nodeB)
                }
                
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
        
        let enemyDeath = SKAction.runBlock({
            node.removeFromParent()
        })
        
        self.runAction(enemyDeath)
        
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        // make it so - health when bullet/enemy 2
        /*  for bullet in self.children as! [Bullet] {
         let bulletPosition = obstacleLayer.convertPoint(bullet.position, toNode: self)
         
         if bulletPosition.y <= 70 {
         bullet.connectedEnemy2?.removeFromParent()
         bullet.removeFromParent()
         health -= 1
         self.runAction(pop2SFX)
         }
         
         } */
        
        for ball in obstacleLayer.children as! [Ball] {
            /* Get obstacle node position, convert node position to scene space */
            let ballPosition = obstacleLayer.convertPoint(ball.position, toNode: self)
            
            /* Check if obstacle has left the scene */
            if ballPosition.y <= 70 {
                
                ball.connectedEnemy?.removeFromParent()
                ball.removeFromParent()
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
                ball.connectedEnemy?.physicsBody?.velocity = CGVector(dx: 0, dy: -320)
            }
            
            if ballPosition.y < 600 && ballPosition.y > 550 {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: -115)
            }
            
            if ballPosition.y <= 500 && ballPosition.y >= 450 {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: -280)
            }
        }
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .GameOver
        let skView = self.view as SKView!
        let scene = EndScene(fileNamed:"EndScene") as EndScene!
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
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
        if spawnTimer >= 0.9 && waveFinished { // change to more seconds cause real iphone different
            
            var random = arc4random_uniform(2) // 4 or 5 // 2
            while previousNumber == random {
                random = arc4random_uniform(2) // 4 or 5 // 2
            }
            
            previousNumber = random
            
            switch (random) {
                
            case 0:
                wave5() // 5 // 1
            case 1:
                wave2()
            case 2:
                wave3()
            case 3:
                wave4()
            case 4:
                wave5()
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
    
    func createNewBullet(position: CGPoint) {
        
        let newBullet = Bullet()
        let randomPosition = position
        newBullet.position = self.convertPoint(randomPosition, toNode: obstacleLayer)
        self.addChild(newBullet)
        let newEnemy2 = Enemy2()
        let enemyPosition = CGPoint (x: newBullet.position.x+0, y: newBullet.position.y+110)
        newEnemy2.position = enemyPosition
        self.addChild(newEnemy2)
        newBullet.connectedEnemy2 = newEnemy2
        
    }
    
    func wave1() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 100, 160, 335, 280, 220]
        var index = 0
        let wait = SKAction.waitForDuration(0.35)
        let run = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
        }
        
        self.runAction(SKAction.sequence([wait, run, wait, run, wait, run, wait, run, wait, run, wait, run, finish]))
        
    }
    
    func wave2() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 80, 335, 100, 280]
        var index = 0
        let wait = SKAction.waitForDuration(0.35)
        let run = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
        }
        
        self.runAction(SKAction.sequence([wait, run, run, wait, wait, run, wait, run, wait, run, finish]))
        
    }
    
    func wave3() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 280, 100, 220, 140, 180]
        var index = 0
        let wait = SKAction.waitForDuration(0.4)
        let run = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
        }
        
        self.runAction(SKAction.sequence([wait, run, wait, run, wait, run, wait, run, wait, run, run, finish]))
        
    }
    
    func wave4() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 60, 100, 250]
        var index = 0
        let wait = SKAction.waitForDuration(0.25)
        let run = SKAction.runBlock {
            self.createNewGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
        }
        
        self.runAction(SKAction.sequence([wait, run, wait, run, wait, run, wait, run, finish]))
        
    }
    
    func wave5() {
        
        self.waveFinished = false
        
        let wavePositionsX = [60, 100, 160]
        var index = 0
        let wait = SKAction.waitForDuration(0.3)
        let run = SKAction.runBlock {
            self.createNewBullet(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
        }
        
        self.runAction(SKAction.sequence([wait, run, wait, run, wait, run, finish]))
        
    }
    
    
}


