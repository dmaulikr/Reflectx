//
//  Shootable.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/27/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Shootable: SKSpriteNode {
    
    init(image: String) {
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 18, height: 18))
        zPosition = 1
        name = "shootable"
        addPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func updateBallSpeed () {
        if position.y < 620 && position.y > 500 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -125)
        }
        
        if position.y <= 500 && position.y > 450 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -370)
        }
    }
    
    func updateBulletSpeed () {
        if position.y < 650 && position.y > 666 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -300)
        }
        
    }
    
}




