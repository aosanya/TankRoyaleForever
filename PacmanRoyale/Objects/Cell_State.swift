//
//  Cell_State.swift
//  PacManRoyale
//
//  Created by Anthony on 18/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol Cell_State {
    
}

extension Cell : Cell_State{
    
    private func objectState() -> UInt{
        var state : UInt = 0
        if self.object != nil{
            //            if self.object!.type.isCandy(){
            //                state = state | StateTypes.hasCandy.mask()
            //                switch self.object!.type{
            //                case .candy1:
            //                    state = state | StateTypes.hasCandy1.mask()
            //                case .candy2:
            //                    state = state | StateTypes.hasCandy2.mask()
            //                case .candy3:
            //                    state = state | StateTypes.hasCandy3.mask()
            //                case .candy4:
            //                    state = state | StateTypes.hasCandy4.mask()
            //                case .candy5:
            //                    state = state | StateTypes.hasCandy5.mask()
            //                case .tank1, .cell, .mainHome, .sideHome: ()
            //
            //                }
            //            }
        }
        return 0
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
                state =  state | StateTypes.hasTank.mask()
            case .shot : ()
            case .cell : ()
                
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
        }
        return state
    }
    
    
    func proximityToHomeState(requestingAsset : Asset) -> UInt{
        guard myHomePos !=  nil else{
            return 0
        }
        
        let actualHomePos : CellPos
        if requestingAsset.isMine == true{
            actualHomePos = myHomePos!
        }
        else{
            actualHomePos = enemyHomePos!
        }
        
        let assetDistance = getCellDistance(requestingAsset.cell.pos, posB: actualHomePos)
        let cellDistance = getCellDistance(self.pos, posB: actualHomePos)
        
        if assetDistance > cellDistance{
            return StateTypes.isNearerToHome.mask()
        }
        return 0
    }
    
    func proximityToEnemyHomeState(requestingAsset : Asset) -> UInt{
        guard myHomePos !=  nil else{
            return 0
        }
        
        let actualHomePos : CellPos
        if requestingAsset.isMine == false{
            actualHomePos = myHomePos!
        }
        else{
            actualHomePos = enemyHomePos!
        }
        
        let assetDistance = getCellDistance(requestingAsset.cell.pos, posB: actualHomePos)
        let cellDistance = getCellDistance(self.pos, posB: actualHomePos)
        
        if assetDistance > cellDistance{
            return StateTypes.isNearerToEnemyHome.mask()
        }
        return 0
    }
    
    func relativeOrientation(requestingAsset : Asset) -> UInt{
        
        print("- - - - - - - - -")
        print(requestingAsset.cell.position)
        print(self.position)
        print("- - - - - - - - -")
        
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
            self.relativeOrientation(requestingAsset:requestingAsset)
//                |
//                self.assetState(requestingAsset: requestingAsset) |
//                self.proximityToHomeState(requestingAsset: requestingAsset)  |
//                self.proximityToEnemyHomeState (requestingAsset: requestingAsset) |
//                self.assetCreationState()
    }
    
    //    func staticState(requestingAsset : Asset, radius : Int) -> UInt{
    //
    //        return
    //            self.staticOrientation(requestingAsset:requestingAsset)
    //
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
                self.color = UIColor.green
            }
            else{
                self.color = UIColor.red
            }
            self.colorBlendFactor = 0.3
            return
        }
        
        guard self.prevAsset == nil else {
            if (self.prevAsset as! Asset).isMine {
                self.color = UIColor.green
            }
            else{
                self.color = UIColor.red
            }
            self.colorBlendFactor = 0.1
            return
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