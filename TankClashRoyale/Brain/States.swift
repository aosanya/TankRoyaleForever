//
//  States.swift
//  TankClashRoyale
//
//  Created by Anthony on 27/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import UIKit


class States : Equatable, Hashable, Codable{
    var hashValue: Int = 0
    var set : Set<State>

    
    init(set : Set<State>){
        self.set = set
        self.setHashValue()
    }
    
    private func setHashValue(){
        let sorted = self.set.sorted(by: {$0.value < $1.value})
        var newHashString = ""
        for each in sorted{
            newHashString = "\(newHashString),\(each.hashValue)"
        }
        self.hashValue = newHashString.hashValue
    }

    static func == (lhs: States, rhs: States) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
}
