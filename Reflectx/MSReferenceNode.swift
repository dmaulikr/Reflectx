//
//  MSReferenceNode.swift
//  Reflectx
//
//  Created by Jacky Chen on 7/13/16.
//  Copyright © 2016 Jacky. All rights reserved.
//

import SpriteKit

class MSReferenceNode: SKReferenceNode {
    
    var blackBall: SKSpriteNode!
    
    override func didLoadReferenceNode(node: SKNode?) {
        
        blackBall = childNodeWithName("//blackBall") as! SKSpriteNode
    }
}