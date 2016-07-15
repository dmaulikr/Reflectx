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
        
        obstacleLayer.addChild(newBall)
        
        return newBall
    }
    
    func makeNewEnemy(ball: Ball) -> Enemy{
        
        let newEnemy = Enemy()
        let enemyPosition = CGPoint (x: ball.position.x+0, y: ball.position.y+10)
        newEnemy.position = enemyPosition
        
        self.addChild(newEnemy)
        
        ball.connectedEnemy = newEnemy
        
        return newEnemy
        
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .GameOver
        let skView = self.view as SKView!
        let scene = EndScene(fileNamed:"EndScene") as EndScene!
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
    }
    
}

