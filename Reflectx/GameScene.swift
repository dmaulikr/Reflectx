//
//  GameScene.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright (c) 2016 Jacky. All rights reserved.
//

import SpriteKit

enum GameState {
    case Title, Playing, GameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddle: SKSpriteNode!
    var sinceTouch : CFTimeInterval = 0
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0 // 60 FPS, fix later on (phones with 40 fps etc)
    var obstacleLayer: SKNode!
    var scoreLabel: SKLabelNode!
    var points = 0
    var isFingerOnPaddle = false
    var pauseButton: MSButtonNode!
    var instructions: SKLabelNode!
    var health: Int = 1
    var state: GameState = .Title
    let paddleName: String = "paddle"
    let popSFX = SKAction.playSoundFileNamed("pop", waitForCompletion: false)
    let pop2SFX = SKAction.playSoundFileNamed("pop2", waitForCompletion: false)
    let successSFX = SKAction.playSoundFileNamed("success", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        /* Set up your scene here */
        
        physicsWorld.contactDelegate = self
        paddle = self.childNodeWithName("//paddle") as! SKSpriteNode
        obstacleLayer = self.childNodeWithName("obstacleLayer")
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        instructions = self.childNodeWithName("instructions") as! SKLabelNode
        scoreLabel.text = String(points)
        pauseButton = childNodeWithName("pauseButton") as! MSButtonNode
        
        pauseButton.selectedHandler = {
            self.paused = !self.paused
        }
        
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
            let paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            /* print("paddle-> " + String(paddleX) + " vs " + String(size.width - paddle.size.width/2))
             paddleX = min(paddleX, size.width - paddle.size.width/2)
             print("paddle-> " + String(paddleX))
             
             paddleX = max(paddleX, paddle.size.width/2)
             print("paddle-> " + String(paddleX))
             print(String(paddle.size.width/2)) */
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if state != .Playing {
            return
        }
        
        /* Update last touch timer */
        sinceTouch+=fixedDelta
        
        /* Process obstacles */
        spawnNewBall()
        updateObstacles()
        
        spawnTimer += fixedDelta
        
        if health == 0 {
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
        
        /* Check if either physics bodies was an enemy */
        if contactA.categoryBitMask == 8 || contactB.categoryBitMask == 8 {
            
            /* Was the collision more than a gentle nudge? */
            if contact.collisionImpulse > 0 {
                
                /* Kill Enemy(s) */
                if contactA.categoryBitMask == 8 { dieEnemy(nodeA) }
                if contactB.categoryBitMask == 8 { dieEnemy(nodeB) }
                
                points += 1
                scoreLabel.text = String(points)
                
                self.runAction(popSFX)
                
                if points == 5 || points == 10 || points == 20 || points == 40 || points == 80 {

                    self.runAction(successSFX)
                    
                }
                
                if points >= 5 {
                    scoreLabel.fontColor = UIColor.greenColor()
                }
                
                if points >= 10 {
                    scoreLabel.fontColor = UIColor.orangeColor()
                    
                }
                
                if points >= 20 {
                    scoreLabel.fontColor = UIColor.blueColor()
                    
                }
                
                if points >= 40 {
                    scoreLabel.fontColor = UIColor.redColor()
                    
                }
                
                if points >= 80 {
                    scoreLabel.fontColor = UIColor.yellowColor()
                    
                }
            }
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
        }
    }
    
    func spawnNewBall(){
        if spawnTimer >= 0.25 { // change to more seconds cause real iphone different
            let ballPosition = makeNewBall()
            makeNewEnemy(ballPosition)
            
            // Reset spawn timer
            spawnTimer = 0
        }
    }
    
    func makeNewBall() -> Ball{
        let newBall = Ball()
        let randomPosition = CGPointMake(CGFloat.random(min: 50, max: 325), 600)
        newBall.position = self.convertPoint(randomPosition, toNode: obstacleLayer)
        newBall.size = CGSize(width: 15, height: 15)
        newBall.physicsBody = SKPhysicsBody(rectangleOfSize: newBall.size)
        newBall.physicsBody?.affectedByGravity = false
        newBall.physicsBody?.dynamic = true
        newBall.physicsBody?.friction = 0
        newBall.physicsBody?.categoryBitMask = 8
        newBall.physicsBody?.contactTestBitMask = 8
        newBall.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
        newBall.physicsBody?.mass = 1
        newBall.physicsBody?.angularDamping = 0
        newBall.physicsBody?.linearDamping = 0
        newBall.physicsBody?.restitution = 1 
        
        obstacleLayer.addChild(newBall)
        
        return newBall
    }
    
    func makeNewEnemy(ball: Ball) {
        
        let newEnemy = SKSpriteNode(texture: SKTexture(imageNamed: "enemy"))
        let enemyPosition = CGPoint (x: ball.position.x+0, y: ball.position.y+10)
        newEnemy.position = enemyPosition
        newEnemy.size = CGSize(width: 40, height: 12)
        newEnemy.physicsBody = SKPhysicsBody(rectangleOfSize: newEnemy.size)
        newEnemy.physicsBody?.affectedByGravity = false
        newEnemy.physicsBody?.dynamic = true
        newEnemy.physicsBody?.friction = 0
        newEnemy.physicsBody?.categoryBitMask = 8
        newEnemy.physicsBody?.contactTestBitMask = 8
        newEnemy.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
        newEnemy.physicsBody?.mass = 1
        newEnemy.physicsBody?.angularDamping = 0
        newEnemy.physicsBody?.linearDamping = 0
        newEnemy.physicsBody?.restitution = 1
        
        self.addChild(newEnemy)
        
        ball.connectedEnemy = newEnemy
        
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .GameOver
        
        /* Grab reference to the SpriteKit view */
        let skView = self.view as SKView!
        
        /* Load Game scene */
        let scene = GameScene(fileNamed:"GameScene") as GameScene!
        
        /* Ensure correct aspect mode */
        scene.scaleMode = .AspectFill
        
        /* Restart GameScene */
        skView.presentScene(scene)
        
    }
}

