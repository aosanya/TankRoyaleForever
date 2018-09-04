//
//  Cell.swift
//  PacmanRoyale
//
//  Created by Anthony on 21/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


enum CellState : UInt{
    case empty = 1
    case selected = 2
    case nextmove = 3
    
    func image() -> UIImage{
        return #imageLiteral(resourceName: "WhiteCellDotted")
    }
    
//    func color() -> UIColor{
//        switch self{
//        case .empty:
//            return UIColor(hue: 255/255, saturation: 255/255, brightness: 255/255, alpha: 1)
//        case .selected:
//            return UIColor(hue: 130/255, saturation: 240/255, brightness: 144/255, alpha: 1)
//        case .nextmove:
//            return UIColor(hue: 130/255, saturation: 240/255, brightness: 100/255, alpha: 1)
//        }
//    }
}

protocol CellDelegate {
    func objectChanged(cell : Cell)
    func assetChanged(cell : Cell)
    func createAsset(cell : Cell, isMine : Bool)
    func assetCreationComplete(cell : Cell, isMine : Bool)
}


struct CellPos {
    var row : Int
    var col : Int
}

class Cell : SKSpriteNode{
    var id : Int
    var pos : CellPos
    var isCreatingAsset : Bool = false{
        didSet{
            if isCreatingAsset == false{
                self.isReadyToCreatAsset = false
            }
        }
    }
    
    var isReadyToCreatAsset : Bool = false
    
    var isRedHomeCell : Bool = false
    var isGreenHomeCell : Bool = false
    var label : SKLabelNode!
    var delegate : CellDelegate?
    var object : CellObject?{
        didSet{
            delegate!.objectChanged(cell: self)
        }
    }
    var stars : StatusIndicator?
    
    var asset : Asset?{
        didSet{
            delegate!.assetChanged(cell: self)
        }
    }
    
    var contactingAssets : Set<Asset> = Set<Asset>()
    
    var actionstate : CellState = CellState.empty{
        didSet{
            if self.actionstate != oldValue{
                //let action = SKAction.colorize(with: self.actionstate.color(), colorBlendFactor: 1, duration: 0.25)
                //self.run(action)
                //self.color = self.actionstate.color()
            }
        }
    }
    
    var currentTick : Int = 0
    private var countdownstart : Int = 0
    private var countdowmfrequency : Double = 0
    
