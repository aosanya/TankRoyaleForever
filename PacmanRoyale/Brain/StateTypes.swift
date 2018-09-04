//
//  StateTypes.swift
//  PacManRoyale
//
//  Created by Anthony on 18/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

enum StateTypes : UInt{
    case hasCandy = 1
    case hasCandy1 = 2
    case hasCandy2 = 3
    case hasCandy3 = 4
    case hasCandy4 = 5
    case hasCandy5 = 6
    case hasCandy6 = 7
    case hasCandy7 = 8
    case hasMainHome = 9
    case hasSideHome = 10
    case hasTank = 11

    case hasMyAsset = 19
    case hasEnemyAsset = 20
    case hasStrongerAsset = 21
    case hasWeakerAsset = 22
    case hasEqualAsset = 23
    case isNearerToEnemyHome = 24
    case isNearerToHome = 25
    
    func mask() -> UInt{
        return 1 << self.rawValue
    }
}
