//
//  Actions.swift
//  TankClashRoyale
//
//  Created by Anthony on 26/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

func scaleAction(size : CGFloat, speed : Double) -> SKAction{
    return SKAction.scale(to: size, duration: speed)
}

func blinkSmallerAction(speed : Double = 1, scale : CGFloat = 0.95) -> SKAction{
    let action1 = SKAction.scale(to: scale, duration: 0.1 * speed)
    let action2 = SKAction.scale(to: 1, duration: 0.15 * speed)
    let action3 = SKAction.sequence([action1,action2])
    return action3
}

func blinkLargerAction(speed : Double = 1, scale : CGFloat = 1.1) -> SKAction{
    let action1 = SKAction.scale(to: scale, duration: 0.1 * speed)
    let action2 = SKAction.scale(to: 1, duration: 0.3 * speed)
    let action3 = SKAction.sequence([action1,action2])
    return action3
}

func blinkAction(_ speed : Double) -> [SKAction]{
    let action1 = SKAction.scale(to: 1.1, duration: 1 / speed)
    let action2 = SKAction.scale(to: 1, duration: 2 / speed)
    let fade1 = SKAction.fadeAlpha(to: 1, duration: 1 / speed)
    let fade2 = SKAction.fadeAlpha(to: 0, duration: 2 / speed)
    
    var actions = [SKAction]()
    actions.append(SKAction.sequence([fade1,fade2]))
    actions.append(SKAction.sequence([action1,action2]))
    return actions
}

func blinkAction(from : CGFloat, to : CGFloat, _ speed : Double) -> [SKAction]{
    let action1 = SKAction.scale(to: 1.1, duration: 1 / speed)
    let action2 = SKAction.scale(to: 1, duration: 2 / speed)
    let fade1 = SKAction.fadeAlpha(to: from, duration: 1 / speed)
    let fade2 = SKAction.fadeAlpha(to: to, duration: 2 / speed)
    
    var actions = [SKAction]()
    actions.append(SKAction.sequence([fade1,fade2]))
    actions.append(SKAction.sequence([action1,action2]))
    return actions
}

func stopBlinking(speed : Double = 1) -> [SKAction]{
    let action = SKAction.scale(to: 1, duration: 2 / speed)
    let fade1 = SKAction.fadeAlpha(to: 1, duration: 1 / speed)
    
    var actions = [SKAction]()
    actions.append(SKAction.sequence([fade1]))
    actions.append(SKAction.sequence([action]))
    return actions
}


