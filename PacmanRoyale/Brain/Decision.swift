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
    
    var states : States
    var preferredState : UInt
    
    init(states : States, preferredState : UInt){
        self.hashValue = states.hashValue
        self.states = states
        self.preferredState = preferredState
    }
}
