//
//  GameScene.swift
//  TankClashRoyale
//
//  Created by Anthony on 21/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit
import GameplayKit

var cells : Cells!

protocol GameSceneDelegate {
    func gameOver(Iwin : Bool)
    func gameStart()
    func gameRestart()
}

class GameScene: SKScene , CellsDelegate, AssetsDelegate, SKPhysicsContactDelegate, GameOverDelegate, LivingAssetDelegate {

    
    var assets : Assets!
    var selectedAsset : LivingAsset?
    var selectedCells : [Cell] = [Cell]()
    var greenScore : Score!
    var redScore : Score!
    var timer : Label!
    var timerLabel : Label!
    var timeLeft : Int = 176
    var lblLevel : SKLabelNode!
    var assertCreationIntervalIncrease : Double = 0
    var redHomeRow : Int!
    var greenHomeRow : Int!
   
    var redStarted : Bool = false
    var greenStarted : Bool = false
    var gameOverControl : GameOverControl?
    var topMenu : TopBar!
    var cellsNode : SKNode!
    var greenSelector : TankSelector!
    var redSelector : TankSelector!
    
    var gameOver : Bool = false{
        didSet{
            if gameOver == true && oldValue == false{
                self.loadGameOver()
            }
        }
    }
    
    var gameStarted : Bool = false{
        didSet{
            if gameStarted == true{
                
            }
        }
    }
    
    var delegates : [GameSceneDelegate] = [GameSceneDelegate]()
    
    override func didMove(to view: SKView) {
        //UserDefaults.standard.removeObject(forKey: "brains")
        //UserDefaults.standard.removeObject(forKey: "score")
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        self.addTopMenu()
        self.loadLevel()
        self.loadCells()
        self.loadTankSelectors()
        self.loadResources()
        self.loadAssets()
        
        //self.showGameOver()
        self.startGame()
        
    }
    
    func startGame(){
        self.triggerCreatingAssets(isMine: true)
        self.triggerCreatingAssets(isMine: false)
        self.startResourceGeneration(interval: 5)
    }

    func deInitialize(){
        cells.deInitialize()
        cells = nil
        
        self.delegates.removeAll()
        self.assets.deInitialize()
        self.assets = nil
        self.selectedAsset = nil
        self.cellsNode = nil
        self.greenSelector.deInitialize()
        self.greenSelector = nil
        self.redSelector.deInitialize()
        self.redSelector = nil
        self.topMenu = nil
        self.gameOverControl = nil
        self.redScore = nil
        self.greenScore = nil
        self.timer = nil
        self.timerLabel = nil
        self.children
            .forEach {
                $0.removeAllActions()
                $0.removeAllChildren()
                $0.removeFromParent()
        }
        
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
        
    }
    
    func getAction(fromCell : Cell, toCell : Cell){
        
    }
    
    func loadLevel(){
        self.lblLevel = SKLabelNode(text: "Level \(round(value: UserInfo.getLevel(), point: 100))")
        self.lblLevel.fontName = "ChalkboardSE-Regular"
        self.lblLevel.fontColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        self.lblLevel.position = CGPoint(x: 0, y: self.topMenu.calculateAccumulatedFrame().minY - 50)
        self.lblLevel.fontSize = 30
        self.lblLevel.zPosition = self.zPosition + 2
        self.addChild(self.lblLevel!)
    }
    
    func loadCells(){
        self.cellsNode = SKNode()
        self.addChild(self.cellsNode)
        let level = UserInfo.getLevel()
        let rows = Int(convertRange(1, fromMax: 5, toMin: 4, toMax: 8, convertVal: Float(level)))
        let cols = Int(convertRange(1, fromMax: 10, toMin: 3, toMax: 7, convertVal: Float(level)))
        
        cells = Cells(area: CGRect(x: 0, y: 0, width: self.frame.width * 0.5, height: self.frame.height * 0.5), rows: rows, cols: cols, delegate: self)
        self.delegates.append(cells)
        self.greenHomeRow = 0
        self.redHomeRow = rows - 1
        cells.setRedHomeCells(row: self.redHomeRow)
        cells.setGreenHomeCells(row: self.greenHomeRow)
//        //Debug Code
//        let redHome = cells.getCell(id: 12)
//        redHome?.isRedHomeCell = true
//
//        let greenHome = cells.getCell(id: 2)
//        greenHome?.isGreenHomeCell = true
//        //End of Debug
        

    }
    
    func loadAssets(){
        self.assets = Assets(cells: cells, delegate: self)
        self.delegates.append(self.assets)
        greenScore.score = assets.teamStrength(isMine: true)
        redScore.score = assets.teamStrength(isMine: false)
    }
    
