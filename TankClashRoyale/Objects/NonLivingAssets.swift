//
//  NonLivingAssets.swift
//  TankClashRoyale
//
//  Created by Anthony on 20/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

class NonLivingAsset : Asset{
    override init(id : UInt, assetType : AssetType, cell : Cell, isMine : Bool){
        super.init(id: id, assetType: assetType, cell: cell, isMine: isMine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func strengthChanged(object : GameObject) {
        
    }
}
