//
//  Cell_State.swift
//  TankClashRoyale
//
//  Created by Anthony on 18/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol Cell_State {
    
}

extension Cell : Cell_State{
    
    func objectState() -> UInt{
        var state : UInt = 0
        if self.object != nil{
            switch self.object!.type{
                case .aidKit:
                    state = state | StateTypes.hasAidKit.mask()
                case .bomb:
                    state = state | StateTypes.hasBomb.mask()
                case .tank1, .tank2, .tank3, .cell, .shot: ()
            }
        }
        return state
    }
    
    func assetCreationState() -> UInt{
        var state : UInt = 0
        if self.action(forKey: "creatingMyCells") != nil {
            state =  state | StateTypes.isCreatingMine.mask()
        }
        if self.action(forKey: "creatingEnemyCells") != nil {
            state =  state | StateTypes.isCreatingEnemy.mask()
        }
        return state
    }
    
    func assetState(requestingAsset : Asset) -> UInt{
        var state : UInt = 0
        if self.asset != nil{
            let actualAsset = self.asset! as! Asset
            switch self.asset!.type{
            case .tank1:
                    state =  state | StateTypes.hasTank1.mask()
            case .tank2:
                state =  state | StateTypes.hasTank2.mask()
            case .tank3:
                state =  state | StateTypes.hasTank3.mask()
            case .shot : ()
            case .cell : ()
            case .aidKit : ()
            case .bomb : ()
            }
            
            if (self.asset as! LivingAsset).prevCell != nil {
                state =  state | StateTypes.assetIsMoving.mask()
            }
            //Team
            if actualAsset.isMine == requestingAsset.isMine{
                state =  state | StateTypes.hasMyAsset.mask()
            }
            else{
                state =  state | StateTypes.hasEnemyAsset.mask()
            }
            
            //Strength
            if requestingAsset.strength < self.asset!.strength{
                state =  state | StateTypes.hasStrongerAsset.mask()
            }
            else if requestingAsset.strength > self.asset!.strength{
                state =  state | StateTypes.hasWeakerAsset.mask()
            }
            else{// are equal
                state =  state | StateTypes.hasEqualAsset.mask()
            }
            
            //Life
            if  let livingAsset = asset as? LivingAsset{
                if livingAsset.initialized  {
                    if livingAsset.state <= 25{
                        state =  state | StateTypes.hasLifeLessThan25.mask()
                    }
                    else if livingAsset.state > 25{
                        state =  state | StateTypes.hasLifeGreaterThan25.mask()
                    }
                    else if livingAsset.state > 50{
                        state =  state | StateTypes.hasLifeGreaterThan50.mask()
                    }
                    else if livingAsset.state > 75{
                        state =  state | StateTypes.hasLifeGreaterThan75.mask()
                    }
                }
            }
        }
        return state
    }
    
    
    func proximityToHomeState(requestingAsset : Asset) -> UInt{
        if requestingAsset.isMine == false{
            if pos.row > requestingAsset.cell.pos.row{
                return StateTypes.isNearerToHome.mask()
            }
        }
        else{
            if pos.row < requestingAsset.cell.pos.row{
                return StateTypes.isNearerToHome.mask()
            }
        }
        
        return 0
    }
    
    func proximityToEnemyHomeState(requestingAsset : Asset) -> UInt{
        
        if requestingAsset.isMine == false{
            if pos.row < requestingAsset.cell.pos.row{
                return StateTypes.isNearerToEnemyHome.mask()
            }
        }
        else{
            if pos.row > requestingAsset.cell.pos.row{
                return StateTypes.isNearerToEnemyHome.mask()
            }
        }
       
        return 0
    }
    
