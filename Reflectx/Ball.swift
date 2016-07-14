//
//  Ball.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    var connectedEnemy : SKSpriteNode?
    
    init() {

        let texture = SKTexture(imageNamed: "ballBlue")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        zPosition = 1
        
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}