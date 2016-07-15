//
//  Enemy.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/14/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
        
    init() {
        
        let texture = SKTexture(imageNamed: "cloud")
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 40, height: 12))
        zPosition = 1
        addPhysicsBody()
    }
    
    func addPhysicsBody () {
        
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.friction = 0
        physicsBody?.categoryBitMask = 8
        physicsBody?.contactTestBitMask = 8
        physicsBody?.velocity = CGVector(dx: 0, dy: -200)
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
