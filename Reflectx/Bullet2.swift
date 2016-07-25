//
//  Bullet.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/19/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Bullet2: SKSpriteNode {
    
    var connectedEnemy3 : Enemy3?
    
    init() {
        
        let texture = SKTexture(imageNamed: "ballYellow")
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 15, height: 15))
        zPosition = 2
        addPhysicsBody()
        name = "bullet2"
    }
    
    func addPhysicsBody () {
        
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.friction = 0
        physicsBody?.categoryBitMask = BulletCategory
        physicsBody?.collisionBitMask = EnemyCategory | PaddleCategory
        physicsBody?.contactTestBitMask = EnemyCategory
        physicsBody?.velocity = CGVector(dx: 0, dy: -250)
        physicsBody?.mass = 1
        physicsBody?.angularDamping = 0
        physicsBody?.linearDamping = 0
        physicsBody?.restitution = 1
        
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}