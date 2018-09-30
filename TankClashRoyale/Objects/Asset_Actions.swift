//
//  Asset_Actions.swift
//  TankClashRoyale
//
//  Created by Anthony on 29/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import Foundation


protocol Asset_Actions {
    
}

extension Asset : Asset_Actions{
    func proposedCellToMoveTo(preferredState : UInt) -> Cell?{
        var proposedCells = cells.adjacentCell(cell: self.cell, state: preferredState)
        proposedCells = proposedCells.filter({m in m.canMoveTo() == true})
        
        guard proposedCells.count > 0 else{
            return nil
        }
        
        if proposedCells.count == 1{
            return proposedCells.first!
        }
        else{
            return proposedCells[randint(0, upperLimit: proposedCells.count - 1)]
        }
    }
    
    func proposedCellToTurnTo(preferredState : UInt) -> Cell?{
        var proposedCells = cells.adjacentCell(cell: self.cell, state: preferredState)
        
        guard proposedCells.count > 0 else{
            return nil
        }
        
        if proposedCells.count == 1{
            return proposedCells.first!
        }
        else{
            return proposedCells[randint(0, upperLimit: proposedCells.count - 1)]
        }
    }
    
}
