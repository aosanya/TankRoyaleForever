//
//  GameScene_CreateAssets.swift
//  TankClashRoyale
//
//  Created by Anthony on 03/11/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol GameScene_CreateAssets {
    
}

extension GameScene : GameScene_CreateAssets{
    func assetCreationComplete(cell: Cell, isMine: Bool) {
        self.triggerCreatingAssets(isMine: isMine)
    }
    
    func canCreateAsset(isMine: Bool) {
        self.triggerCreatingAssets(isMine: isMine)
    }
    
    func selectedTankReady(selector: TankSelector) {
        self.triggerCreatingAssets(isMine: selector.isMine)
    }
    
    func triggerCreatingAssets(isMine : Bool){
        guard self.gameOver == false else {
            return
        }
        
        guard cells.canCreateAsset(isMine:  isMine) == true else {
            return
        }
        
        var homeCells : [Cell] = [Cell]()
        if isMine == true{
            homeCells = cells.set.filter({m in m.isGreenHomeCell == true && m.canCreateAsset()})
        }
        else{
            homeCells = cells.set.filter({m in m.isRedHomeCell == true && m.canCreateAsset()})
        }
        
        var randomCell : Cell? = nil
        
        if homeCells.count > 0{
            let randCellPos = randint(0, upperLimit: homeCells.count - 1)
            randomCell = homeCells[randCellPos]
        }
        
        guard randomCell != nil else {
            return
        }
        
        if isMine == true{
            self.createAsset(cell: randomCell!, isMine: isMine, type: greenSelector.selectedType)
        }
        else if isMine == false{
            self.createAsset(cell: randomCell!, isMine: isMine, type: redSelector.selectedType)
        }
    }
    
    func createAsset(cell: Cell, isMine: Bool, type: AssetType) {
        guard  gameOver == false else {
            return
        }
        if isMine == false{
            self.redSelector.selectRandom()
        }
        self.assets.createAssets(cell: cell.id, isMine: isMine, type: type)
    }
}
