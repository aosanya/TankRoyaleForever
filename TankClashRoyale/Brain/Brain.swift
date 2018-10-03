//
//  Brain.swift
//  TankClashRoyale
//
//  Created by Anthony on 28/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import Foundation

class Brain : Codable{
    var isMine : Bool
    var assetType : UInt
    var level : Double
    var id : String
    var decisions : Set<Decision> = Set<Decision>()
    var decisionIndex : UInt = 0
    
    init(isMine : Bool, assetType : UInt, level : Double){
        self.id = generateID(clientId: clientId(), prefix: "Brain", suffix: "")
        self.assetType = assetType
        self.isMine = isMine
        self.level = level
    }
    
    func changeId(){
        self.id = generateID(clientId: clientId(), prefix: "Brain", suffix: "")
    }
    
    func addDecisions(states : States, preferredState : UInt){
        let existing = self.decisions.filter({m in m.states == states}).first
        if existing != nil{
            existing!.preferredState = preferredState
            return
        }
        self.decisionIndex += 1
        self.decisions.insert(Decision(index : decisionIndex, states: states, preferredState: preferredState))
    }
    
    
    func describe(info : String) {
        print(info)
        print("Decisions : \(self.decisions.count)")
    }
    
    private func newHash() -> Int{
        guard self.decisions.count > 0 else{
            return 1
        }
        
        let sortedDecisions = self.decisions.sorted(by: {$0.hashValue < $1.hashValue}).last
        return sortedDecisions!.hashValue + 1
    }
    
    func getDecision(testStates : States) -> Decision?{
        let exactMatch = getExactMatch(testStates: testStates)
        guard exactMatch == nil else{
            return exactMatch
        }
        
        let superSet = getSuperSet(testStates: testStates)
        guard superSet == nil else{
            return superSet
        }

        let intersect = getIntersection(testStates: testStates)
        guard intersect == nil else{
            return intersect
        }
        return nil
    }
    
    private func getExactMatch(testStates : States) -> Decision?{
        guard self.decisions.count > 0 else{
            return nil
        }
        
        let exactMatches = self.decisions.filter({m in m.states == testStates})
        if exactMatches.count > 0{
            return exactMatches.first!
        }
        
        return nil

    }
    
   private func getSuperSet(testStates : States) -> Decision?{
        let superSets = self.decisions.filter({m in m.states.set .isSuperset(of: testStates.set)})

        if superSets.count > 0{
           return Array(superSets).last!
        }

        return nil
    
    }

    private func getIntersection(testStates : States) -> Decision?{
        let intersection = self.decisions.filter({m in testStates.set.intersection(m.states.set).count > 0})
        
        if intersection.count > 0{
            return Array(intersection).last!
        }
        
        return nil
    }
        
}
