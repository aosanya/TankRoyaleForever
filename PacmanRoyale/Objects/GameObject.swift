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
    case cell = 9
    
    func categoryBitMask() -> UInt32{
        return 1 << self.rawValue
    }
    
    func contactTestBitMask() -> UInt32{
        switch self {
        case .tank1:
            return GameObjectType.tank1.categoryBitMask()
        case .cell:
            return GameObjectType.tank1.categoryBitMask()
        }
    }
    
    func labelPosition() -> CGPoint{
        switch self {
        case .tank1:
            return CGPoint(x: 0, y: -15)
        case .cell:
            return CGPoint(x: 0, y: -8)
        }
    }
   

    func image() -> UIImage{
        switch self {
        case .tank1:
            return #imageLiteral(resourceName: "Tank1")
        case .cell:
            return #imageLiteral(resourceName: "WhiteCellDotted")
        }
    }
    
    func objectSize() -> CGSize?{
        switch self {
        case .tank1:
            return nil
        case .cell:
            return nil
        }
    }
    
    func points() -> Int{
        switch  self {
       default:
            return 0
        }
    }
}

protocol GameObjectDelegate {
    func strengthChanged(object : GameObject)
}

class GameObject : SKSpriteNode{
    var id : UInt = 0
    var type : GameObjectType
    var cell : Cell
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
    
    init(cell : Cell, texture: SKTexture?, color: UIColor, size: CGSize, objectType : GameObjectType) {
        self.cell = cell
        self.type = objectType
        self.strength = objectType.points()
        super.init(texture: texture, color: color, size: size)
        self.addLabel()
        self.updateText()
    }
    
    //Living
    init(id : UInt,cell : Cell, assetType : AssetType, strength : Int) {
        self.id = id
        self.type = assetType.gameObjectType()
        self.cell = cell
        self.strength = strength
        super.init(texture: SKTexture(image: self.type.image()), color: UIColor.clear, size: assetType.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.categoryBitMask = assetType.gameObjectType().categoryBitMask()
        self.physicsBody?.contactTestBitMask = assetType.gameObjectType().contactTestBitMask()
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.addLabel()
        self.updateText()
    }
    
     
    
    init(cell : Cell, objectType : GameObjectType, size : CGSize) {
        self.type = objectType
        self.cell = cell
        self.strength = objectType.points()
        super.init(texture: SKTexture(image: objectType.image()), color: UIColor.clear, size: size)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.categoryBitMask = objectType.categoryBitMask()
        self.physicsBody?.contactTestBitMask = objectType.contactTestBitMask()
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.addLabel()
        self.updateText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabel(){
        self.label = SKLabelNode(text: "0")
        self.label.fontName = "ChalkboardSE-Regular"
        self.label.fontColor = UIColor.white
        self.label.fontSize = 18
        self.label.position = self.type.labelPosition()
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
