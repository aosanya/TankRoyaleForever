//
//  Cell_AssetCreation.swift
//  TankClashRoyale
//
//  Created by Anthony on 25/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol Cell_AssetCreation {
    
}

extension Cell : Cell_AssetCreation{
    func canCreateAsset() -> Bool{
        return (self.isGreenHomeCell || self.isRedHomeCell) && self.isEmpty()
    }
}
