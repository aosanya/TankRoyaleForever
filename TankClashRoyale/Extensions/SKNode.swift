//
//  SKNode.swift
//  TankClashRoyale
//
//  Created by Anthony on 27/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

extension SKNode {
    func move(by : CGVector, duration : Double){
        let action = SKAction.move(by: by, duration: duration)
        self.run(action)
    }
    
    func move(to : CGPoint, duration : Double){
        var change = CGVector(dx: to.x - self.position.x, dy: to.y - self.position.y)
        var bounce = CGVector(dx: 0, dy: 0)
        
        if change.dx < 0{
            bounce = CGVector(dx: bounce.dx + 10, dy: bounce.dy)
        }
        else{
            bounce = CGVector(dx: bounce.dx - 10, dy: bounce.dy)
        }
        
        if change.dy < 0{
            bounce = CGVector(dx: bounce.dy, dy: bounce.dy + 10)
        }
        else{
           bounce = CGVector(dx: bounce.dy, dy: bounce.dy - 10)
        }
        
        change = CGVector(dx: change.dx - bounce.dx, dy: change.dy - bounce.dy)
        
        let action1 = SKAction.move(by: change, duration: duration)
        let action2 = SKAction.move(by: bounce, duration: duration * 0.2)
        
        self.run(SKAction.sequence([action1, action2]))
    }
    
    func popOut(duration : Double, callBack : (()  -> Void)?){
        let action1 = SKAction.scale(to: 1.25, duration: 0.4 * duration)
        let action2 = SKAction.scale(to: 1.15, duration: 0.6 * duration)
        if callBack != nil{
            let callBackAction = SKAction.run({() in callBack!()})
            self.run(SKAction.sequence([action1, action2, callBackAction]))
        }
        else{
            self.run(SKAction.sequence([action1, action2]))
        }
    }
    
    func fadeOut(duration : Double){
        self.fadeOut(duration: duration, callBack: nil)
    }
    
    func fadeOut(duration : Double, callBack : (()  -> Void)?){
        let action = SKAction.fadeOut(withDuration: duration)
        
        if callBack != nil{
            let callBackAction = SKAction.run({() in callBack!()})
            self.run(SKAction.sequence([action, callBackAction]))
        }
        else{
            self.run(action)
        }
    }
    
    func shake(){
        guard self.action(forKey: "shake") == nil else {
            return
        }
        var diff : CGFloat = 5
        var vectors : [CGVector] = [CGVector]()
                
        for _ in 0...10{
            vectors.append(CGVector(dx: diff, dy: 0))
            vectors.append(CGVector(dx: diff * -2, dy: 0))
            vectors.append(CGVector(dx: diff, dy: 0))
            diff = diff * 0.75
        }
        
        var actions : [SKAction] = [SKAction]()
        for each in vectors{
            actions.append(SKAction.move(by: each, duration: TimeInterval(abs(each.dx) * 0.01)))
        }
        
        self.run(SKAction.sequence(actions), withKey: "shake")
    }
}
