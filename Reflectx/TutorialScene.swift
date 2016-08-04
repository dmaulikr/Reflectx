//
//  TutorialScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene, SKPhysicsContactDelegate {
    
    var state: GameState = .Title
    var wavesDone = 0
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
    
    override func didMoveToView(view: SKView) {
        /* Set up your scene here */
        
        physicsWorld.contactDelegate = self
        paddle = self.childNodeWithName("//paddle") as! SKSpriteNode
        obstacleLayer = self.childNodeWithName("obstacleLayer")
        UILayer2 = self.childNodeWithName("UI") as! UIClassTutorial
        homeButton = self.childNodeWithName("homeButton") as! MSButtonNode
        playButton2 = self.childNodeWithName("playButton2") as! MSButtonNode
        playButtonBack2 = self.childNodeWithName("playButtonBack2") as! MSButtonNode
        
        homeButton.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = MainScene(fileNamed:"MainScene") as MainScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        playButton2.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        playButtonBack2.selectedHandler = {
            
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            scene.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
            skView.presentScene(scene, transition: transition)
            
        }
        
        playButton2.hidden = true
        playButtonBack2.hidden = true
        
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
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if isFingerOnPaddle {
            let touch = touches.first
            let touchLocation = touch!.locationInNode(self)
            let previousLocation = touch!.previousLocationInNode(self)
            let paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
            
            UILayer2.hideArrows ()
            
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
        if wavesDone < 1 {
            spawnNewWave()
        }
        
        // stage 2
        if wavesDone == 1 {
            spawnNewWave2()
        }
        
        if wavesDone == 2 {
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
        points += 1
        self.runAction(popSFX)
        dieEnemy(enemy)
        dieEnemy(shootable)
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
            }
                
            else if let enemy = obstacle as? Enemy {
                if enemy.position.y < 180 {
                    health -= 1
                    self.runAction(pop2SFX)
                }
            }
                
            else if let ball = obstacle as? Ball {
                if ball.position.y <= 70 {
                    health -= 1
                    self.runAction(pop2SFX)
                }
            }
        }
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .Restart
        let skView = self.view as SKView!
        let scene = TutorialScene(fileNamed:"TutorialScene") as TutorialScene!
        scene.scaleMode = .AspectFill
        self.runAction(pop2SFX)
        let transition = SKTransition.fadeWithColor(UIColor.darkGrayColor(), duration: 0.6)
        skView.presentScene(scene, transition: transition)

    }
    
    func gameDone() {
        playButton2.hidden = false
        playButtonBack2.hidden = false
    }
    
    func spawnNewWave(){
        if spawnTimer >= 1.5 && waveFinished {
            
            wave1()
            spawnTimer = 0
            
        }
    }
    
    func spawnNewWave2(){
        
        if spawnTimer >= 1.5 {
            UILayer2.instructionsUpdate()
        } 
        
        if spawnTimer >= 2 && waveFinished {
            
            wave2()
            spawnTimer = 0
            
        }
    }
    
    func spawnNewWave3(){
        if spawnTimer >= 2 && waveFinished {
            
            wave3()
            spawnTimer = 0
            
        }
    }
    
    func createBallGroup(position: CGPoint){
        let newBall = createBall(position)
        let newEnemy = Enemy(imageName: "cloud")
        let enemyPosition = CGPoint (x: newBall.position.x+0, y: newBall.position.y+100)
        newEnemy.position = enemyPosition
        obstacleLayer.addChild(newEnemy)
        newEnemy.goDown()
        newEnemy.shootable = newBall
    }
    
    func createBulletGroup(position: CGPoint) -> Enemy{
        let bullet = createBullet(position)
        let enemy = createEnemy(CGPoint(x: bullet.position.x+40, y: bullet.position.y+100))
        enemy.shootable = bullet
        return enemy
    }
    
    func createBall(position: CGPoint) -> Ball {
        let newBall = Ball()
        newBall.position = position
        obstacleLayer.addChild(newBall)
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
        
        let wavePositionsX = [40, 130, 220, 120, 170]
        var index = 0
        let wait = SKAction.waitForDuration(1)
        let run = SKAction.runBlock {
            self.createBallGroup(CGPoint(x: wavePositionsX[index], y: 650))
            index += 1
            
        }
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([run, wait, run, wait, run, wait, run, run, finish]))
        
    }
    
    func wave2() {
        
        self.waveFinished = false
        
        let wavePositionsX = [40, 120]
        var index = 0
        let wait = SKAction.waitForDuration(3.5)
        
        let run = SKAction.runBlock {
            
            let enemy = self.createBulletGroup(CGPoint(x: wavePositionsX[index], y: 650))
            
            enemy.goDownSlow()
            
            index += 1
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([run, wait, run, wait, finish]))
        
    }
    
    func wave3() {
        
        self.waveFinished = false
        
        let run = SKAction.runBlock {
            let enemy = self.createBulletGroup(CGPoint(x: 345, y: 485))
            enemy.goLeftSlow()
        }
        
        let finish = SKAction.runBlock {
            self.waveFinished = true
            self.wavesDone += 1
        }
        
        self.runAction(SKAction.sequence([run, finish]))
        
    }
    
    
}


