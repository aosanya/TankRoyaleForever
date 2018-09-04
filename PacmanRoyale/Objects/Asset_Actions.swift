//
//  Asset_Actions.swift
//  PacmanRoyale
//
//  Created by Anthony on 29/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import Foundation


protocol Asset_Actions {
    
}

extension Asset : Asset_Actions{
    func move(preferredState : UInt){
        var proposedCells = cells.adjacentCell(cell: self.cell, state: preferredState)
        proposedCells = proposedCells.filter({m in m.isEmpty() == true})
        
        guard proposedCells.count > 0 else{
            return
        }
        
        if proposedCells.count == 1{
            self.cell = proposedCells.first!
            return
        }
        else{
            self.cell = proposedCells[randint(0, upperLimit: proposedCells.count - 1)]
            return
        }
    }
}