    func loadTankSelectors(){
        let greenAssets =  [AssetType.tank1, AssetType.tank2 , AssetType.tank3]
        let redAssets =  [AssetType.tank1, AssetType.tank2, AssetType.tank3]
        
        greenSelector = TankSelector(assetTypes : greenAssets)
        
        redSelector = TankSelector(assetTypes : redAssets)
        
        let cellsPos = self.cellsNode.calculateAccumulatedFrame()
        let greenSize = greenSelector.calculateAccumulatedFrame()
        greenSelector.position = CGPoint(x: 0, y: cellsPos.minY - 100)
        self.addChild(greenSelector)
        
        redSelector.position = CGPoint(x: 0, y: cellsPos.maxY + 90)
        self.addChild(redSelector)
        
    }
    
    
    func strengthChange(thisAsset: Asset) {
       //self.updateScores(isMine: thisAsset.isMine)
    }
    
    func updateScores(isMine : Bool){
        var diff = 1
//        if assets.teamStrength(isMine: true) < assets.teamStrength(isMine: false){
//           diff = -1
//        }
        
        if isMine {
            greenScore.score = ((Double(cells.teamCells(isMine: true).count) / Double(cells.set.count)) * 100) + Double(diff)
        }
        
        if !isMine{
            redScore.score = ((Double(cells.teamCells(isMine: false).count) / Double(cells.set.count)) * 100) - Double(diff)
        }
        
        guard gameStarted == true else {
            return
        }
        
        if redScore.score > 60{
            self.gameOver = true
        }
        
        if greenScore.score > 60{
            self.gameOver = true
        }
        
        if redScore.score == 0 {
            self.gameOver = true
        }
        
        if greenScore.score == 0 {
            self.gameOver = true
        }
    }
    
    func loadResources(){
        let level = UserInfo.getLevel()
        
        
        cells.abundance.add(ResourceAbundance(type: .aidKit, abundance: 10, maxPerTime: Int(convertRange(1, fromMax: 10, toMin: 3, toMax: 5, convertVal: Float(level)))))
        
        
        cells.abundance.add(ResourceAbundance(type: .bomb, abundance: 10, maxPerTime: Int(convertRange(1, fromMax: 10, toMin: 3, toMax: 6, convertVal: Float(level)))))
//        cells.abundance.add(ResourceAbundance(type: .candy4, abundance: 10, maxPerTime: 2))
//        cells.abundance.add(ResourceAbundance(type: .candy5, abundance: 10, maxPerTime: 1))
//        var cell = cells.getCell(id: 2)
//        cell?.addObject(type: GameObjectType.candy5)
//        
//        cell = cells.getCell(id: 6)
//        cell?.addObject(type: GameObjectType.candy5)
        
    }
    
    
    func startResourceGeneration(interval : Double){
        self.removeAction(forKey: "createResources")
        let addRandomObjectAction = SKAction.run({() in cells.addRandomObject()})
        let sequence = SKAction.sequence([SKAction.wait(forDuration: interval), addRandomObjectAction])
        self.run(SKAction.repeatForever(sequence), withKey : "createResources")
    }
    
    func stopResourceGeneration(){
        self.removeAction(forKey: "createResources")
    }
    
    func triggerCreatingAssets(isMine : Bool){
        guard self.gameOver == false else {
            return
        }
        
        guard cells.canCreateAsset(isMine:  isMine) == true else {
            return
        }
        
        var actionName : String = ""
        var homeCells : [Cell] = [Cell]()
        if isMine == true{
            actionName = "createGreenAssets"
            homeCells = cells.set.filter({m in m.isGreenHomeCell == true && m.canCreateAsset()})
        }
        else{
            homeCells = cells.set.filter({m in m.isRedHomeCell == true && m.canCreateAsset()})
            actionName = "createRedAssets"
        }
        
        self.removeAction(forKey: actionName)
        
        var randomCell : Cell? = nil
        
        if homeCells.count > 0{
            let randCellPos = randint(0, upperLimit: homeCells.count - 1)
            randomCell = homeCells[randCellPos]
        }

        
        var assetCreationInterval : Double = 0
        if isMine == true{
            assetCreationInterval = self.greenSelector.selectedType!.creationTime()
        }
        else if isMine == false{
            assetCreationInterval = self.redSelector.selectedType!.creationTime()
        }
        
        guard randomCell != nil else {
            let loopAction = SKAction.run({() in self.triggerCreatingAssets(isMine: isMine)})
            let sequence = SKAction.sequence([SKAction.wait(forDuration: assetCreationInterval), loopAction])
            self.run(SKAction.repeatForever(sequence), withKey : actionName)
            return
        }
        
        
        if isMine == true{
           randomCell!.createAsset(isMine: isMine, type: greenSelector.selectedType)
        }
        else if isMine == false{
            randomCell!.createAsset(isMine: isMine, type: redSelector.selectedType)
        }
    }
    
