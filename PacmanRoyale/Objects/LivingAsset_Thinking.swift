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
        
        if self.isMine == false {
            print("stop")
        }
        
        if isPerformingAction() == true{
            self.isMakingDecision = false
            return
        }
        
        guard self.nextCell == nil else{
            if self.cell.id != nextCell!.id{
                self.cellProposed(cell: nextCell!)
            }
            self.nextCell = nil
            self.isMakingDecision = false
            return
        }
        
        //        guard self.isMine else {
        //            return
        //        }
        
        if let decision = self.brain.getDecision(testStates: self.relativeState(radius: 1, includingSelf: false)){
            performDecision(preferredState: decision)
        }
        
        self.autoThink()
        
        self.isMakingDecision = false
    }
    
    func autoThink(){
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
        }
    }
    
    func performDecision(preferredState : UInt) {
        let proposedCell = self.proposedCell(preferredState : preferredState)
        
        guard proposedCell != nil else {
            return
        }
        self.cellProposed(cell: proposedCell!)
    }
    
    func cellProposed(cell : Cell){
        if cell.isEmpty() {
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
