//
//  Ball.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    var connectedEnemy : Enemy?
    
    init() {
        let texture = SKTexture(imageNamed: "ballBlue")
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 20, height: 20))
        zPosition = 1
        addPhysicsBody()
        name = "ball"
    }
    
    func addPhysicsBody () {
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.friction = 0
        physicsBody?.categoryBitMask = BallCategory 
        physicsBody?.collisionBitMask = EnemyCategory | PaddleCategory
        physicsBody?.contactTestBitMask = EnemyCategory
        physicsBody?.velocity = CGVector(dx: 0, dy: -250)
        physicsBody?.mass = 1
        physicsBody?.angularDamping = 0
        physicsBody?.linearDamping = 0
        physicsBody?.restitution = 1
    }
    
    func updateVelocity () {
        if connectedEnemy?.position.y < 600 && connectedEnemy?.position.y > 550 {
            connectedEnemy?.physicsBody?.velocity = CGVector(dx: 0, dy: -105)
        }
        
        if connectedEnemy?.position.y <= 500 {
            connectedEnemy?.physicsBody?.velocity = CGVector(dx: 0, dy: -330)
        }
        
        if position.y < 600 && position.y > 550 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -120)
        }
        
        if position.y <= 500 && position.y >= 450 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -300)
        }
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}