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
    var canSelect : Bool = true
    
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
            let tank = Button(image: types[i].images(), action: selectTank, size : types[i].selectorSize())
            tank.data = types[i] as AnyObject
            tank.setBackground2(image: #imageLiteral(resourceName: "Tile_1"), size: CGSize(width: 120, height: 120))
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
        
        self.switchTanks(thisButton: self.tanks[0])
    }
    

    func selectTank(thisButton : Button){
        guard self.canSelect == true else {
            return
        }
        self.switchTanks(thisButton: thisButton)
    }
    
   private func deselectTanks(){
        for each in self.tanks{
            if self.selected != each.id{                
                each.setBackground2(image: #imageLiteral(resourceName: "Tile_1"))
                each.scale(to: 1, duration: 0.1)
            }
        }
    }
    
    private func switchTanks(thisButton : Button){
        guard thisButton.id != self.selected else {
            return
        }
        
        thisButton.setBackground2(image: #imageLiteral(resourceName: "Tile_Glowing"))
        thisButton.scale(to: 1.25, duration: 0.1)
        self.selected = thisButton.id
        self.selectedType = thisButton.data! as? AssetType
        self.deselectTanks()
    }
    
    func selectRandom(){
        let rand = randint(0, upperLimit: self.tanks.count)
        self.switchTanks(thisButton: self.tanks[rand])
    }
}
