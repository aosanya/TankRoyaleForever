//
//  Assets.swift
//  PacmanRoyale
//
//  Created by Anthony on 23/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


var enemyHomePos : CellPos? = nil
var myHomePos : CellPos? = nil

protocol AssetsDelegate{
    func assetCreated(thisAsset : Asset)
    func strengthChange(thisAsset : Asset)
}

class Assets : GameObjectDelegate, GameSceneDelegate{

    
    var living : [LivingAsset]! = [LivingAsset]()
    var nonliving : [NonLivingAsset]! = [NonLivingAsset]()
    var cells : Cells
    var delegates = [AssetsDelegate]()
    private var currentId : UInt = 0
    
    init(cells : Cells, delegate : AssetsDelegate?){
        self.cells = cells
        if delegate != nil{
            self.delegates.append(delegate!)
        }
        self.initializeBrains()
        //self.createMyHomes()
        //self.createEnemyHomes()
        //self.createMyAssets()
        //self.createEnemyAssets()
    }
    
    private func initializeBrains(){
        let brains = UserInfo.brains()
        if brains.count == 0{
            UserInfo.addBrain(brain: Brain(isMine : true))
            UserInfo.addBrain(brain: Brain(isMine : false))
        }
    }
    
    func createAssets(cell : Int, isMine : Bool, strength : Int ){
        if let cell = self.cells.getCell(id: cell){
            self.addLiving(type: AssetType.tank1, cell: cell, isMine: isMine, strength: strength)
        }
    }
    
    private func createEnemyAssets(){
        if let cell = self.cells.getCell(id: 1){
            self.addLiving(type: AssetType.tank1, cell: cell, isMine: false, strength: 75)
        }
        if let cell = self.cells.getCell(id: 5){
            self.addLiving(type: AssetType.tank1, cell: cell, isMine: false, strength: 100)
        }
        if let cell = self.cells.getCell(id: 4){
            self.addLiving(type: AssetType.tank1, cell: cell, isMine: false, strength: 75)
        }
        if let cell = self.cells.getCell(id: 14){
            self.addLiving(type: AssetType.tank1, cell: cell, isMine: false, strength: 25)
        }
    }
    
//    private func createEnemyHomes(){
//        if let cell = self.cells.getCell(id: 33){
//            self.addNonLiving(type: AssetType.mainHome, cell: cell, isMine: false, strength: 10)
//            enemyHomePos = cell.pos
//        }
//        if let cell = self.cells.getCell(id: 32){
//            self.addNonLiving(type: AssetType.sideHome, cell: cell, isMine: false, strength: 5)
//        }
//        if let cell = self.cells.getCell(id: 34){
//            self.addNonLiving(type: AssetType.sideHome, cell: cell, isMine: false, strength: 5)
//        }
//    }
    
    private func addLiving(type : AssetType, cell : Cell, isMine : Bool, strength :  Int){
        currentId += 1
        let asset = LivingAsset(id : currentId, assetType: type, cell: cell, isMine: isMine, strength: strength)
        asset.gameObjectDelegate = self
        self.living.append(asset)

        for each in self.delegates{
            each.assetCreated(thisAsset: asset)
        }
    }
    
    private func addNonLiving(type : AssetType, cell : Cell, isMine : Bool, strength :  Int){
        currentId += 1
        let asset = NonLivingAsset(id : currentId, assetType: type, cell: cell, isMine: isMine, strength: strength)
        asset.gameObjectDelegate = self
        self.nonliving.append(asset)
        
        for each in self.delegates{
            each.assetCreated(thisAsset: asset)
        }
    }
    
    func remove(asset : Asset){
        if asset is NonLivingAsset{
            self.nonliving = self.nonliving.filter({m in m.id != asset.id})
            asset.removeFromParent()
        }
        else if asset is LivingAsset{
            self.living = self.living.filter({m in m.id != asset.id})
            asset.removeFromParent()
        }
    }
    
    func propagateBrain(asset : Asset){
        let candidates = self.living.filter({m in m.brain.id != (asset as! LivingAsset).brain.id && m.isMine == asset.isMine})
        for each in candidates{
            each.brain = (asset as! LivingAsset).brain
        }
    }
    
    func teamStrength(isMine : Bool) -> Int{
        let assets = self.living.filter({m in m.isMine == isMine})
        return assets.map({m in m.strength}).reduce(0, +)
    }
    
    func strengthChanged(object : GameObject) {
        for each in self.delegates{
            each.strengthChange(thisAsset: object as! Asset)
        }
    }
    
    func gameOver(Iwin: Bool) {
        for each in living{
            each.stop()
            each.popOut(duration: 1)
        }
    }
    
    func gameStart() {
        
    }
}