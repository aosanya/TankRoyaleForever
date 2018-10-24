//
//  LivingAsset_Thinking.swift
//  TankClashRoyale
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
        
        guard action(forKey: "override") == nil else {
            self.staticThink()
            return
        }
        
        isMakingDecision = true
        if isPerformingAction() == true{
            self.isMakingDecision = false
            return
        }
        
        
        guard self.brain.decisions.count > 0 else {
            if self.isMine == false{
                self.moveToEnemyHome()
            }
            self.isMakingDecision = false
            return
        }        
        
 
        
        self.previousDecisions = nil
        if let decision = self.brain.getDecision(testStates: self.relativeState){
            if decision.preferredState != 0 {
                performDecision(decision: decision)
            }
        }
        
        self.staticThink()
        
        self.isMakingDecision = false
    }
    
    func reverseDecision(){
        guard self.previousDecisions != nil else {
            return
        }
        
        guard self.prevCell != nil else {
            return
        }
        
        self.brain.addDecisions(states: previousDecisions!.states, preferredState: 0)
        self.stopAction()
        self.cell = self.prevCell!
        
        self.moveToCell()
    }
    func updateRelativeState(radius : Int, includingSelf : Bool){
        guard self.initialized == true else {
            return
        }
        self.relativeState = cells.relativeCellsState(asset : self, cell: self.cell, radius: radius, includingSelf: false)
    }
    
    func staticThink(){
        guard self.action(forKey: "thinking") != nil else{
            return
        }
        
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
    
    func moveToEnemyHome(){
        if let target = self.cellNextToEnemyHome(){
            self.cellProposed(cell: target)
        }
    }
    
    func cellNextToEnemyHome() -> Cell?{
        let proposedCell = self.proposedCellToMoveTo(preferredState : StateTypes.isNearerToEnemyHome.mask())
        
        guard proposedCell != nil else {
            return nil
        }
        
        return proposedCell
    }
    
    func performDecision(decision : Decision) {
        let proposedCell = self.proposedCellToMoveTo(preferredState : decision.preferredState)
        
        guard proposedCell != nil else {
            return
        }
        self.previousDecisions = Decision(index: decision.index, states: decision.states, preferredState: decision.preferredState)
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
