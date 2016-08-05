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
    
    func addPhysicsBody () {
        
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.friction = 0
        physicsBody?.categoryBitMask = EnemyCategory
        physicsBody?.collisionBitMask = BallCategory | PaddleCategory
        physicsBody?.contactTestBitMask = BallCategory | BallTwoCategory
        physicsBody?.mass = 1
        physicsBody?.angularDamping = 0
        physicsBody?.linearDamping = 0
        physicsBody?.restitution = 1
    }
    
    func goLeftSlow() {
        physicsBody?.velocity = CGVector(dx: -70, dy: 0)
    }
    
    func goRightSlow() {
        physicsBody?.velocity = CGVector(dx: 70, dy: 0)
    }
    
    func goDownSlow() {
        physicsBody?.velocity = CGVector(dx: 0, dy: -120)
    }
    
    func goRight(waveNumber: Int) {
        switch waveNumber {
        case 0...6:
            physicsBody?.velocity = CGVector(dx: 100, dy: 0)
        case 6...13:
            physicsBody?.velocity = CGVector(dx: 103, dy: 0)
        default:
            physicsBody?.velocity = CGVector(dx: 106, dy: 0)
        }
    }
    
    func goLeft(waveNumber: Int) {
        switch waveNumber {
        case 0...6:
            physicsBody?.velocity = CGVector(dx: -100, dy: 0)
        case 6...13:
            physicsBody?.velocity = CGVector(dx: -103, dy: 0)
        default:
            physicsBody?.velocity = CGVector(dx: -106, dy: 0)
        }
    }
    
    func goDown(waveNumber: Int) {
        switch waveNumber {
        case 0...6:
            physicsBody?.velocity = CGVector(dx: 0, dy: -210)
        case 6...13:
            physicsBody?.velocity = CGVector(dx: 0, dy: -250)
        default:
            physicsBody?.velocity = CGVector(dx: 0, dy: -290)
        }
    }
    
    func updateVelocity(waveNumber: Int) {
        switch waveNumber {
        case 0...6:
            if position.y < 600 && position.y > 550 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -125)
            }
            if position.y <= 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -335)
            }
        case 6...13:
            if position.y < 600 && position.y > 550 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -175)
            }
            if position.y <= 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -385)
            }
        default:
            if position.y < 600 && position.y > 550 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -225)
            }
            if position.y <= 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -425)
            }
        }
    }
    
    // You are required to implement this for your subclass to work
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}



