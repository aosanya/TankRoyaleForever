//
//  StateTypes.swift
//  TankClashRoyale
//
//  Created by Anthony on 18/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

enum StateTypes : UInt{
    case hasAidKit = 1
    case hasBomb = 2
    case hasCandy2 = 3
    case hasCandy3 = 4
    case hasCandy4 = 5
    case hasCandy5 = 6
    case hasCandy6 = 7
    case hasCandy7 = 8
    case hasMainHome = 9
    case hasSideHome = 10
    case hasTank = 11
    

    
    
    case hasMyAsset = 15
    case hasEnemyAsset = 16
    case hasStrongerAsset = 17
    case hasWeakerAsset = 18
    case hasEqualAsset = 19
    case isNearerToEnemyHome = 20
    case isNearerToHome = 21
    case is0Degrees = 22
    case is45Degrees = 23
    case is90Degrees = 24
    case is135Degrees = 25
    case is180Degrees = 26
    case is225Degrees = 27
    case is270Degrees = 28
    case is315Degrees = 29
    case isCreatingEnemy = 30
    case isCreatingMine = 31
    case assetIsMoving = 32
    case assetIsShooting = 33
    
    case hasLifeLessThan25 = 34
    case hasLifeGreaterThan25 = 35
    case hasLifeGreaterThan50 = 36
    case hasLifeGreaterThan75 = 37
    
    func mask() -> UInt{
        return 1 << self.rawValue
    }
}
