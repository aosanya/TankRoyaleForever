//
//  GameScene_Contact.swift
//  TankClashRoyale
//
//  Created by Anthony on 23/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol GameScene_Contact {
    
}

extension GameScene : GameScene_Contact{
    @objc(didBeginContact:) func didBegin(_ contact: SKPhysicsContact) {
        switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
        case GameObjectType.tank1.categoryBitMask() | GameObjectType.shot.categoryBitMask():
            self.gotShot(contact: contact)
        case GameObjectType.tank2.categoryBitMask() | GameObjectType.shot.categoryBitMask():
            self.gotShot(contact: contact)
        case GameObjectType.tank3.categoryBitMask() | GameObjectType.shot.categoryBitMask():
            self.gotShot(contact: contact)
        case GameObjectType.tank1.categoryBitMask() | GameObjectType.aidKit.categoryBitMask():
            self.collect(contact: contact)
        case GameObjectType.tank1.categoryBitMask() | GameObjectType.bomb.categoryBitMask():
            self.collect(contact: contact)
        case GameObjectType.tank2.categoryBitMask() | GameObjectType.aidKit.categoryBitMask():
             self.collect(contact: contact)
        case GameObjectType.tank2.categoryBitMask() | GameObjectType.bomb.categoryBitMask():
            self.collect(contact: contact)
        case GameObjectType.tank3.categoryBitMask() | GameObjectType.aidKit.categoryBitMask():
             self.collect(contact: contact)
        case GameObjectType.tank3.categoryBitMask() | GameObjectType.bomb.categoryBitMask():
            self.collect(contact: contact)
        case GameObjectType.tank1.categoryBitMask() | GameObjectType.cell.categoryBitMask():
            self.addCellContact(contact: contact)
        case GameObjectType.tank2.categoryBitMask() | GameObjectType.cell.categoryBitMask():
            self.addCellContact(contact: contact)
        case GameObjectType.tank3.categoryBitMask() | GameObjectType.cell.categoryBitMask():
            self.addCellContact(contact: contact)
        default:
            return
        }
        
    }
    
    @objc(didEndContact:) func didEnd(_ contact: SKPhysicsContact) {
        switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
        case GameObjectType.tank1.categoryBitMask() | GameObjectType.tank2.categoryBitMask() | GameObjectType.tank3.categoryBitMask() | GameObjectType.cell.categoryBitMask():
            let asset : Asset?
            let cell : Cell?
            
            if contact.bodyA.node is Asset{
                asset = contact.bodyA.node as? Asset
                cell = contact.bodyB.node as? Cell
            }
            else{
                asset = contact.bodyB.node as? Asset
                cell = contact.bodyA.node as? Cell
            }
            
            guard asset != nil else{
                return
            }
            
            guard cell != nil else{
                return
            }
            cell!.removeContactingAsset(id: asset!.id)
        default:
            return
        }
        
    }
    
    func gotShot(contact: SKPhysicsContact){
        var thisShot : Shot?
        var thisTank : LivingAsset?
        
        if contact.bodyA.node is Shot{
            thisShot = contact.bodyA.node as? Shot
            thisTank = contact.bodyB.node as? LivingAsset
        }
        else if contact.bodyB.node is Shot{
            thisShot = contact.bodyB.node as? Shot
            thisTank = contact.bodyA.node as? LivingAsset
        }
        
        guard thisShot != nil else{
            return
        }
        
        guard thisTank != nil else{
            return
        }
        
        if thisShot!.launcher != thisTank!.id{
            thisTank?.gotShot(shotPower: thisShot!.payload)
            //self.updateScores(isMine: thisTank!.isMine)
            thisShot!.remove()
        }
        
        //        case GameObjectType.tank1.categoryBitMask() | GameObjectType.mainHome.categoryBitMask(),
        //             GameObjectType.tank1.categoryBitMask() | GameObjectType.sideHome.categoryBitMask():
        //            self.mergeAssets(asset1: contact.bodyA.node as! Asset, asset2: contact.bodyB.node as! Asset)
    }
    
    func collect(contact: SKPhysicsContact){
        let asset : Asset?
        let cellObject : CellObject?
        
        if contact.bodyA.node is Asset{
            asset = contact.bodyA.node as? Asset
            cellObject = contact.bodyB.node as? CellObject
        }
        else{
            asset = contact.bodyB.node as? Asset
            cellObject = contact.bodyA.node as? CellObject
        }
        
        guard asset != nil else{
            return
        }
        
        guard cellObject != nil else{
            return
        }
        
        guard cellObject!.removed == false else {
            return
        }
        
        if cellObject!.type == GameObjectType.bomb{
            self.cellsNode.shake()
        }
        
        cellObject!.removed = true
        (asset as! LivingAsset).collect(collection: cellObject!.collection)
        if cellObject!.cell != nil{
            cellObject!.cell.object = nil
        }        
        cellObject!.removeFromParent()
    }
    
    func addCellContact(contact: SKPhysicsContact){
        let asset : Asset?
        let cell : Cell?
        
        if contact.bodyA.node is Asset{
            asset = contact.bodyA.node as? Asset
            cell = contact.bodyB.node as? Cell
        }
        else{
            asset = contact.bodyB.node as? Asset
            cell = contact.bodyA.node as? Cell
        }
        
        guard asset != nil else{
            return
        }
        
        guard cell != nil else{
            return
        }
        
        cell!.addContactingAsset(asset: asset!)
    }
}
