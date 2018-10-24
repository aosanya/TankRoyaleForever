//
//  TankSelector.swift
//  TankClashRoyale
//
//  Created by Anthony on 09/10/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

class TankSelector : SKNode{
    var tanks : [Button] = [Button]()
    var types : [AssetType]
    var selected : String = ""
    
    var selectedType : AssetType!

    init(assetTypes : [AssetType]) {
        self.types = assetTypes
        super.init()
        self.addTanks()
        self.selectDefault()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTanks(){
        var startPoint = (CGFloat(types.count) / -2) + 0.5
        for i in 0...types.count - 1{
            let tank = Button(image: types[i].images(), action: selectTank)
            tank.data = types[i] as AnyObject
            let bgSize = tank.calculateAccumulatedFrame().size.factor(2)
            tank.setBackground2(image: #imageLiteral(resourceName: "Tile_1"), size: bgSize)
            tank.position = CGPoint(x: tank.calculateAccumulatedFrame().size.width * startPoint * 1.5 , y: 0)
            self.tanks.append(tank)
            startPoint += 1
            self.addChild(tank)
        }
    }
    
    func deInitialize(){
        self.tanks.removeAll()
    }
    
    private func selectDefault(){
        guard self.tanks.count > 0 else {
            return
        }
        
        self.selectTank(thisButton: self.tanks[0])
    }
    
    func selectTank(thisButton : Button){
        guard thisButton.id != self.selected else {
            return
        }
        
        thisButton.setBackground2(image: #imageLiteral(resourceName: "Tile_Glowing"))
        thisButton.scale(to: 1.25, duration: 0.1)
        self.selected = thisButton.id
        self.selectedType = thisButton.data! as? AssetType
        self.deselectTanks()
    }
    
   private func deselectTanks(){
        for each in self.tanks{
            if self.selected != each.id{                
                each.setBackground2(image: #imageLiteral(resourceName: "Tile_1"))
                each.scale(to: 1, duration: 0.1)
            }
        }
    }
    
}
