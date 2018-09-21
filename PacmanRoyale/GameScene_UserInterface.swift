//
//  GameScene_UserInterface.swift
//  PacManRoyale
//
//  Created by Anthony on 23/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


protocol GameScene_UserInterface {
    
}

extension GameScene : GameScene_UserInterface{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for eachTouch in touches{
            for eachNode in self.nodes(at: eachTouch.location(in: self)){
                if let thisAsset = eachNode as? LivingAsset{
                    if thisAsset.isPerformingAction() == false{
                        self.selectedAsset = thisAsset
                        self.selectedAsset!.isPaused = true
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for eachTouch in touches{
            for eachNode in self.nodes(at: eachTouch.location(in: self)){
                if let thisCell = eachNode as? Cell{
                    if self.selectedAsset != nil{
                        let rel = self.selectedAsset!.cell.relativity(cell: thisCell)
                        if rel.0 == 0 && rel.1 == 0{
                            return
                        }
                        
                        var row = rel.0
                        var col = rel.1
                        
                        if row < -1{row = -1}
                        if row > 1{row = 1}
                        if col < -1{col = -1}
                        if col > 1{col = 1}
                        if let actualSelection = cells.relativeCell(cell: self.selectedAsset!.cell, row: row, col: col){
                            self.addSelectedCell(cell: actualSelection)
                        }                        
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.selectedAsset != nil && self.selectedCells.count == 1{
            let radius : Int = 1
            _ = self.selectedAsset!.cell.relativity(cell: self.selectedCells.first!)
            //self.selectedAsset!.nextCell = self.selectedCells.first!
            self.addMoveDecision(asset: self.selectedAsset!, preferredState: self.selectedCells[0].relativeState(requestingAsset: self.selectedAsset!, radius: 1))
            //Manual Decision
            self.selectedAsset!.cellProposed(cell: self.selectedCells[0])
            //
        }
        
        if self.selectedAsset != nil{
            self.selectedAsset!.isPaused = false
        }
        
        self.clearSelectedCells()
        self.selectedAsset = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func addSelectedCell(cell : Cell){
        if let _ = self.selectedCells.filter({m in m == cell}).first{
            return
        }
        self.clearSelectedCells()
        cell.actionstate = CellState.selected
        self.selectedCells.append(cell)
    }
    
    func removeCells(cell : Cell){
        guard self.selectedCells.count > 0 else {
            return
        }
        
        for each in self.selectedCells{
            if each != cell{
                each.actionstate = CellState.empty
                self.selectedCells = selectedCells.filter({m in m != each})
            }
        }
        
    }
    
    func clearSelectedCells(){
        guard self.selectedCells.count > 0 else {
            return
        }
        for each in self.selectedCells{
            each.actionstate = CellState.empty
        }
        self.selectedCells.removeAll()
    }
    
    func addMoveDecision(asset : Asset, preferredState : UInt){
        (asset as! LivingAsset).brain.addDecisions(states: asset.relativeState(radius: 1, includingSelf: false), preferredState: preferredState)
        UserInfo.brain(brain: (asset as! LivingAsset).brain)
        self.assets.propagateBrain(asset: asset)
    }
}
