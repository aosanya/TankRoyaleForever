//
//  CellObject.swift
//  TankClashRoyale
//
//  Created by Anthony on 15/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

class CellObject : GameObject{
    var removed : Bool = false
    
    override init(cell : Cell, objectType : GameObjectType, size : CGSize) {
        super.init(cell: cell, objectType: objectType, size: size)
        self.startCountDown()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deInit(){
        super.deInit()
    }
    
    private func startCountDown(){
        let countDown = SKAction.wait(forDuration: self.type.timeOnScene()!)
        let action = SKAction.run {() in self.remove()}
        let seq = SKAction.sequence([countDown, action])
        self.run(seq, withKey: "countdown")
    }
    
    func remove(){
        self.deInit()
        self.fadeOut(duration: 0.1, callBack: self.removeFromParent)
    }
}
