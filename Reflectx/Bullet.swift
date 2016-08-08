//
//  Ball.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Bullet: Shootable {
    
    init(waveNumber: Int) {
        super.init(image: "ballYellow")
        name = "bullet"
        addPhysicsBody()
    }
    
    let savedWavesDone2: Int = NSUserDefaults.standardUserDefaults().integerForKey("wavesDone2")
    
    override func addPhysicsBody () {
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.friction = 0
        physicsBody?.categoryBitMask = BulletCategory
        physicsBody?.collisionBitMask = EnemyCategory | PaddleCategory
        physicsBody?.contactTestBitMask = EnemyCategory
        physicsBody?.velocity = CGVector(dx: 0, dy: -380)
        physicsBody?.mass = 1
        physicsBody?.angularDamping = 0
        physicsBody?.linearDamping = 0
        physicsBody?.restitution = 1
        
    }
    
    func updateBulletSpeed(waveNumber: Int) {
        switch waveNumber {
        case 0...4:
            if position.y < 650 && position.y > 666 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -380)
            }
        case 5...7:
            if position.y < 650 && position.y > 666 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -430)
            }
        case 8...10:
            if position.y < 650 && position.y > 666 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -480)
            }
        case 11...13:
            if position.y < 650 && position.y > 666 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -530)
            }
        default:
            if position.y < 650 && position.y > 666 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -560)
            }
        }
    }

    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}