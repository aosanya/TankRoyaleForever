//
//  Cell_State.swift
//  PacManRoyale
//
//  Created by Anthony on 18/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol Cell_State {
    
}

extension Cell : Cell_State{
    func addState(newState : UInt)  {
        self.state = state | newState
    }
    
    func removeState(staleState : UInt)  {
        self.state = state ^ staleState
    }
}
