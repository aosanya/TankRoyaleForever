//
//  Decision.swift
//  PacmanRoyale
//
//  Created by Anthony on 27/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

enum Action : UInt{
    case Move
}

import UIKit


class Decision : Hashable , Codable{
    var hashValue: Int
    
    static func == (lhs: Decision, rhs: Decision) -> Bool {
        return lhs.states == rhs.states
    }
    
    var index : UInt
    var states : States
    var preferredState : UInt
    
    init(index : UInt, states : States, preferredState : UInt){
        self.hashValue = states.hashValue
        self.index = index
        self.states = states
        self.preferredState = preferredState
    }
}
