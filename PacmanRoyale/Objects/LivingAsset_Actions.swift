//
//  LivingAsset_Actions.swift
//  PacManRoyale
//
//  Created by Anthony on 10/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol LivingAsset_Actions{
    
}

extension LivingAsset : LivingAsset_Actions{
    func angleToFace(point : CGPoint) -> CGFloat{
        let facing = radiansToAngle(self.zRotation) + 270
        let toFace = negativeAngleToPositive(angle: radiansToAngle(CGFloat(getRadAngle(self.position, pointB: point))))
        let rotation = toFace - facing
        return rotation
    }
    
    func moveToCell(){
        guard isPerformingAction() == false else {
            return
        }
        
        var actions = [SKAction]()
        
        let rotation = angleToFace(point: self.cell.position)
        let turnDuration = Double(abs(rotation)) / Double(self.moveSpeed * 50)
        let turnAction = SKAction.rotate(byAngle: angleToRadians(angle: rotation), duration: turnDuration)
        actions.append(turnAction)
        
        let dist = getDistance(self.position, pointB: self.cell.position)
        let moveDuration = Double(dist) / Double(self.moveSpeed * 50)
        actions.append(SKAction.move(to: self.cell.position, duration: moveDuration))
        
        let actionComplete = SKAction.run({() in self.ActionComplete()})
        actions.append(actionComplete)
        
        let sequence = SKAction.sequence(actions)
        self.run(sequence, withKey : "moving")
    }
    
    
    func turn(to : Cell){
        guard isPerformingAction() == false else {
            return
        }
        
        var actions = [SKAction]()
        
        let facing = radiansToAngle(self.zRotation) + 270
        let toFace = negativeAngleToPositive(angle: radiansToAngle(CGFloat(getRadAngle(self.position, pointB: to.position))))
        let rotation = toFace - facing
        let turnDuration = Double(abs(rotation)) / Double(self.moveSpeed * 50)
        let turnAction = SKAction.rotate(byAngle: angleToRadians(angle: rotation), duration: turnDuration)
        actions.append(turnAction)
        
        let actionComplete = SKAction.run({() in self.ActionComplete()})
        actions.append(actionComplete)
        
        let sequence = SKAction.sequence(actions)
        self.run(sequence, withKey : "moving")
    }
    
    
    
}
