//
//  States.swift
//  PacmanRoyale
//
//  Created by Anthony on 26/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import UIKit

private let State_index = "State_index"
private let State_value = "State_value"

class State : Hashable, Codable{
    var index : Int
    var value : UInt
        
    init (index : Int, value : UInt){
        self.index = index
        self.value = value
    }
        
    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.value == rhs.value
    }

    var hashValue: Int{
        get{
             return (self.value).hashValue
        }
    }
}










