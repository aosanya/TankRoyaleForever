//
//  UserInfo_Brain.swift
//  TankClashRoyale
//
//  Created by Anthony on 28/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import Foundation
protocol UserInfo_Brain {
    
}

var cachedBrains : Data? = nil
extension UserInfo : UserInfo_Brain  {
    static func resetBrains(){
        UserDefaults.standard.removeObject(forKey: "brains")
    }
    
    private static func addBrain(brain : Brain){
        var brains = self.brains()
        brains.append(brain)
        
        self.brains(brains: brains)
    }
    
    static func brains(brains : [Brain]){
        let jsonEncoder = JSONEncoder()
        var jsonData : Data? = nil
        do {
            jsonData =  try jsonEncoder.encode(brains)
        } catch {
            
        }
        UserDefaults.standard.set(jsonData!, forKey: "brains")
    }
    
    static func brains() -> [Brain]{
        if let brainData = UserDefaults.standard.value(forKey: "brains") as? Data{
            do {
                let brains = try JSONDecoder().decode([Brain].self, from: brainData)
                return brains
            } catch {
                return [Brain]()
            }
        }
        else{
            return [Brain]()
        }
    }
    
    static func brain(brain : Brain){
        var prevBrains = self.brains()
        if brain.isMine == true{
            let toReplace = prevBrains.filter({m in m.isMine == brain.isMine && m.assetType == brain.assetType})
            for each in toReplace{
                prevBrains = prevBrains.filter({m in m.id != each.id})
            }
        }
        else{
            let level = round(value: brain.level, point: 100)
            let toReplace = prevBrains.filter({m in m.isMine == brain.isMine && m.assetType == brain.assetType && round(value: m.level, point: 100) == level})
            for each in toReplace{
                prevBrains = prevBrains.filter({m in m.id != each.id})
            }
        }

        self.brains(brains: prevBrains)
        self.addBrain(brain: brain)
    }
    
    static func brain(isMine : Bool, assetType : UInt) -> Brain?{
        if let brain = self.brains().filter({m in m.isMine == isMine && m.assetType == assetType}).first{
            return brain
        }
        
        return nil
    }
    
    static func brains(isMine : Bool) -> [Brain]{
        return self.brains().filter({m in m.isMine == isMine})
    }
    
    
}