    func assetCreationComplete(cell: Cell, isMine: Bool) {
        self.triggerCreatingAssets(isMine: isMine)
    }
    
    
    func canCreateAsset(isMine: Bool) {
        self.triggerCreatingAssets(isMine: isMine)
    }
    
    func createAsset(cell: Cell, isMine: Bool, type: AssetType) {
        guard  gameOver == false else {
            return
        }
        //       if let upgradeCandidate = cell.contactingAssets.filter({m in m.isMine == isMine}).first{
        //            if upgradeCandidate.isMine == isMine {
        //                upgradeCandidate.strength += newAssetStrength
        //            }
        //            else{
        //                upgradeCandidate.strength -= newAssetStrength
        //            }
        //            return
        //        }
        self.assets.createAssets(cell: cell.id, isMine: isMine, type: type)
    }
    
//    func loadSeats(){
//        func loadSet(cells : [Cell]){
//            for each in cells{
//                if each.row % 2 == 1{
//                
//                    each.addObject(object: CellObjectType.candy1)
//                }
//            }
//        }
//        
//        loadSet(cells: cells.getColCells(col: 0))
//        loadSet(cells: cells.getColCells(col: 1))
//        loadSet(cells: cells.getColCells(col: 3))
//        loadSet(cells: cells.getColCells(col: 4))
//
//        loadSet(cells: cells.getColCells(col: 6))
//        loadSet(cells: cells.getColCells(col: 7))
//    }
    
    func cellCreated(thisCell: Cell) {
        self.cellsNode.addChild(thisCell)
        thisCell.countdown(start: 10, frequency: 1)
    }
    
    func assetCreated(thisAsset: Asset) {
        if thisAsset is LivingAsset{
            let thisLivingAsset : LivingAsset = thisAsset as! LivingAsset
            thisLivingAsset.livingAssetDelegates.append(self)
        }
        
        self.cellsNode.addChild(thisAsset)
        self.updateScores(isMine: thisAsset.isMine)
        
        guard gameStarted == false else {
            return
        }
        if thisAsset.isMine {
            self.greenStarted = true
        }
        else{
            self.redStarted = true
        }
        if self.redStarted && self.greenStarted{
            self.gameStarted = true
        }
    }
    
//    func createSampleBrain(asset : Asset){
//        let stateSet = asset.state()
//        var decisions = Set<Decision>()
//        var index : Int = 0
//
//        for each in stateSet{
//            index += 1
//            decisions.insert(Decision(index : index, states: each, action: Action.Move.rawValue, direction : CGVector(dx: 0, dy: 1)))
//        }
//
//        let brain = Brain()
//        brain.addDecisions(newDecisions: decisions)
//        UserInfo.brain(brain: brain)
//    }
    
    func addShot(livingAsset : LivingAsset){
        let pos = extrapolatePointUsingAngle(livingAsset.position, direction: livingAsset.forwardDirection, byVal: livingAsset.assetType.gameSize().height * 0.3)
        let moveVector = extrapolatePointUsingAngle(CGPoint.zero, direction: livingAsset.forwardDirection, byVal: cells.cellHeight)
        let moveAction = SKAction.moveBy(x: moveVector.x, y: moveVector.y, duration: 0.5)
        
        let thisShot = Shot(pos: pos, direction: livingAsset.shootDirection, launcher: livingAsset.id, payload: livingAsset.assetType.shotPayload())
        self.cellsNode.addChild(thisShot)

        let removeAction = SKAction.run({() in thisShot.removeFromParent()})
        let sequence = SKAction.sequence([moveAction, removeAction])
        thisShot.run(sequence)
        thisShot.zPosition = livingAsset.zPosition + 1
    }
    
    func dead(livingAsset: LivingAsset) {
        let isMine = livingAsset.isMine
        self.assets.remove(asset: livingAsset)
        self.updateScores(isMine: isMine)
    }
    
    func noMoreAssets(isMine: Bool) {
        self.gameOver = true
    }
    
    func stateChanged(livingAsset: LivingAsset) {
        self.updateScores(isMine: livingAsset.isMine)
    }
    
    func cellChanged(thisAsset: Asset) {
        self.updateScores(isMine: thisAsset.isMine)
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
    func restartGame() {
        for each in self.delegates{
            each.gameRestart()
        }
    }
    
}
