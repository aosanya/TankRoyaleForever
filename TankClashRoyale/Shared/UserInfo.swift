//
//  UserInfo.swift
//  TankClashRoyale
//
//  Created by Anthony on 27/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import Foundation


class UserInfo{
    static let scoreKey = "score"
    
    static func getLevel() -> Double{
        let level = self.getScore() + 1
        
        if level > 10{
            return 10
        }
        
        return level
    }
    
    static func getScore() -> Double{
        if let score = UserDefaults.standard.value(forKey: scoreKey){
            return score as! Double
        }
        else{
            UserDefaults.standard.set(0, forKey: scoreKey)
            return 0
        }
    }
    
    static func changeScore(change : Double) {
        var score = UserInfo.getScore()
        score += change
        if score < 0{
            score = 0
        }
        UserDefaults.standard.set( score, forKey: scoreKey)
    }
    
//    static func encode(object : Any) -> String{
//        let jsonEncoder = JSONEncoder()
//        var jsonData : Data? = nil
//        do {
//            jsonData =  try jsonEncoder.encode(object)
//        } catch {
//            print("Test")
//        }
//        
//        let json = String(data: jsonData!, encoding: String.Encoding.utf16)
//        
////        var decision = Decision(states: stateSet, action: Int(Action.MoveForward.rawValue))
////
////        let jsonEncoder = JSONEncoder()
////        var jsonData : Data? = nil
////
////        do {
////            jsonData =  try jsonEncoder.encode(decision)
////        } catch {
////            print("Test")
////        }
////
////        let json = String(data: jsonData!, encoding: String.Encoding.utf16)
////
////
////        let jsonDecoder = JSONDecoder()
////
////
////        do {
////            let jsonToDecode = json!.data(using: .utf8)
////            let bookObject = try? JSONDecoder().decode(Decision.self, from: jsonData!)
////            print("test")
////        } catch {
////            print("Test")
////        }
//        
//    }
//    
//    static func decode(){
//        var decision = Decision(states: stateSet, action: Int(Action.MoveForward.rawValue))
//        
//        let jsonEncoder = JSONEncoder()
//        var jsonData : Data? = nil
//        
//        do {
//            jsonData =  try jsonEncoder.encode(decision)
//        } catch {
//            print("Test")
//        }
//        
//        let json = String(data: jsonData!, encoding: String.Encoding.utf16)
//        
//        
//        let jsonDecoder = JSONDecoder()
//        
//        
//        do {
//            let jsonToDecode = json!.data(using: .utf8)
//            let bookObject = try? JSONDecoder().decode(Decision.self, from: jsonData!)
//            print("test")
//        } catch {
//            print("Test")
//        }
//        
//    }
    
 
    
   

}
