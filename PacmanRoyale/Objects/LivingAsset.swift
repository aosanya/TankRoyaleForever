//
//  LivingAsset.swift
//  PacManRoyale
//
//  Created by Anthony on 20/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol LivingAssetDelegate {
    func addShot(livingAsset : LivingAsset)
    func dead(livingAsset : LivingAsset)
    func stateChanged(livingAsset : LivingAsset)
}

class LivingAsset : Asset, StateDelegate{

    
    private var status : Status!
    var livingAssetDelegate : LivingAssetDelegate?
    
    var brain : Brain{
        didSet{
            self.brain.describe(info: "New Brain")
        }
    }
    
    var state : Double{
        set {
            self.status.state = newValue
            self.livingAssetDelegate?.stateChanged(livingAsset: self)
        }
        get { return self.status.state }
        
    }
    
    
    var moveSpeed : Double{
        get{
            return self.assetType.speed() * self.status.percentageStatus / 100
        }
    }
    private var isMakingDecision : Bool = false
    var nextCell : Cell? = nil
    override var cell : Cell{
        didSet{
            self.moveToCell()
        }
    }
    
    var forwardDirection : CGFloat{
        get{
            let angle = radiansToAngle(self.zRotation) + 270
            return angleToRadians(angle: angle)
        }
    }
    
    var shootDirection : CGFloat{
        get{
            let angle = radiansToAngle(self.zRotation)
            return angleToRadians(angle: angle)
        }
    }
    
    var remainingStrength : Double{
        get{
            print((self.status.percentageStatus / 100)  * self.assetType.durability())
            return (self.status.percentageStatus / 100)  * self.assetType.durability()
        }
    }
    
    override init(id : UInt, assetType : AssetType, cell : Cell, isMine : Bool, strength : Int){
        self.brain = UserInfo.brain(isMine : isMine)!
        super.init(id: id, assetType: assetType, cell: cell, isMine: isMine, strength: strength)
        
        if isMine == false {
            self.zRotation = angleToRadians(angle: 180)
        }
        self.addStatusBar()
        self.startThinking(interval: self.thinkSpeed())
        self.startConsumption()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func think(){
        guard isMakingDecision == false else {
            return
        }
        
        isMakingDecision = true
        guard self.brain.decisions.count > 0 else {
            self.isMakingDecision = false
            return
        }
        
        if isPerformingAction() == true{
            self.isMakingDecision = false
            return
        }
        
        guard self.nextCell == nil else{
            if self.cell.id != nextCell!.id{
                self.cell = nextCell!
            }
            self.nextCell = nil
            self.isMakingDecision = false
            return
        }
        
//        guard self.isMine else {
//            return
//        }
        
        if let decision = self.brain.getDecision(testStates: self.state(radius: 1, includingSelf: false)){
            stopShooting()
            performDecision(preferredState: decision)
        }
        
        if isPerformingAction() == false{
            if self.isShooting() == false {
                let shoot = self.shouldShoot()
                if shoot == true{
                    self.loopShooting()
                }
            }
        }
        self.isMakingDecision = false
    }
    
    func shouldShoot() -> Bool{
        let state = self.state(radius: 1, includingSelf: false)
        
        let frontCell = state.set.filter({m in m.value | StateTypes.is270Degrees.mask() == m.value})
        
        guard frontCell.count > 0 else {
            return false
        }
        
        
        if frontCell.first!.value | StateTypes.hasEnemyAsset.mask() == frontCell.first!.value{
            return true
        }
        
        return false
    }
    
    func loopShooting(){
        self.removeAction(forKey: "shooting")
        let interval = convertRange(1, fromMax: 10, toMin: 0.5, toMax: 0.2, convertVal: Float(self.moveSpeed))
        let shootAction = SKAction.run({() in self.shoot()})
        let sequence = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(interval)), shootAction])
        self.run(sequence, withKey : "shooting")
    }
    
    func shoot(){
        if self.livingAssetDelegate != nil{
            self.livingAssetDelegate?.addShot(livingAsset: self)
        }
        self.loopShooting()
    }
    
    func stopShooting(){
        self.removeAction(forKey: "shooting")
    }
    
    func isShooting() -> Bool{
        guard action(forKey: "shooting") == nil else {
            return true
        }
        return false
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
    
    private func startThinking(interval : Double){
        self.removeAction(forKey: "thinking")
        let thinkAction = SKAction.run({() in self.think()})
        let sequence = SKAction.sequence([SKAction.wait(forDuration: interval), thinkAction])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever, withKey : "thinking")
    }
    
    private func startConsumption(){
        let consume = SKAction.run({() in self.consume()})
        let sequence = SKAction.sequence([SKAction.wait(forDuration: 0.5), consume])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever, withKey : "consume")
    }
    
    private func consume(){
        var consumption : Double = 0
        
        if self.action(forKey: "moving") != nil{
            consumption += 0.5
        }
        
        if self.action(forKey: "shooting") != nil{
            consumption += 1
        }
        
        guard consumption > 0 else {
            return
        }
        
        self.reduceLife(reduction: consumption)
    }
    
    
    private func nextThinking(interval : Double){
        self.removeAction(forKey: "thinking")
        let thinkAction = SKAction.run({() in self.think()})
        let sequence = SKAction.sequence([SKAction.wait(forDuration: interval), thinkAction])
        self.run(sequence, withKey : "thinking")
    }
    
    func moveToCell(){
        guard isPerformingAction() == false else {
            return
        }
        
        let facing = radiansToAngle(self.zRotation) + 270
        let toFace = negativeAngleToPositive(angle: radiansToAngle(CGFloat(getRadAngle(self.position, pointB: self.cell.position))))
        
        let rotation =  facing - toFace
        let dist = getDistance(self.position, pointB: self.cell.position)
        let moveDuration = Double(dist) / Double(self.moveSpeed * 50)
        let turnDuration = Double(rotation) / Double(self.moveSpeed)
        let turnAction = SKAction.rotate(byAngle: angleToRadians(angle: rotation), duration: turnDuration)
        let moveAction = SKAction.move(to: self.cell.position, duration: moveDuration)
        let removeWalking = SKAction.run({() in self.removeAction(forKey: "walking")})
        let sequence = SKAction.sequence([turnAction, moveAction, removeWalking])
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
    
    func addStatusBar(){
        self.status = Status(minState: 0, maxState: 100, size: self.type.statusBarSize()!, pos: CGPoint(x: 0, y: self.size.height * self.type.statusBarPosition()!.y))
        if self.isMine == false{
            self.status.statusBar.alpha = 0.3
        }
        self.status.stateDelegate = self
        self.addChild(self.status.statusBar)
    }
    
    func stateChange(thisStatu: Status) {
        
    }
    
    func stateLow(thisStatus: Status) {
        
    }
    
    func recovered(thisStatus: Status) {
        
    }
    
    func zeroState(thisStatus: Status) {
        self.livingAssetDelegate?.dead(livingAsset: self)
    }
    
    func deInit(){
        guard self.physicsBody != nil else{
            return
        }
        
        self.removeAllActions()
        self.removeAllChildren()
        self.physicsBody = nil
        self.cell.asset = nil
        self.fadeOut(duration: 0.1, callBack: self.remove)
        
    }
    
    func remove(){
        self.removeFromParent()
    }
    
    func gotShot(shotPower : Double){
        self.reduceLife(reduction: shotPower * 5)
    }
    
    private func reduceLife(reduction : Double){
         self.state -= reduction / self.assetType.durability()
    }
}
