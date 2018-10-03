//
//  GameScene_UserInterface.swift
//  TankClashRoyale
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
                    guard thisAsset.isMine  == true else{
                        return
                    }
                    
                    self.selectedAsset = thisAsset
                    self.selectedAsset!.isPaused = true
                   
                    return
                }
                if let thisCell = eachNode as? Cell{
                    guard thisCell.asset != nil else{
                        return
                    }
                    if let thisAsset = thisCell.asset! as? LivingAsset{
                        guard thisAsset.isMine  == true else{
                            return
                        }
                        
                        self.selectedAsset = thisAsset
                        self.selectedAsset!.isPaused = true
                        
                        return
                    }
                    
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard selectedAsset != nil else {
            return
        }
        for eachTouch in touches{
            let nodes = self.nodes(at: eachTouch.location(in: self.cellsNode))
            
            for eachNode in nodes{
                if let thisAsset = eachNode as? LivingAsset{
                    if thisAsset.id == self.selectedAsset!.id{
                        return
                    }
                }
            }
            
            
            for eachNode in nodes{
                if let thisCell = eachNode as? Cell{
                    
                    
                    let rel = self.selectedAsset!.cell.relativity(cell: thisCell)
                
                    var row = rel.0
                    var col = rel.1
                    
                    if row < -1{row = -1}
                    if row > 1{row = 1}
                    if col < -1{col = -1}
                    if col > 1{col = 1}
                    if let actualSelection = cells.relativeCell(cell: self.selectedAsset!.cell, row: row, col: col){
                        self.addSelectedCell(cell: actualSelection)
                    }
                    if self.selectedAsset!.cell.id != thisCell.id{
                        return
                    }
                    
                }
            }
           
            self.clearSelectedCells()
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard selectedAsset != nil else {
            return
        }
        
        if self.selectedCells.count == 1{
            let radius : Int = 1
            _ = self.selectedAsset!.cell.relativity(cell: self.selectedCells.first!)
            //self.selectedAsset!.nextCell = self.selectedCells.first!
            self.addMoveDecision(asset: self.selectedAsset!, preferredState: self.selectedCells[0].relativeState(requestingAsset: self.selectedAsset!, radius: radius))
            //Manual Decision
            if self.selectedAsset!.isPerformingAction() == false{
                self.selectedAsset!.startOverride()
                self.selectedAsset!.cellProposed(cell: self.selectedCells[0])
            }
            //
        }
        
        if self.selectedCells.count == 0{
            self.selectedAsset!.reverseDecision()
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
        self.selectedAsset!.cell.addSelectionPointer(from: cell, isMine: self.selectedAsset!.isMine)
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
        
        if selectedAsset != nil{
            self.selectedAsset!.cell.removeSelectionPointer()
        }
        
        for each in self.selectedCells{
            each.actionstate = CellState.empty
        }
        self.selectedCells.removeAll()
    }
    
    func addMoveDecision(asset : Asset, preferredState : UInt){
        let lAsset = asset as! LivingAsset
        lAsset.brain.addDecisions(states: lAsset.relativeState, preferredState: preferredState)
        UserInfo.brain(brain: (asset as! LivingAsset).brain)
        self.assets.propagateBrain(asset: asset)
    }
}
