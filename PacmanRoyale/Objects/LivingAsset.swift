//
//  LivingAsset.swift
//  PacManRoyale
//
//  Created by Anthony on 20/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


class LivingAsset : Asset{    
    var brain : Brain{
        didSet{
            self.brain.describe(info: "New Brain")
        }
    }
    
    override var cell : Cell{
        didSet{
            if self.cell.id != oldValue.id{
                self.moveToCell()
                self.cell.asset = self
                oldValue.asset = nil
            }
        }
    }
    
    override init(id : UInt, assetType : AssetType, cell : Cell, isMine : Bool, strength : Int){
        self.brain = UserInfo.brain(isMine : isMine)!
        super.init(id: id, assetType: assetType, cell: cell, isMine: isMine, strength: strength)
        
        if isMine == false {
            self.zRotation = angleToRadians(angle: 180)
        }
        self.nextThinking(interval: self.thinkSpeed())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func think(){
        return
        
        self.removeAction(forKey: "thinking")
        guard self.nextCell == nil else{
            self.cell = nextCell!
            self.nextCell = nil
            self.nextThinking(interval: self.thinkSpeed())
            return
        }
        guard self.isMine else {
            return
        }
        if let decision = self.brain.getDecision(testStates: self.state(radius: 1, includingSelf: false)){
            performDecision(preferredState: decision)
        }
        
        self.nextThinking(interval: self.thinkSpeed())
    }
    
    
    
    func isPerformingAction() -> Bool{
        guard action(forKey: "moving") == nil else {
            return true
        }
        return false
    }
    
    private func thinkSpeed () -> Double{
        return Double(convertRange(1, fromMax: 100, toMin: 5, toMax: 0.5, convertVal: Float(self.strength)))
    }
    
    private func nextThinking(interval : Double){
        self.removeAction(forKey: "thinking")
        let thinkAction = SKAction.run({() in self.think()})
        let sequence = SKAction.sequence([SKAction.wait(forDuration: interval), thinkAction])
        self.run(sequence, withKey : "thinking")
    }
    
    func moveToCell(){
        let dist = getDistance(self.position, pointB: self.cell.position)
        let duration = Double(dist) / self.assetType.speed()!
        let moveAction = SKAction.move(to: self.cell.position, duration: duration)
        let removeWalking = SKAction.run({() in self.removeAction(forKey: "walking")})
        let sequence = SKAction.sequence([moveAction, removeWalking])
        self.run(sequence, withKey : "moving")
    }
    

 
    private func ActionComplete(){
        if self.delegate != nil{
            self.delegate!.CompletedAction(asset: self)
        }
    }
    
    func isWalking() -> Bool{
        if action(forKey: "walking") != nil{
            return true
        }
        
        return false
    }
    
    internal override func strengthChanged(object : GameObject){
        self.think()
    }
    
    func stop(){
        self.removeAllActions()
    }
}
