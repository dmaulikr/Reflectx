//
//  Ball.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Ball: Shootable {
        
    init() {
        super.init(image: "ballBlue")
        name = "ball"
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func updateBallSpeed(waveNumber: Int) {
        switch waveNumber {
        case 0...4:
            if position.y < 620 && position.y > 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -125)
            }
            
            if position.y <= 500 && position.y > 450 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -340)
            }
        case 5...7:
            if position.y < 620 && position.y > 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -165)
            }
            
            if position.y <= 500 && position.y > 450 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -390)
            }
        case 8...10:
            if position.y < 620 && position.y > 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -205)
            }
            
            if position.y <= 500 && position.y > 450 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -440)
            }
        case 11...13:
            if position.y < 620 && position.y > 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -235)
            }
            
            if position.y <= 500 && position.y > 450 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -480)
            }
        default:
            if position.y < 620 && position.y > 500 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -260)
            }
            
            if position.y <= 500 && position.y > 450 {
                physicsBody?.velocity = CGVector(dx: 0, dy: -510)
            }
        }
    }
}