//
//  Asset.swift
//  PacmanRoyale
//
//  Created by Anthony on 23/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

enum AssetType : Int{
    case tank1 = 1
    
    func images() -> UIImage{
        switch self {
        case .tank1:
            return #imageLiteral(resourceName: "Tank1")
        }
    }
    
    func size() -> CGSize{
        switch self {
        case .tank1:
            return CGSize(width: 60, height: 60)
        }
    }
    
    func speed() -> Double{
        switch self {
        case .tank1:
            return 1
        }
    }    
    
    func durability() -> Double{
        switch self {
        case .tank1:
            return 1
        }
    }
    
    func shotPayload() -> Double{
        switch self {
        case .tank1:
            return 1
        }
    }
    
    
    func gameObjectType() -> GameObjectType{
        switch self {
        case .tank1:
            return GameObjectType.tank1
        }
    }
}

protocol AssetDelegate {
    func CompletedAction(asset : Asset)
}

class Asset : GameObject{
    var assetType : AssetType
    var delegate : AssetDelegate?
    //used to override thinking using manual actions
    
    var isMine : Bool
    
   override var cell : Cell{
        didSet{
            self.cell.asset = self
            oldValue.asset = nil
        }
    }
    
    init(id : UInt, assetType : AssetType, cell : Cell, isMine : Bool, strength : Int){
        self.assetType = assetType
        self.isMine = isMine
        super.init(id : id,cell : cell, assetType : self.assetType, strength : strength)
        self.cell.asset = self
        self.position = self.cell.position
        self.zPosition = self.cell.zPosition + 10
        self.colorTeam()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func colorTeam() {
        if self.isMine == true{
            self.color = UIColor.green
            self.colorBlendFactor = 0.3
        }
        else{
            self.color = UIColor.red
            self.colorBlendFactor = 0.3
        }
        
        if self.isMine{
            self.labelBackGround.texture = SKTexture(image: #imageLiteral(resourceName: "whiteCircle"))
            self.labelBackGround.color = UIColor.green
            self.labelBackGround.colorBlendFactor = 0.5
            self.labelBackGround.alpha = 0
            
        }
        else{
            self.labelBackGround.texture = SKTexture(image: #imageLiteral(resourceName: "whiteSquare"))
            self.labelBackGround.color = UIColor.red
            self.labelBackGround.colorBlendFactor = 0.5
            self.labelBackGround.alpha = 0
        }
        
 //       self.addGlow()
    }
    
    func setLabelBackGround(){
       
    }
    
    
//    private func startShowingEmotion(){
//        self.removeAction(forKey: "showingEmotion")
//        let showEmotion = SKAction.run({() in self.changeEmotion()})
//        let sequence = SKAction.sequence([SKAction.wait(forDuration: 1), showEmotion])
//        self.run(SKAction.repeatForever(sequence), withKey : "showingEmotion")
//    }
//
    
    func merge(asset : Asset){
        if asset.isMine == self.isMine{
            self.strength += asset.strength
        }
        else{
            self.strength -= asset.strength
        }
    }
    
    func collect(object : GameObject){
        self.strength += object.type.points()
    }
    
    func performDecision(preferredState : UInt) {
        self.move(preferredState : preferredState)
    }
    
    func state(radius : Int, includingSelf : Bool) -> States{
        return cells.radialCellsState(asset : self, cell: self.cell, radius: radius, includingSelf: false)
    }
}
