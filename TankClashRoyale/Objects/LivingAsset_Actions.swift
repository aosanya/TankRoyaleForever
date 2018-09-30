//
//  LivingAsset_Actions.swift
//  TankClashRoyale
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
        
        self.stopShooting()
        
        var actions = [SKAction]()
        
        let rotation = rotationToFace(cell: self.cell)
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
        
        self.stopShooting()
        
        var actions = [SKAction]()
        
        let rotation = rotationToFace(cell: to)
        
        let turnDuration = Double(abs(rotation)) / Double(self.moveSpeed * 50)
        let turnAction = SKAction.rotate(byAngle: angleToRadians(angle: rotation), duration: turnDuration)
        actions.append(turnAction)
        
        let actionComplete = SKAction.run({() in self.ActionComplete()})
        actions.append(actionComplete)
        
        let sequence = SKAction.sequence(actions)
        self.run(sequence, withKey : "moving")
    }
    
    func rotationToFace(cell : Cell) -> CGFloat{
        let facing = radiansToAngle(self.zRotation) + 270
        //let toFace = negativeAngleToPositive(angle: radiansToAngle(CGFloat(getRadAngle(self.position, pointB: to.position))))
        
        let toFace = radiansToAngle(CGFloat(getRadAngle(self.position, pointB: cell.position)))
        
        
        var rotation = toFace - facing
        var counterRotation = 0
        
        if rotation < 0{
            counterRotation = 360 + Int(rotation)
        }
        
        if rotation > 0{
            counterRotation =  Int(rotation) - 360
        }
        
        if abs(counterRotation) < abs(Int(rotation)) {
            rotation = CGFloat(counterRotation)
        }
        
        return rotation
    }
}
