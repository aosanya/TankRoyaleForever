//
//  CellObject.swift
//  PacManRoyale
//
//  Created by Anthony on 15/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

class CellObject : GameObject{
    var removed : Bool = false
    
    override init(cell : Cell, objectType : GameObjectType, size : CGSize) {
        super.init(cell: cell, objectType: objectType, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
