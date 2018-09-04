//
//  GameScene.swift
//  PacmanRoyale
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
}

class GameScene: SKScene , CellsDelegate, AssetsDelegate, SKPhysicsContactDelegate, GameOverDelegate {

    
    var assets : Assets!
    var selectedAsset : LivingAsset?
    var selectedCells : [Cell] = [Cell]()
    var greenScore : Score!
    var redScore : Score!
    var newAssetStrength : Int = 1
    var lblLevel : SKLabelNode!
    var redAssetCreationInterval : Double = 5
    var greenAssetCreationInterval : Double = 5
    var assertCreationIntervalIncrease : Double = 0.5
    var redHomeRow : Int!
    var greenHomeRow : Int!
    
    var redStarted : Bool = false
    var greenStarted : Bool = false
    var gameOverControl : GameOverControl?
    var topMenu : TopBar!
    var cellsNode : SKNode!
    
    var gameOver : Bool = false{
        didSet{
            if gameOver == true{
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
        UserDefaults.standard.removeObject(forKey: "brains")
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        self.addTopMenu()
        self.loadLevel()
        self.loadCells()
        self.loadResources()
        self.loadAssets()
        //self.showGameOver()
        self.startResourceGeneration(interval: 2)
    }

    func getAction(fromCell : Cell, toCell : Cell){
        
    }
    
    func loadLevel(){
        self.lblLevel = SKLabelNode(text: "Level \(UserInfo.getLevel())")
        self.lblLevel.fontName = "ChalkboardSE-Regular"
        self.lblLevel.fontColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        self.lblLevel.position = CGPoint(x: 0, y: self.topMenu.calculateAccumulatedFrame().minY - 50)
        self.lblLevel.fontSize = 25
        self.lblLevel.zPosition = self.zPosition + 2
        self.addChild(self.lblLevel!)
    }
    
    func addTopMenu(){
        topMenu = TopBar(size : CGSize(width: self.frame.width, height: 100))
        topMenu.position = CGPoint(x: 0, y: self.frame.maxY - 50)
        self.addChild(topMenu)
        
        greenScore = Score(image: #imageLiteral(resourceName: "Tank1"), isMine: true)
        greenScore.position = CGPoint(x: -200 , y: 0)
        topMenu.addChild(greenScore)
        
        redScore = Score(image: #imageLiteral(resourceName: "Tank1"), isMine: false)
        redScore.position = CGPoint(x: 100 , y: 0)
        topMenu.addChild(redScore)
    }
    
    func loadCells(){
        self.cellsNode = SKNode()
        self.addChild(self.cellsNode)
        let level = UserInfo.getLevel()
        let rows = Int(convertRange(1, fromMax: 10, toMin: 4, toMax: 6, convertVal: Float(level)))
        let cols = Int(convertRange(1, fromMax: 10, toMin: 3, toMax: 7, convertVal: Float(level)))
        
        cells = Cells(area: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), rows: rows, cols: cols, delegate: self)
        self.delegates.append(cells)
        self.greenHomeRow = 0
        self.redHomeRow = rows - 1
        cells.setRedHomeCells(row: self.redHomeRow)
        cells.setGreenHomeCells(row: self.greenHomeRow)
        self.triggerCreatingAssets(isMine: true)
        self.triggerCreatingAssets(isMine: false)
    }
    

    
    func loadAssets(){
        self.assets = Assets(cells: cells, delegate: self)
        self.delegates.append(self.assets)
        greenScore.score = assets.teamStrength(isMine: true)
        redScore.score = assets.teamStrength(isMine: false)
    }
    
    func strengthChange(thisAsset: Asset) {
       self.updateScores(thisAsset: thisAsset)
    }
    
    func updateScores(thisAsset: Asset){
        if thisAsset.isMine && thisAsset is LivingAsset {
            greenScore.score = assets.teamStrength(isMine: true)
        }
        
        if !thisAsset.isMine && thisAsset is LivingAsset {
            redScore.score = assets.teamStrength(isMine: false)
        }
        
        guard gameStarted == true else {
            return
        }
        
        if redScore.score == 0 {
            self.gameOver = true
        }
        
        if greenScore.score == 0 {
            self.gameOver = true
        }
        
    }
    
    func loadResources(){
//        cells.abundance.add(ResourceAbundance(type: .candy1, abundance: 10, maxPerTime: 5))
//        cells.abundance.add(ResourceAbundance(type: .candy2, abundance: 10, maxPerTime: 4))
//        cells.abundance.add(ResourceAbundance(type: .candy3, abundance: 10, maxPerTime: 3))
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
    
    func triggerCreatingAssets(isMine : Bool){
        guard cells.canCreateAsset(isMine:  isMine) == true else {
            return
        }
        
        var actionName : String = ""
        var row : Int
        if isMine == true{
            row = greenHomeRow
            actionName = "createGreenAssets"
        }
        else{
            row = redHomeRow
            actionName = "createRedAssets"
        }
        
        self.removeAction(forKey: actionName)
        let randomCell = cells.randomEmptyCell(row: row)
        var assetCreationInterval : Double = 0
        if isMine == true{
            assetCreationInterval = greenAssetCreationInterval
        }
        else if isMine == false{
            assetCreationInterval = redAssetCreationInterval
        }
        
        guard randomCell != nil else {
            let loopAction = SKAction.run({() in self.triggerCreatingAssets(isMine: isMine)})
            let sequence = SKAction.sequence([SKAction.wait(forDuration: assetCreationInterval), loopAction])
            self.run(SKAction.repeatForever(sequence), withKey : actionName)
            return
        }
        
        randomCell!.createAsset(isMine: isMine, duration: assetCreationInterval)
        if isMine == true{
            greenAssetCreationInterval += assertCreationIntervalIncrease
        }
        else if isMine == false{
            redAssetCreationInterval += assertCreationIntervalIncrease
        }
    }
    
    func assetCreationComplete(cell: Cell, isMine: Bool) {
        
        self.triggerCreatingAssets(isMine: isMine)
    }
    
    
    func canCreateAsset(isMine: Bool) {
        self.triggerCreatingAssets(isMine: isMine)
    }
    
    func createAsset(cell: Cell, isMine: Bool) {
        if let upgradeCandidate = cell.contactingAssets.filter({m in m.isMine == isMine}).first{
            if upgradeCandidate.isMine == isMine {
                upgradeCandidate.strength += newAssetStrength
            }
            else{
                upgradeCandidate.strength -= newAssetStrength
            }
            return
        }
        self.assets.createAssets(cell: cell.id, isMine: isMine, strength: newAssetStrength)
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
        
        self.cellsNode.addChild(thisAsset)
        self.updateScores(thisAsset: thisAsset)
        
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
    
    
    
    override func update(_ currentTime: TimeInterval) {

    }
}
