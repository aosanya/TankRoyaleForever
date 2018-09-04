//
//  UserInfo_Brain.swift
//  PacmanRoyale
//
//  Created by Anthony on 28/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import Foundation
protocol UserInfo_Brain {
    
}


extension UserInfo : UserInfo_Brain  {
    static func resetBrains(){
        UserDefaults.standard.removeObject(forKey: "brains")
    }
    
    static func addBrain(brain : Brain){
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
        var brains = self.brains()
        brains = brains.filter({m in m.id != brain.id})
        self.addBrain(brain: brain)
    }
    
    static func brain(isMine : Bool) -> Brain?{
        if let brain = self.brains().filter({m in m.isMine == isMine}).first{
            return brain
        }
        
        return nil
    }
    
    
}