    func relativeOrientation(requestingAsset : Asset) -> UInt{
        let direction = getRadAngle(requestingAsset.cell.position, pointB: self.position)
        var angleDirection = radiansToAngle(CGFloat(direction))
        
        let forwardDirection = (requestingAsset as! LivingAsset).forwardDirection
        angleDirection = angleDirection - radiansToAngle(forwardDirection)
        let rad = angleToRadians(angle: angleDirection)
        var angle = radiansToAngle(rad)
        angle = negativeAngleToPositive(angle: angle)
        
        var roundTo45 = roundTo(val: angle, factor: 45)
        roundTo45 = roundTo45.truncatingRemainder(dividingBy: 360)
        
        switch roundTo45 {
        case 0:
            return StateTypes.is0Degrees.mask()
        case 45:
            return StateTypes.is45Degrees.mask()
        case 90:
            return StateTypes.is90Degrees.mask()
        case 135:
            return StateTypes.is135Degrees.mask()
        case 180:
            return StateTypes.is180Degrees.mask()
        case 225:
            return StateTypes.is225Degrees.mask()
        case 270:
            return StateTypes.is270Degrees.mask()
        case 315:
            return StateTypes.is315Degrees.mask()
        default:
            return 0
        }
    }
    
    func staticOrientation(requestingAsset : Asset) -> UInt{
        let direction = getRadAngle(requestingAsset.cell.position, pointB: self.position)
        let angleDirection = radiansToAngle(CGFloat(direction))
        //angleDirection = angleDirection
        let rad = angleToRadians(angle: angleDirection)
        var angle = radiansToAngle(rad)
        angle = negativeAngleToPositive(angle: angle)
        
        var roundTo45 = roundTo(val: angle, factor: 45)
        roundTo45 = roundTo45.truncatingRemainder(dividingBy: 360)
        
        switch roundTo45 {
        case 0:
            return StateTypes.is0Degrees.mask()
        case 45:
            return StateTypes.is45Degrees.mask()
        case 90:
            return StateTypes.is90Degrees.mask()
        case 135:
            return StateTypes.is135Degrees.mask()
        case 180:
            return StateTypes.is180Degrees.mask()
        case 225:
            return StateTypes.is225Degrees.mask()
        case 270:
            return StateTypes.is270Degrees.mask()
        case 315:
            return StateTypes.is315Degrees.mask()
        default:
            return 0
        }
    }
    
    func relativeState(requestingAsset : Asset, radius : Int) -> UInt{
       return
            self.relativeOrientation(requestingAsset:requestingAsset) |
            self.objectState() |
            self.assetState(requestingAsset: requestingAsset) |
            self.proximityToHomeState(requestingAsset: requestingAsset)  |
            self.proximityToEnemyHomeState (requestingAsset: requestingAsset) |
            self.assetCreationState()
    }
    
    //    func staticState(requestingAsset : Asset, radius : Int) -> UInt{
    //        return
    //            self.staticOrientation(requestingAsset:requestingAsset)
    //
    ////        return
    ////            self.staticOrientation(requestingAsset:requestingAsset) |
    ////            self.assetState(requestingAsset: requestingAsset) |
    ////            self.proximityToHomeState(requestingAsset: requestingAsset)  |
    ////            self.proximityToEnemyHomeState (requestingAsset: requestingAsset)
    //    }
    
    
    func addState(newState : UInt)  {
        self.state = state | newState
    }
    
    func removeState(staleState : UInt)  {
        self.state = state ^ staleState
    }
    
    func setColor(){
        guard self.asset == nil else {
            if (self.asset as! Asset).isMine {
                self.color = UIColor.white
                self.colorBlendFactor = 0
                return
            }
            else{
                self.color = UIColor.red
                self.colorBlendFactor = 0.3
                return
            }
        }
        
        guard self.prevAsset == nil else {
            if (self.prevAsset as! Asset).isMine {
                self.color = UIColor.white
                self.colorBlendFactor = 0
                return
            }
            else{
                self.color = UIColor.red
                self.colorBlendFactor = 0.1
                return
            }
        }
        
        guard self.isCreatingAsset == false else {
            if (self.isGreenHomeCell) {
                self.color = UIColor.green
            }
            else{
                self.color = UIColor.red
            }
            self.colorBlendFactor = 0.5
            return
        }
        
        self.color = UIColor.white
        self.colorBlendFactor = 0
        
    }
    

}
