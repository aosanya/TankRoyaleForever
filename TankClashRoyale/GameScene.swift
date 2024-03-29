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

class GameScene: SKScene , CellsDelegate, AssetsDelegate, SKPhysicsContactDelegate, GameOverDelegate, LivingAssetDelegate, TankSelectorDelegate {
   
    

    
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
        self.greenSelector!.startCreatingTanks()
        self.redSelector!.startCreatingTanks()
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
        
        let levelWidth = CGFloat(convertRange(1, fromMax: 10, toMin: Float(self.frame.width * 0.7), toMax: Float(self.frame.width * 0.9), convertVal: Float(level)))
      
        let maxCellWidth = CGFloat(convertRange(1, fromMax: 6, toMin: 150, toMax: 100, convertVal: Float(level)))
        let maxCellHeight = CGFloat(convertRange(1, fromMax: 5, toMin: 150, toMax: 100, convertVal: Float(level)))
        let maxCellSize = CGSize(width: maxCellWidth, height: maxCellHeight)
        
        cells = Cells(area: CGRect(x: 0, y: 0, width: levelWidth, height: self.frame.height * 0.5), rows: rows, cols: cols, maxCellSize : maxCellSize, delegate: self)
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
        
        self.cellsNode.speed = CGFloat(convertRange(1, fromMax: 10, toMin: 1, toMax: 2, convertVal: Float(level)))
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
        
        greenSelector = TankSelector(assetTypes : greenAssets, isMine : true)
        redSelector = TankSelector(assetTypes : redAssets, isMine : false)
        
        let cellsPos = self.cellsNode.calculateAccumulatedFrame()
        //let greenSize = greenSelector.calculateAccumulatedFrame()
        
        let level = UserInfo.getLevel()
        let greenGap = CGFloat(convertRange(1, fromMax: 10, toMin: Float(150), toMax: Float(120), convertVal: Float(level)))
        greenSelector.position = CGPoint(x: 0, y: cellsPos.minY - greenGap)
        greenSelector.delegate = self
        self.addChild(greenSelector)
        
        let redGap = CGFloat(convertRange(1, fromMax: 5, toMin: Float(120), toMax: Float(100), convertVal: Float(level)))
        redSelector.position = CGPoint(x: 0, y: cellsPos.maxY + redGap)
        redSelector.zRotation = angleToRadians(angle: 180)
        redSelector.canSelect = false
        redSelector.delegate = self
        self.addChild(redSelector)
    }
    

    
    func strengthChange(thisAsset: Asset) {
       //self.updateScores(isMine: thisAsset.isMine)
    }
    
    func updateScores(isMine : Bool){
        //var diff = 1
//        if assets.teamStrength(isMine: true) < assets.teamStrength(isMine: false){
//           diff = -1
//        }
        
        if isMine {
            greenScore.score = ((Double(cells.teamCells(isMine: true).count) / Double(cells.set.count)) * 100)
        }
        
        if !isMine{
            redScore.score = ((Double(cells.teamCells(isMine: false).count) / Double(cells.set.count)) * 100)
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
