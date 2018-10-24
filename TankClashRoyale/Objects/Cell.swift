//
//  Cell.swift
//  TankClashRoyale
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

class Cell : SKSpriteNode, LivingAssetDelegate{
    var id : Int
    var pos : CellPos
    var isCreatingAsset : Bool = false{
        didSet{
            if isCreatingAsset == false{
                self.isReadyToCreatAsset = false
            }
            self.setColor()
        }
    }
    
    var isReadyToCreatAsset : Bool = false
    var isRedHomeCell : Bool = false
    {
        didSet{
            self.createHomeCell()
        }
    }
    var isGreenHomeCell : Bool = false
    {
        didSet{
            self.createHomeCell()
        }
    }
    
    var generatedAsset : AssetType? {
        didSet{
            self.createAssetCell()
        }
    }
    
    var isGreenAssetCell : Bool = false
    {
        didSet{
            self.createAssetCell()
        }
    }

    var isRedAssetCell : Bool = false
    {
        didSet{
            self.createAssetCell()
        }
    }
    
    var label : SKLabelNode!
    
    var state : UInt = 0
    var delegate : CellDelegate?
    var object : GameObject?{
        didSet{
            if object != oldValue{
                if delegate != nil {
                    delegate!.objectChanged(cell: self)
                }
            }
        }
    }
    var stars : StatusIndicator?
    
//    var asset : GameObject?{
//        didSet{
//            if asset != oldValue{
//                if delegate != nil{
//                    delegate!.assetChanged(cell: self)
//                }
//                self.setColor()
//            }
//            if asset != nil && asset is LivingAsset {
//                (asset as! LivingAsset).livingAssetDelegates.append(self)
//            }
//        }
//    }
    
    var pointer : SKSpriteNode!
    
    var selectionPointer : SKSpriteNode!
    
    var asset : GameObject?{
        didSet{
            if asset != oldValue{
                if delegate != nil{
                    delegate!.assetChanged(cell: self)
                }
                self.setColor()
            }
            if asset != nil && asset is LivingAsset {
                (asset as! LivingAsset).livingAssetDelegates.append(self)
            }
        
        }
    }
    
    var assets = [GameObject]()
    
    func addAsset(asset : GameObject){
        let exists = assets.filter({m in m.id == asset.id}).count > 0
        
        guard assets.count == 0 else {
            return
        }
        guard exists == false else {
            return
        }
        
        assets.append(asset)
        self.asset = asset
    }
    
    func removeAsset(){
        guard self.asset != nil else {
            return
        }
        
        self.assets = assets.filter({m in m.id != self.asset!.id})
        self.asset = nil
    }
    
