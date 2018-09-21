//
//  Cell_AssetCreation.swift
//  PacManRoyale
//
//  Created by Anthony on 25/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol Cell_AssetCreation {
    
}

extension Cell : Cell_AssetCreation{
    func canCreateAsset() -> Bool{
        return (self.isGreenHomeCell || self.isRedHomeCell) && self.isEmpty()
    }
    
    func createAsset(isMine : Bool, duration : Double){
        self.alpha = 0.1
        startTimerShadow(isMine: isMine, duration: duration)
    }
    
    private func raiseAssetCreationComplete(isMine : Bool){
        self.alpha = 1
        self.isReadyToCreatAsset = true
        self.delegate!.assetCreationComplete(cell: self, isMine: isMine)
        self.isCreatingAsset = false
        
    }
    

    
    
    func startTimerShadow(isMine : Bool, duration : Double)  {
        func addAsset(){
            self.delegate!.createAsset(cell: self, isMine: isMine)
        }
        
        var actionName = ""
        var shadowColor : UIColor = UIColor.clear
        self.isCreatingAsset = true
        
        if isMine == true{
            shadowColor = UIColor.green
            actionName = "creatingMyCells"
        }
        else{
            shadowColor = UIColor.red
            actionName = "creatingEnemyCells"
        }
        var timerShadow : SKSpriteNode
        
        let timerAtlas = SKTextureAtlas(named: "Timer")
        var timerFrames = [SKTexture]()
        
        
        for i in 0...72 {
            let timerTextureName = "timerShade\(i * 5)"
            timerFrames.append(timerAtlas.textureNamed(timerTextureName))
        }
        
        timerShadow = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "whiteCircle")), color: UIColor.clear, size: self.frame.size.factor(0.8))
        
        let timerAction = SKAction.animate(with: timerFrames, timePerFrame: duration / Double(timerFrames.count))
        
        let removeAction = SKAction.run({() in timerShadow.removeFromParent()})
        timerShadow.alpha = 1
        timerShadow.color = shadowColor
        timerShadow.colorBlendFactor = 0.5
        timerShadow.zPosition = self.zPosition - 1
        self.addChild(timerShadow)
        
        let addAssetAction = SKAction.run({() in addAsset()})
        
        timerShadow.run(SKAction.sequence([timerAction, addAssetAction, removeAction]), withKey : actionName)
        let completeAction = SKAction.run({() in self.raiseAssetCreationComplete(isMine: isMine)})
        self.run(SKAction.sequence([SKAction.wait(forDuration: duration), completeAction]), withKey : actionName)
    }
    
}
