//
//  Ball.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Bullet: Shootable {
    
    init() {
        super.init(image: "ballYellow")
        name = "bullet"
        addPhysicsBody()
    }
    
    let savedWavesDone2: Int = NSUserDefaults.standardUserDefaults().objectForKey("wavesDone2") as! Int
    
    override func addPhysicsBody () {
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.friction = 0
        physicsBody?.categoryBitMask = BulletCategory
        physicsBody?.collisionBitMask = EnemyCategory | PaddleCategory
        physicsBody?.contactTestBitMask = EnemyCategory
        physicsBody?.velocity = CGVector(dx: 0, dy: -320)
        
        if savedWavesDone2 <= 6 {
            self.updateBulletSpeed()
        }
            
        else if savedWavesDone2 > 6 && savedWavesDone2 <= 13 {
            self.updateBulletSpeed2()
        }
            
        else if savedWavesDone2 > 13 {
            self.updateBulletSpeed3()
        }
        
        physicsBody?.mass = 1
        physicsBody?.angularDamping = 0
        physicsBody?.linearDamping = 0
        physicsBody?.restitution = 1
        
        
    }
    
    func updateBulletSpeed () {
        if position.y < 650 && position.y > 666 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -320)
        }
        
    }
    
    func updateBulletSpeed2 () {
        if position.y < 650 && position.y > 666 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -380)
        }
        
    }
    
    func updateBulletSpeed3 () {
        if position.y < 650 && position.y > 666 {
            physicsBody?.velocity = CGVector(dx: 0, dy: -430)
        }
        
    }

    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}