//
//  TankSelector.swift
//  TankClashRoyale
//
//  Created by Anthony on 09/10/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol TankSelectorDelegate {
    func selectedTankReady(selector : TankSelector)
}

class TankSelector : SKNode{
    var isMine : Bool
    var tanks : [Button] = [Button]()
    var types : [AssetType]
    var delegate : TankSelectorDelegate!
    var selected : String = ""
    var selectedType : AssetType!
    var canSelect : Bool = true
    var readyAssets : [AssetType] = [AssetType]()    
    
    init(assetTypes : [AssetType], isMine : Bool) {
        self.types = assetTypes
        self.isMine = isMine
        super.init()
        self.addTanks()
        self.selectDefault()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTanks(){
        var startPoint = (CGFloat(types.count) / -2) + 0.5
        for i in 0...types.count - 1{
            let tank = Button(image: types[i].images(), action: selectTank, size : types[i].selectorSize())
            tank.data = types[i] as AnyObject
            tank.setBackground2(image: #imageLiteral(resourceName: "Tile_1"), size: CGSize(width: 120, height: 120))
            tank.position = CGPoint(x: tank.calculateAccumulatedFrame().size.width * startPoint * 1.5 , y: 0)
            self.startTimerShadow(selector: tank, type: types[i])
            self.tanks.append(tank)
            startPoint += 1
            self.addChild(tank)
        }
    }
    
    func deInitialize(){
        self.tanks.removeAll()
    }
    
    func startCreatingTanks(){
        for each in self.tanks{
            each.isPaused = false
        }
    }
    
    private func selectDefault(){
        guard self.tanks.count > 0 else {
            return
        }
        
        self.switchTanks(thisButton: self.tanks[0])
    }
    

    func selectTank(thisButton : Button){
        guard self.canSelect == true else {
            return
        }
        self.switchTanks(thisButton: thisButton)
    }
    
   private func deselectTanks(){
        for each in self.tanks{
            if self.selected != each.id{                
                each.setBackground2(image: #imageLiteral(resourceName: "Tile_1"))
                each.scale(to: 1, duration: 0.1)
            }
        }
    }
    
    private func switchTanks(thisButton : Button){
        guard thisButton.id != self.selected else {
            return
        }
        
        thisButton.setBackground2(image: #imageLiteral(resourceName: "Tile_Glowing"))
        thisButton.scale(to: 1.25, duration: 0.1)
        self.selected = thisButton.id
        self.selectedType = thisButton.data! as? AssetType
        self.deselectTanks()
    }
    
    func selectRandom(){
        let rand = randint(0, upperLimit: self.tanks.count)
        self.switchTanks(thisButton: self.tanks[rand])
    }
    
    private func startTimerShadow(selector : Button, type : AssetType)  {
       func addAsset(){
            self.readyAssets.append(type)
            if self.selectedType == type{
                self.delegate.selectedTankReady(selector: self)
            }
        }

        let duration = type.creationTime()
        var timerShadow : SKSpriteNode
        
        let timerAtlas = SKTextureAtlas(named: "Timer")
        var timerFrames = [SKTexture]()
        
        
        for i in 0...72 {
            let timerTextureName = "timerShade\(i * 5)"
            timerFrames.append(timerAtlas.textureNamed(timerTextureName))
        }
        
        timerShadow = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "timerShade10")), color: UIColor.clear, size: selector.calculateAccumulatedFrame().size.factor(1.15))
        
        let timerAction = SKAction.animate(with: timerFrames, timePerFrame: duration / Double(timerFrames.count))

        let removeAction = SKAction.run({() in timerShadow.removeFromParent()})
        timerShadow.alpha = 0.5
        timerShadow.color = UIColor.lightGray
        timerShadow.colorBlendFactor = 0.5
        
        timerShadow.zPosition = 3000
        timerShadow.position = CGPoint(x: 0, y: selector.calculateAccumulatedFrame().size.height * 0.05)
        selector.addChild(timerShadow)
        
        
        timerShadow.run(SKAction.sequence([timerAction, removeAction]), withKey : "creating")
        let completeAction = SKAction.run({() in addAsset()})
        selector.run(SKAction.sequence([SKAction.wait(forDuration: duration), completeAction]), withKey : "creating")
        selector.isPaused = true
    }
    
}
