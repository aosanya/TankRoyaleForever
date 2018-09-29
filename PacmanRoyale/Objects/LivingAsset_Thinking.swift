//
//  LivingAsset_Thinking.swift
//  PacManRoyale
//
//  Created by Anthony on 10/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol LivingAsset_Thinking {
    
}

extension LivingAsset : LivingAsset_Thinking{
    func think(){
        guard self.brain != nil else {
            return
        }
        
        guard isMakingDecision == false else {
            return
        }
        
        isMakingDecision = true
        guard self.brain.decisions.count > 0 else {
            self.isMakingDecision = false
            return
        }
        
        
        if isPerformingAction() == true{
            self.isMakingDecision = false
            return
        }
        
        if let decision = self.brain.getDecision(testStates: self.relativeState){
            performDecision(preferredState: decision)
        }
        
        self.autoThink()
        
        self.isMakingDecision = false
    }
    
    func updateRelativeState(radius : Int, includingSelf : Bool){
        guard self.initialized == true else {
            return
        }
        self.relativeState = cells.relativeCellsState(asset : self, cell: self.cell, radius: radius, includingSelf: false)
    }
    
    func autoThink(){
        guard self.initialized == true else {
            return
        }
        
        guard isPerformingAction() == false else{
            stopShooting()
            return
        }
        
        self.idleThink()
    }
    
    func idleThink(){
        if self.shouldShoot(){
            if isShooting() == false{
                self.loopShooting()
            }
        }
        else{
            self.stopShooting()
            self.faceEnemyCell()
        }
    }
    
    func getEnemyCell() -> Cell?{
        let proposedCell = self.proposedCellToTurnTo(preferredState : StateTypes.hasEnemyAsset.mask())
        
        guard proposedCell != nil else {
            return nil
        }
        
        return proposedCell
    }
    
    func faceEnemyCell(){
        if let target = self.getEnemyCell(){
            self.cellProposed(cell: target)
        }
    }
    
    func performDecision(preferredState : UInt) {
        let proposedCell = self.proposedCellToMoveTo(preferredState : preferredState)
        
        guard proposedCell != nil else {
            return
        }
        self.cellProposed(cell: proposedCell!)
    }
    
    private func performAutoDecision(preferredState : UInt) {
        let proposedCell = self.proposedCellToMoveTo(preferredState : preferredState)
        
        guard proposedCell != nil else {
            return
        }
        self.cellProposed(cell: proposedCell!)
    }
    
    func cellProposed(cell : Cell){
        if cell.canMoveTo() {
            self.cell = cell
            self.moveToCell()
            return
        }
        
        if let frontCell = self.frontCell(){
            if frontCell.id != cell.id{
                self.turn(to: cell)
                return
            }
        }
        else{
            self.turn(to: cell)
            return
        }
    }
}