    init(id : Int, size : CGSize, row : Int, col : Int){
        self.id = id
        self.pos = CellPos(row: row, col: col)
        super.init(texture: SKTexture(image: self.actionstate.image()), color: UIColor.clear, size: size)
        //self.color = CellState.empty.color()
        //self.colorBlendFactor = 1
        self.addLabel()
        //self.text(self.id)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.categoryBitMask = GameObjectType.cell.categoryBitMask()
        self.physicsBody?.contactTestBitMask =  GameObjectType.cell.contactTestBitMask()
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func addContactingAsset(asset : Asset){
        self.contactingAssets.insert(asset)
    }
    
    func removeContactingAsset(id : UInt){
       self.contactingAssets = self.contactingAssets.filter({m in m.id != id})
    }
    
    private func addLabel(){
        self.label = SKLabelNode(text: "")
        self.label.fontColor = UIColor.black
        self.addChild(self.label!)
        self.label.zPosition = self.zPosition  +  1
    }
    
    func text(_ value: String) {
        self.label!.text = value
    }
    
    func countdown(start : Int,  frequency : Double){
//        self.countdownstart = start
//        self.removeAction(forKey: "countdown")
//        self.currentTick = start
//        let tickAction = SKAction.run({() in self.tick()})
//        let sequenceAction = SKAction.sequence([SKAction.wait(forDuration: frequency), tickAction])
//        let repeatAction = SKAction.repeatForever(sequenceAction)
//        self.run(repeatAction, withKey : "countdown")
    }
    
    private func restartCountDown(){
        self.countdown(start: self.countdownstart, frequency: self.countdowmfrequency)
    }
    
    private func tick(){        
        self.text("\(self.currentTick)")
        if self.currentTick == 0 {
            self.removeAction(forKey: "countdown")
        }
        self.currentTick -= 1
    }
    
    func isEmpty() -> Bool{
        if self.asset != nil || self.object != nil{
            return false
        }
        return true
    }
    
    func addObject(type : GameObjectType) {
        self.object = CellObject(cell : self, objectType: type, size: CGSize(width: self.size.width * type.objectSize()!.width, height: self.size.height * type.objectSize()!.height))
        self.addChild(self.object!)
        self.object!.zPosition = self.zPosition + 2
        
    }
    
    func addStars() {
        self.stars = StatusIndicator()
        self.addChild(self.stars!)
        self.stars!.zPosition = self.object!.zPosition + 1
        self.stars!.position  = CGPoint(x: 0, y: self.object!.frame.maxY + self.stars!.size.height * 0.3)
    }
    
    private func objectState() -> UInt{
        var state : UInt = 0
        if self.object != nil{
//            if self.object!.type.isCandy(){
//                state = state | StateTypes.hasCandy.mask()
//                switch self.object!.type{
//                case .candy1:
//                    state = state | StateTypes.hasCandy1.mask()
//                case .candy2:
//                    state = state | StateTypes.hasCandy2.mask()
//                case .candy3:
//                    state = state | StateTypes.hasCandy3.mask()
//                case .candy4:
//                    state = state | StateTypes.hasCandy4.mask()
//                case .candy5:
//                    state = state | StateTypes.hasCandy5.mask()
//                case .tank1, .cell, .mainHome, .sideHome: ()
//
//                }
//            }
        }
        return 0
    }
    
    private func assetState(requestingAsset : Asset) -> UInt{
        var state : UInt = 0
        if self.asset != nil{
            switch self.asset!.type{
            case .tank1:
                state =  state | StateTypes.hasTank.mask()          
            case .cell : ()
            }
            
            //Team
            if self.asset!.isMine == requestingAsset.isMine{
                state =  state | StateTypes.hasMyAsset.mask()
            }
            else{
                state =  state | StateTypes.hasEnemyAsset.mask()
            }
            
            //Strength
            if requestingAsset.strength < self.asset!.strength{
                state =  state | StateTypes.hasStrongerAsset.mask()
            }
            else if requestingAsset.strength > self.asset!.strength{
                state =  state | StateTypes.hasWeakerAsset.mask()
            }
            else{// are equal
                state =  state | StateTypes.hasEqualAsset.mask()
            }
            
        }
        return state
    }
    
    func proximityToHomeState(requestingAsset : Asset) -> UInt{
        guard myHomePos !=  nil else{
            return 0
        }
        
        let actualHomePos : CellPos
        if requestingAsset.isMine == true{
            actualHomePos = myHomePos!
        }
        else{
            actualHomePos = enemyHomePos!
        }
        
        let assetDistance = getCellDistance(requestingAsset.cell.pos, posB: actualHomePos)
        let cellDistance = getCellDistance(self.pos, posB: actualHomePos)
        
        if assetDistance > cellDistance{
            return StateTypes.isNearerToHome.mask()
        }
        return 0
    }
    
    func proximityToEnemyHomeState(requestingAsset : Asset) -> UInt{
        guard myHomePos !=  nil else{
            return 0
        }
        
        let actualHomePos : CellPos
        if requestingAsset.isMine == false{
            actualHomePos = myHomePos!
        }
        else{
            actualHomePos = enemyHomePos!
        }
        
        let assetDistance = getCellDistance(requestingAsset.cell.pos, posB: actualHomePos)
        let cellDistance = getCellDistance(self.pos, posB: actualHomePos)
        
        if assetDistance > cellDistance{
            return StateTypes.isNearerToEnemyHome.mask()
        }
        return 0
    }
    
    func state(requestingAsset : Asset) -> UInt{
        return self.objectState() |
            self.assetState(requestingAsset: requestingAsset) |
            self.proximityToHomeState(requestingAsset: requestingAsset)  |
            self.proximityToEnemyHomeState (requestingAsset: requestingAsset)
    }
    
    func relativity(cell : Cell) -> (Int, Int){
        return (cell.pos.row - self.pos.row,  cell.pos.col - self.pos.col)
    }
    
    
    func neighboringAssetChanged(cell : Cell){
        if self.asset != nil{
            if self.asset! is LivingAsset{

            }
        }
    }
    
    func neighboringObjectChanged(cell : Cell){
        if self.asset != nil{
            if self.asset! is LivingAsset{

            }
        }
    }
    

}
