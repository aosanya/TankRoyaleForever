//
//  Asset.swift
//  TankClashRoyale
//
//  Created by Anthony on 23/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

enum AssetType : UInt{
    case tank1 = 1
    case tank2 = 2
    case tank3 = 3
    
    func images() -> UIImage{
        switch self {
        case .tank1:
            return #imageLiteral(resourceName: "Tank1")
        case .tank2:
            return #imageLiteral(resourceName: "Tank2")
        case .tank3:
            return #imageLiteral(resourceName: "Tank3")
        }
    }
    
    private func size() -> CGSize{
        switch self {
        case .tank1:
            return CGSize(width: 35, height: 70)
        case .tank2:
            return CGSize(width: 35, height: 70)
        case .tank3:
            return CGSize(width: 163, height: 310)
        }
    }
    
    func gameSize() -> CGSize{
        switch self {
        case .tank1:
            return self.size().fitTo(size: CGSize(width: 75, height: 75))
        case .tank2:
            return self.size().fitTo(size: CGSize(width: 80, height: 80))
        case .tank3:
            return self.size().fitTo(size: CGSize(width: 80, height: 80))
        }
    }
    
    func selectorSize() -> CGSize{
        switch self {
        case .tank1:
            return self.size().fitTo(size: CGSize(width: 75, height: 75))
        case .tank2:
            return self.size().fitTo(size: CGSize(width: 80, height: 80))
        case .tank3:
            return self.size().fitTo(size: CGSize(width: 80, height: 80))
        }
    }
    
    func speed() -> Double{
        switch self {
        case .tank1:
            return 1
        case .tank2:
            return 1.2
        case .tank3:
            return 1.3
        }
    }    
    
    func creationTime() -> Double{
        switch self {
        case .tank1:
            return 5
        case .tank2:
            return 10
        case .tank3:
            return 15
        }
    }
    
    func durability() -> Double{
        switch self {
        case .tank1:
            return 1
        case .tank2:
            return 1.5
        case .tank3:
            return 2
        }
    }
    
    func shotPayload() -> Double{
        switch self {
        case .tank1:
            return 1
        case .tank2:
            return 2
        case .tank3:
            return 3
        }
    }
    
    
    func gameObjectType() -> GameObjectType{
        switch self {
        case .tank1:
            return GameObjectType.tank1
        case .tank2:
            return GameObjectType.tank2
        case .tank3:
            return GameObjectType.tank3
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
    
    init(id : UInt, assetType : AssetType, cell : Cell, isMine : Bool){
        self.assetType = assetType
        self.isMine = isMine
        super.init(id : id,cell : cell, assetType : self.assetType)
        
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
    
    
    

    
//    func staticState(radius : Int, includingSelf : Bool) -> States{
//        return cells.staticCellsState(asset : self, cell: self.cell, radius: radius, includingSelf: false)
//    }
    
}
