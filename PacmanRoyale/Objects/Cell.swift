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


struct CellPos : Hashable{
    var row : Int
    var col : Int
    
    static func == (lhs: CellPos, rhs: CellPos) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    var hashValue: Int{
        get{
            return ("\(row)_\(col)").hashValue
        }
    }
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
    var state : UInt = 0
    var delegate : CellDelegate?
    var object : GameObject?{
        didSet{
            if object != oldValue{
                delegate!.objectChanged(cell: self)
            }
        }
    }
    var stars : StatusIndicator?
    
    var asset : GameObject?{
        didSet{
            if asset != oldValue{
                if delegate != nil{
                    delegate!.assetChanged(cell: self)
                }
                
            }
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
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.categoryBitMask = GameObjectType.cell.categoryBitMask()
        self.physicsBody?.contactTestBitMask =  GameObjectType.cell.contactTestBitMask()
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        //self.text("\(self.id)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func deInitialize(){
        self.delegate = nil
        self.label.removeAllChildren()
        self.asset = nil
        self.object = nil
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
        if self.isCreatingAsset == true{
            return false
        }
        if self.contactingAssets.count > 0{
            return false
        }
        return true
    }
    
    func addObject(type : GameObjectType) {
        self.object = CellObject(cell : self, objectType: type, size: CGSize(width: self.size.width * type.size()!.width, height: self.size.height * type.size()!.height))
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
   
    func assetCreationState() -> UInt{
        var state : UInt = 0
        if self.action(forKey: "creatingMyCells") != nil {
            state =  state | StateTypes.isCreatingMine.mask()
        }
        if self.action(forKey: "creatingEnemyCells") != nil {
            state =  state | StateTypes.isCreatingEnemy.mask()
        }
        return state
    }
    
    func assetState(requestingAsset : Asset) -> UInt{
        var state : UInt = 0
        if self.asset != nil{
            let actualAsset = self.asset! as! Asset
            switch self.asset!.type{
            case .tank1:
                state =  state | StateTypes.hasTank.mask()
            case .shot : ()
            case .cell : ()
                
            }
            
            //Team
            if actualAsset.isMine == requestingAsset.isMine{
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
    
    func relativeOrientation(requestingAsset : Asset) -> UInt{
        
        print("- - - - - - - - -")
        print(requestingAsset.cell.position)
        print(self.position)
        print("- - - - - - - - -")
        
        let direction = getRadAngle(requestingAsset.cell.position, pointB: self.position)
        var angleDirection = radiansToAngle(CGFloat(direction))
        
        let forwardDirection = (requestingAsset as! LivingAsset).forwardDirection
        angleDirection = angleDirection - radiansToAngle(forwardDirection)
        let rad = angleToRadians(angle: angleDirection)
        var angle = radiansToAngle(rad)
        angle = negativeAngleToPositive(angle: angle)
        
        var roundTo45 = roundTo(val: angle, factor: 45)
        roundTo45 = roundTo45.truncatingRemainder(dividingBy: 360)
        
        switch roundTo45 {
        case 0:
            return StateTypes.is0Degrees.mask()
        case 45:
            return StateTypes.is45Degrees.mask()
        case 90:
            return StateTypes.is90Degrees.mask()
        case 135:
            return StateTypes.is135Degrees.mask()
        case 180:
            return StateTypes.is180Degrees.mask()
        case 225:
            return StateTypes.is225Degrees.mask()
        case 270:
            return StateTypes.is270Degrees.mask()
        case 315:
            return StateTypes.is315Degrees.mask()
        default:
            return 0
        }
    }
    
    func staticOrientation(requestingAsset : Asset) -> UInt{
        let direction = getRadAngle(requestingAsset.cell.position, pointB: self.position)
        let angleDirection = radiansToAngle(CGFloat(direction))
        //angleDirection = angleDirection
        let rad = angleToRadians(angle: angleDirection)
        var angle = radiansToAngle(rad)
        angle = negativeAngleToPositive(angle: angle)
        
        var roundTo45 = roundTo(val: angle, factor: 45)
        roundTo45 = roundTo45.truncatingRemainder(dividingBy: 360)
        
        switch roundTo45 {
        case 0:
            return StateTypes.is0Degrees.mask()
        case 45:
            return StateTypes.is45Degrees.mask()
        case 90:
            return StateTypes.is90Degrees.mask()
        case 135:
            return StateTypes.is135Degrees.mask()
        case 180:
            return StateTypes.is180Degrees.mask()
        case 225:
            return StateTypes.is225Degrees.mask()
        case 270:
            return StateTypes.is270Degrees.mask()
        case 315:
            return StateTypes.is315Degrees.mask()
        default:
            return 0
        }
    }
    
    func relativeState(requestingAsset : Asset, radius : Int) -> UInt{
        return
            self.relativeOrientation(requestingAsset:requestingAsset) |
            self.assetState(requestingAsset: requestingAsset) |
            self.proximityToHomeState(requestingAsset: requestingAsset)  |
            self.proximityToEnemyHomeState (requestingAsset: requestingAsset) |
            self.assetCreationState()
    }
    
//    func staticState(requestingAsset : Asset, radius : Int) -> UInt{
//
//        return
//            self.staticOrientation(requestingAsset:requestingAsset)
//
//
////        return
////            self.staticOrientation(requestingAsset:requestingAsset) |
////            self.assetState(requestingAsset: requestingAsset) |
////            self.proximityToHomeState(requestingAsset: requestingAsset)  |
////            self.proximityToEnemyHomeState (requestingAsset: requestingAsset)
//    }
    
    func relativity(cell : Cell) -> (Int, Int){
        return (cell.pos.row - self.pos.row,  cell.pos.col - self.pos.col)
    }
    
    func neighboringAssetChanged(cell : Cell){
        if self.asset != nil{
            if self.asset! is LivingAsset{
                let livingAsset = self.asset as! LivingAsset
                livingAsset.think()
            }
        }
    }
    
    func neighboringObjectChanged(cell : Cell){
        if self.asset != nil{
            if self.asset! is LivingAsset{
                let livingAsset = self.asset as! LivingAsset
                livingAsset.think()
            }
        }
    }    

}
