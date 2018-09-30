//
//  LivingAsset.swift
//  TankClashRoyale
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
    var livingAssetDelegates = [LivingAssetDelegate]()
    var relativeState : States = States(set: Set<State>())
    var brain : Brain!{
        didSet{
            self.brain.describe(info: "New Brain")
        }
    }
    
    var initialized : Bool = false
    
    var state : Double{
        set {
            self.status.state = newValue
            for each in self.livingAssetDelegates{
                each.stateChanged(livingAsset: self)
            }
        }
        get { return self.status.state }
        
    }
    
    var moveSpeed : Double{
        get{
            let speedStatus = Double(convertRange(0, fromMax: 100, toMin: 0.5, toMax: 1, convertVal: Float(self.status.percentageStatus)))
            return self.assetType.speed() * speedStatus
        }
    }
    
    internal var isMakingDecision : Bool = false
    var nextCell : Cell? = nil    
    
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
             return (self.status.percentageStatus / 100)  * self.assetType.durability()
        }
    }
    
    override init(id : UInt, assetType : AssetType, cell : Cell, isMine : Bool, strength : Int){
        super.init(id: id, assetType: assetType, cell: cell, isMine: isMine, strength: strength)
        self.brain = getBrain()
        self.initialize()
        
    }

    init(id : UInt, assetType : AssetType, cell : Cell, isMine : Bool, strength : Int, brain : Brain?){
        super.init(id: id, assetType: assetType, cell: cell, isMine: isMine, strength: strength)
        self.brain = brain !== nil ? brain : getBrain()
        self.initialize()
        
    }

    func initialize(){
        if isMine == false {
            self.zRotation = angleToRadians(angle: 180)
        }
        self.addStatusBar()
        self.startThinking(interval: self.thinkSpeed())
        self.startConsumption()
        self.initialized = true
        self.updateRelativeState(radius: 1, includingSelf: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getBrain() -> Brain{
        guard isMine == true else{
            return getEnemyBrain()
        }
        
        if let b = UserInfo.brain(isMine : isMine, assetType: self.assetType.rawValue){
            return b
        }
        
        UserInfo.brain(brain: Brain(isMine: isMine, assetType: self.assetType.rawValue, level: UserInfo.getLevel()))
        
        return UserInfo.brain(isMine : isMine, assetType: self.assetType.rawValue)!
    }
    
    private func getEnemyBrain() -> Brain{
        
        var brains = UserInfo.brains().filter({m in m.isMine == false && m.assetType == self.assetType.rawValue})
        let level = UserInfo.getLevel()
        var betterCandidates = brains.filter({m in m.level >= level}).sorted(by: {$0.level < $1.level})
        
        
        guard betterCandidates.count == 0 else {
            return betterCandidates[0]
        }        
        
        if let myBrain = UserInfo.brain(isMine : true, assetType: self.assetType.rawValue){
            if myBrain.level >= level{
                myBrain.isMine = false
                UserInfo.brain(brain: myBrain)
                return getEnemyBrain()
            }
        }
        
        UserInfo.brain(brain: Brain(isMine: isMine, assetType: self.assetType.rawValue, level: 1))
        brains = UserInfo.brains().filter({m in m.isMine == false && m.assetType == self.assetType.rawValue})
        return brains.first!
    }
    
    func shouldShoot() -> Bool{
        let frontCell = self.frontCell()
        
        guard frontCell != nil else {
            return false
        }
        
        let assetState = frontCell!.assetState(requestingAsset: self)
        
        if assetState | StateTypes.assetIsMoving.mask() == assetState{
            return false
        }
        
        if assetState | StateTypes.hasEnemyAsset.mask() == assetState{
            return true
        }
        
        return false
    }
    
    func frontCell() -> Cell?{
        guard self._cell != nil else {
            return nil
        }
        let extrapolation = extrapolatePointUsingAngle(CGPoint.zero, direction: self.forwardDirection, byVal: 1)
        let targetRow = Int(round(extrapolation.y)) + self.cell.pos.row
        let targetCol = Int(round(extrapolation.x)) + self.cell.pos.col
        if let cell = cells.getCell(row: targetRow, col: targetCol){
            return cell
        }
        return nil
    }
    
    func loopShooting(){
        self.removeAction(forKey: "shooting")
        let interval = convertRange(1, fromMax: 10, toMin: 0.5, toMax: 0.2, convertVal: Float(self.moveSpeed))
        let shootAction = SKAction.run({() in self.shoot()})
        let sequence = SKAction.sequence([SKAction.wait(forDuration: TimeInterval(interval)), shootAction])
        self.run(sequence, withKey : "shooting")
    }
    
    func shoot(){
        for each in self.livingAssetDelegates{
            each.addShot(livingAsset: self)
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
    
    
    func ActionComplete(){
        if self.prevCell != nil{
            self.prevCell = nil
        }
        
        if self.delegate != nil{
            self.delegate!.CompletedAction(asset: self)
        }
        self.idleThink()
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
        for each in self.livingAssetDelegates{
            each.dead(livingAsset: self)
        }
    }
    
    func deInit(){
        guard self.physicsBody != nil else{
            return
        }
        
        self.removeAllActions()
        self.removeAllChildren()
        self.physicsBody = nil
        self.cell.removeAsset()
        self.cell.object = nil
        self.nextCell = nil
        self.prevCell = nil
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
    
    func collect(collection : Double){
        self.state += collection
    }
    
    func stopAllActions(){
        self.removeAllActions()
    }
}
