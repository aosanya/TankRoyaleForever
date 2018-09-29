//
//  GameObject.swift
//  PacmanRoyale
//
//  Created by Anthony on 26/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

enum GameObjectType : UInt{
    case tank1 = 1
    case shot = 2
    case aidKit = 3
    case cell = 9
    
    func categoryBitMask() -> UInt32{
        return 1 << self.rawValue
    }
    
    func contactTestBitMask() -> UInt32{
        switch self {
        case .tank1:
            return GameObjectType.tank1.categoryBitMask()
        case .shot:
            return GameObjectType.tank1.categoryBitMask()
        case .cell:
            return GameObjectType.tank1.categoryBitMask()
        case .aidKit:
            return GameObjectType.tank1.categoryBitMask()
        }
    }
    
    func hasLabel() -> Bool{
        switch self {
            case .tank1:
                return false
            case .cell:
                return false
            case .shot, .aidKit:
                return false
        }
    }
    
    func labelPosition() -> CGPoint?{
        switch self {
        case .tank1:
            return CGPoint(x: 0, y: -15)
        case .cell:
            return CGPoint(x: 0, y: -8)
        case .shot, .aidKit:
            return nil
        }
    }

    func image() -> UIImage{
        switch self {
        case .tank1:
            return #imageLiteral(resourceName: "Tank1")
        case .shot:
            return #imageLiteral(resourceName: "redBullet")
        case .cell:
            return #imageLiteral(resourceName: "WhiteCellDotted")
        case .aidKit:
            return #imageLiteral(resourceName: "AidKit")
        }
    }
    
    func size() -> CGSize?{
        switch self {
        case .tank1:
            return nil
        case .shot:
            //return CGSize(width: 30, height: 52)
            return CGSize(width: 20, height: 30)
        case .cell:
            return nil
        case .aidKit:
            return CGSize(width: 0.5, height: 0.5)
        }
    }
    
    func collection() -> Double{
        switch  self {
            case .aidKit:
                return 50
            case .cell, .shot, .tank1:
                return 0
        }
    }
    
    func statusBarSize() -> CGSize?{
        switch self {
        case .tank1:
            return CGSize(width: 50, height: 10)
        default:
            return nil
        }
    }
    
    func statusBarPosition() -> CGPoint?{
        switch self {
        case .tank1:
            return CGPoint(x: 0, y: -0.7)
        default:
            return CGPoint(x: 0, y: -0.7)
        }
    }
}

protocol GameObjectDelegate {
    func strengthChanged(object : GameObject)
}

class GameObject : SKSpriteNode{
    var id : UInt = 0
    var type : GameObjectType
    
    var _cell : Cell!
    private var _prevCell : Cell?
    
    var cell : Cell{
        get{
            return _cell
        }
        set{
            if _cell != nil{
                if self is Asset{
                    _cell!.prevAsset = self
                    _cell!.asset!.prevCell = _cell!
                    _cell!.removeAsset()
                }
                if self is CellObject{
                    _cell!.object = self
                    _cell!.object!.prevCell = _cell!
                    _cell!.object = nil
                }
            }
            if self is Asset{
                newValue.addAsset(asset: self)
            }
            if self is CellObject{
                newValue.object = self
            }
            _cell = newValue
            
            if _prevCell != nil{
                _prevCell!.addPointer()
            }
        }
    }
    
    var prevCell : Cell?{
        get{
            return _prevCell
        }
        set{
            if _prevCell != nil{
                if newValue == nil{
                    _prevCell!.prevAsset = nil
                }
            }
            
            if _prevCell != nil{
                _prevCell!.removePointer()
            }
            
            _prevCell = newValue
        }
    }        
    
//        didSet{
//            if self is Asset{
//                oldValue.asset = nil
//                cell.asset = self
//            }
//            if self is CellObject{
//                oldValue.object = nil
//                cell.object = self
//            }
//        }
//    }
    
    var label : SKLabelNode!
    var labelBackGround : SKSpriteNode!
    var gameObjectDelegate : GameObjectDelegate?
    var isRemoved : Bool = false
    
    var strength : Int{
        didSet{
            if oldValue != strength{
                if self.gameObjectDelegate != nil{
                    self.gameObjectDelegate!.strengthChanged(object: self)
                }
                self.updateText()
            }
        }
    }
    
    var collection : Double{
        get{
            return self.type.collection()
        }
    }
    
    init(cell : Cell, texture: SKTexture?, color: UIColor, size: CGSize, objectType : GameObjectType) {       
        self.type = objectType
        self.strength = 0
        super.init(texture: texture, color: color, size: size)
        self.cell = cell
        self.addLabel()
        self.updateText()
        self.zPosition = 150
    }
    
    //Living
    init(id : UInt,cell : Cell, assetType : AssetType, strength : Int) {
        self.id = id
        self.type = assetType.gameObjectType()
        self.strength = strength
        super.init(texture: SKTexture(image: self.type.image()), color: UIColor.clear, size: assetType.size())
        self.cell = cell
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.categoryBitMask = assetType.gameObjectType().categoryBitMask()
        self.physicsBody?.contactTestBitMask = assetType.gameObjectType().contactTestBitMask()
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.addLabel()
        self.updateText()
        self.zPosition = 200
        
    }
    
    
    
    init(cell : Cell, objectType : GameObjectType, size : CGSize) {
        self.type = objectType
        self.strength = 0
        super.init(texture: SKTexture(image: objectType.image()), color: UIColor.clear, size: size)
        self.cell = cell
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.categoryBitMask = objectType.categoryBitMask()
        self.physicsBody?.contactTestBitMask = objectType.contactTestBitMask()
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        if objectType.hasLabel() {
            self.addLabel()
            self.updateText()
        }
        self.zPosition = 150
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabel(){
        self.label = SKLabelNode(text: "0")
        self.label.fontName = "ChalkboardSE-Regular"
        self.label.fontColor = UIColor.white
        self.label.fontSize = 18
        self.label.position = self.type.labelPosition()!
        self.addChild(self.label!)
        self.label.zPosition = self.zPosition  +  2
        
        self.addBackGround()
    }
    
    func addBackGround(){
        self.labelBackGround = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "PointsBg")), color: UIColor.clear, size: CGSize(width: self.label.frame.size.width + 15, height: 25))
        self.labelBackGround.zPosition = self.zPosition  +  1
        self.labelBackGround.position = CGPoint(x: self.label.position.x, y: self.label.position.y + self.label.fontSize / 2)
        
        self.labelBackGround.color = UIColor.gray
        self.labelBackGround.colorBlendFactor = 1
        self.labelBackGround.alpha = 1
        self.addChild(self.labelBackGround)
    }
    

    
    private func updateText() {
        self.label!.text = "\(self.strength)"
        
        self.labelBackGround.size = CGSize(width: self.label.frame.size.width + 10, height: 25)
    }
    
    internal func strengthChanged(object : GameObject){
 
    }
}
