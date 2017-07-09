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
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 50, height: 25))
        
        zPosition = 1
        addPhysicsBody()
        name = "enemy"
    }
    
    func addPhysicsBody () {
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = true
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
        physicsBody?.velocity = CGVector(dx: -60, dy: 0)
    }
    
    func goRightSlow() {
        physicsBody?.velocity = CGVector(dx: 60, dy: 0)
    }
    
    func goDownSlow() {
        physicsBody?.velocity = CGVector(dx: 0, dy: -100)
    }
    
    func goRight(_ waveNumber: Int) {
        switch waveNumber {
        case 0...4:
            physicsBody?.velocity = CGVector(dx: 95, dy: 0)
        case 5...7:
            physicsBody?.velocity = CGVector(dx: 98, dy: 0)
        case 8...10:
            physicsBody?.velocity = CGVector(dx: 101, dy: 0)
        case 11...13:
            physicsBody?.velocity = CGVector(dx: 104, dy: 0)
        default:
            physicsBody?.velocity = CGVector(dx: 106, dy: 0)
        }
    }
    
    func goRightSpecial(_ waveNumber: Int) {
        switch waveNumber {
        case 0...4:
            physicsBody?.velocity = CGVector(dx: 95, dy: -15)
        case 5...7:
            physicsBody?.velocity = CGVector(dx: 98, dy: -15)
        case 8...10:
            physicsBody?.velocity = CGVector(dx: 101, dy: -15)
        case 11...13:
            physicsBody?.velocity = CGVector(dx: 104, dy: -15)
        default:
            physicsBody?.velocity = CGVector(dx: 106, dy: -15)
        }
    }
    
    func goLeft(_ waveNumber: Int) {
        switch waveNumber {
        case 0...4:
            physicsBody?.velocity = CGVector(dx: -100, dy: 0)
        case 5...7:
            physicsBody?.velocity = CGVector(dx: -103, dy: 0)
        case 8...10:
            physicsBody?.velocity = CGVector(dx: -106, dy: 0)
        case 11...13:
            physicsBody?.velocity = CGVector(dx: -109, dy: 0)
        default:
            physicsBody?.velocity = CGVector(dx: -111, dy: 0)
        }
    }
    
    func goLeftSpecial(_ waveNumber: Int) {
        switch waveNumber {
        case 0...4:
            physicsBody?.velocity = CGVector(dx: -100, dy: -12)
        case 5...7:
            physicsBody?.velocity = CGVector(dx: -103, dy: -12)
        case 8...10:
            physicsBody?.velocity = CGVector(dx: -106, dy: -12)
        case 11...13:
            physicsBody?.velocity = CGVector(dx: -109, dy: -12)
        default:
            physicsBody?.velocity = CGVector(dx: -111, dy: -12)
        }
    }
    
    func goDown(_ waveNumber: Int) {
        switch waveNumber {
        case 0...4:
            physicsBody?.velocity = CGVector(dx: 0, dy: -210)
        case 5...7:
            physicsBody?.velocity = CGVector(dx: 0, dy: -220)
        case 8...10:
            physicsBody?.velocity = CGVector(dx: 0, dy: -225)
        case 11...13:
            physicsBody?.velocity = CGVector(dx: 0, dy: -235)
        default:
            physicsBody?.velocity = CGVector(dx: 0, dy: -245)
        }
    }
    
    func updateVelocity(_ waveNumber: Int) {
        switch waveNumber {
        case 0...4:
            if position.y < 600 && position.y > 550 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -115)
            }
            if position.y <= 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -345)
            }
        case 5...7:
            if position.y < 600 && position.y > 550 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -165)
            }
            if position.y <= 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -395)
            }
        case 8...10:
            if position.y < 600 && position.y > 550 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -225)
            }
            if position.y <= 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -425)
            }
        case 11...13:
            if position.y < 600 && position.y > 550 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -260)
            }
            if position.y <= 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -455)
            }
        default:
            if position.y < 600 && position.y > 550 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -295)
            }
            if position.y <= 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -480)
            }
        }
    }
    
    // You are required to implement this for your subclass to work
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}