    var prevAsset : GameObject?{
        didSet{
            if prevAsset != oldValue{
                self.setColor()
            }
            if prevAsset != nil && prevAsset is LivingAsset {
                (prevAsset as! LivingAsset).livingAssetDelegates.append(self)
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
        
        self.addLabel()
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.categoryBitMask = GameObjectType.cell.categoryBitMask()
        self.physicsBody?.contactTestBitMask =  GameObjectType.cell.contactTestBitMask()
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.createHomeCell()
        //self.text("\(self.id)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func deInitialize(){
        self.delegate = nil
        self.label.removeAllChildren()
        self.removeAsset()
        self.object = nil
        self.pointer = nil
        self.selectionPointer = nil
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
    
    private func createHomeCell(){
//        if self.isRedHomeCell{
//            self.texture = SKTexture(image: #imageLiteral(resourceName: "Steel"))
//        }
//        else if self.isGreenHomeCell{
//            self.texture = SKTexture(image: #imageLiteral(resourceName: "Steel"))
//        }
    }
    
    private func createAssetCell(){
        guard self.generatedAsset != nil else{
            return
        }
        
        if self.isGreenAssetCell{
            self.texture = SKTexture(image: self.generatedAsset!.images())
            self.size = CGSize(width: 50, height: 50)
            
        }
        else if self.isRedAssetCell{
            self.texture = SKTexture(image: self.generatedAsset!.images())
            self.size = CGSize(width: 50, height: 50)
        }
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
        guard self.asset == nil else {
            return false
        }

        guard self.object == nil else {
            return false
        }
        
        guard self.isCreatingAsset == false else{
            return false
        }
        
        guard self.prevAsset == nil else {
            return false
        }
        return true
    }
    
    func canMoveTo() -> Bool{
        guard self.asset == nil else {
            return false
        }
        
        guard self.isCreatingAsset == false else{
            return false
        }
        
        guard self.prevAsset == nil else {
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
    
    func addPointer() {
        let angle = CGFloat(getRadAngle(self.position, pointB: self.prevAsset!.cell.position))
        let length = getDistance(self.position, pointB: self.prevAsset!.cell.position)
        
        self.removePointer()
        self.removeSelectionPointer()
        self.pointer = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "WhiteArrow")), color: UIColor.clear, size: CGSize(width : length, height : self.size.width * 0.25))
        let pos = extrapolatePointUsingAngle(self.pointer.position, direction: angle, byVal: length / 2)
        self.pointer.position = pos
        self.pointer.zPosition = 1
        
        self.pointer.zRotation = angle
        
        if (self.prevAsset as! Asset).isMine {
            self.pointer.color = UIColor.green
        }
        else{
            self.pointer.color = UIColor.red
        }
        self.pointer.colorBlendFactor = 1
        
        self.addChild(self.pointer)
    }
    
    func removePointer(){
        if self.pointer != nil{
            self.pointer.removeFromParent()
        }
    }
    
    func addSelectionPointer(from : Cell, isMine : Bool) {
        let angle = CGFloat(getRadAngle(self.position, pointB: from.position))
        //angle = angleToRadians(angle: radiansToAngle(angle) + 180)
        let length = getDistance(self.position, pointB: from.position)
        
        self.removeSelectionPointer()
        self.selectionPointer = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "WhiteArrow")), color: UIColor.clear, size: CGSize(width : length, height : self.size.width * 0.15))
        let pos = extrapolatePointUsingAngle(self.selectionPointer.position, direction: angle, byVal: length / 2)
        self.selectionPointer.position = pos
        self.selectionPointer.zPosition = 1
        
        self.selectionPointer.zRotation = angle
        
        if isMine {
            self.selectionPointer.color = UIColor.green
        }
        else{
            self.selectionPointer.color = UIColor.red
        }
        self.selectionPointer.colorBlendFactor = 1
        
        self.addChild(self.selectionPointer)
    }
    
    func removeSelectionPointer(){
        if self.selectionPointer != nil{
            self.selectionPointer.removeFromParent()
        }
    }
    
    func relativity(cell : Cell) -> (Int, Int){
        return (cell.pos.row - self.pos.row,  cell.pos.col - self.pos.col)
    }
    
    func neighboringAssetChanged(cell : Cell){        
        if self.asset != nil{
            if self.asset! is LivingAsset{
                let livingAsset = self.asset as! LivingAsset
                livingAsset.updateRelativeState(radius: 1, includingSelf: false)
                livingAsset.staticThink()
            }
        }
    }
    
    func neighboringObjectChanged(cell : Cell){
        if self.asset != nil{
            if self.asset! is LivingAsset{
                let livingAsset = self.asset as! LivingAsset
                livingAsset.updateRelativeState(radius: 1, includingSelf: false)
                livingAsset.staticThink()
            }
        }
    }    

    func addShot(livingAsset: LivingAsset) {
        
    }
    
    func dead(livingAsset: LivingAsset) {
        if asset != nil && asset!.id == livingAsset.id{
            self.removeAsset()
        }
        if prevAsset != nil && prevAsset!.id == livingAsset.id{
            prevAsset = nil
        }
    }
    
    func stateChanged(livingAsset: LivingAsset) {
        
    }
}
