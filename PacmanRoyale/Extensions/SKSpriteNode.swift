//
//  SKSpriteNode.swift
//  PacManRoyale
//
//  Created by Anthony on 19/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    
    func addGlow(radius: Float = 1) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
    
    func scale(to : CGFloat, duration : Double){
        let action = SKAction.scale(to: to, duration: duration)
        self.run(action)
    }
    
    func popOut(duration : Double){
        let action1 = SKAction.scale(to: 1.25, duration: 0.4 * duration)
        let action2 = SKAction.scale(to: 1.15, duration: 0.6 * duration)
        self.run(SKAction.sequence([action1, action2]))
    }
}
