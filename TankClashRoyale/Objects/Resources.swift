//
//  Resources.swift
//  TankClashRoyale
//
//  Created by Anthony on 15/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


class ResourceAbundance{
    var type : GameObjectType
    var abundance : Int
    var balance : Int
    var probabilityRange = [Int]()
    var maxPerTime : Int
    
    init(type : GameObjectType, abundance : Int, maxPerTime : Int) {
        self.type = type
        self.abundance = abundance
        self.balance = abundance
        self.maxPerTime = maxPerTime
    }
}

class Resources{
    var set : [ResourceAbundance]! = [ResourceAbundance]()
    private var probability : Int = 0
    var buffer : Int = 0
    
    func add(_ resources : ResourceAbundance){
        let currProbability = self.set.map({m in m.abundance}).reduce(0, +)
        resources.probabilityRange = [currProbability, currProbability + resources.abundance]
        self.set.append(resources)
        probability = self.set.map({m in m.abundance}).reduce(0, +)
    }
    
    func deInitialize(){
        self.set.removeAll()
        self.set = nil
    }
    
    func pop() -> ResourceAbundance?{
        let rand = randint(0, upperLimit: probability)
        let result = set.filter({m in m.probabilityRange[0] < rand && m.probabilityRange[1] > rand})
        if result.count == 1{
            self.reduce(type: result[0].type)
            return result[0]
        }
        return nil
    }
    
    private func reduce(type : GameObjectType){
        let resourcesBalance = self.set.filter({m in m.balance > 0 && m.type == type}).first
        if resourcesBalance != nil{
            resourcesBalance!.balance = resourcesBalance!.balance - 1
        }
    }
    
    func hasResources() -> Bool{
        let balance = self.set.filter({m in m.balance > 0})
        if balance.count > 0 {
            return true
        }
        
        return false
    }
    
    func getType(type : GameObjectType) -> ResourceAbundance?{
        return self.set.filter({m in m.type == type}).first
    }
}
