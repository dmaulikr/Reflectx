//
//  Enemy.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/14/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    var shootable: Shootable? 
    
    init(imageName: String) {
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 50, height: 25))
        
        zPosition = 1
        addPhysicsBody()
        name = "enemy"
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func addPhysicsBody () {
        
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.friction = 0
        physicsBody?.categoryBitMask = EnemyCategory
        physicsBody?.collisionBitMask = BallCategory | PaddleCategory
        physicsBody?.contactTestBitMask = BallCategory
        physicsBody?.mass = 1
        physicsBody?.angularDamping = 0
        physicsBody?.linearDamping = 0
        physicsBody?.restitution = 1
    }
    
    func goLeft () {
        physicsBody?.velocity = CGVector(dx: -100, dy: 0)
    }
    
    func goRight () {
        physicsBody?.velocity = CGVector(dx: 100, dy: 0)
    }
    
    func goDown() {
        physicsBody?.velocity = CGVector(dx: 0, dy: -240)
    }
    
    func updateVelocity () {
        
        if position.y < 600 && position.y > 550 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -125)
        }
        
        if position.y <= 500 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -335)
        }
    }
    
    func goLeft2 () {
        physicsBody?.velocity = CGVector(dx: -120, dy: 0)
    }
    
    func goRight2 () {
        physicsBody?.velocity = CGVector(dx: 120, dy: 0)
    }
    
    func goDown2() {
        physicsBody?.velocity = CGVector(dx: 0, dy: -260)
    }
    
    func updateVelocity2 () {
        
        if position.y < 600 && position.y > 550 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -175)
        }
        
        if position.y <= 500 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -385)
        }
    }
 
     // You are required to implement this for your subclass to work
     required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     
     }
    
    }

    

