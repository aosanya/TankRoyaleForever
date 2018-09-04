//
//  GameScene_Contact.swift
//  PacManRoyale
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
        case GameObjectType.tank1.categoryBitMask() | GameObjectType.tank1.categoryBitMask():
            self.mergeAssets(asset1: contact.bodyA.node as! Asset, asset2: contact.bodyB.node as! Asset)
//        case GameObjectType.tank1.categoryBitMask() | GameObjectType.mainHome.categoryBitMask(),
//             GameObjectType.tank1.categoryBitMask() | GameObjectType.sideHome.categoryBitMask():
//            self.mergeAssets(asset1: contact.bodyA.node as! Asset, asset2: contact.bodyB.node as! Asset)
//        case GameObjectType.tank1.categoryBitMask() | GameObjectType.candy1.categoryBitMask(),
//             GameObjectType.tank1.categoryBitMask() | GameObjectType.candy2.categoryBitMask(),
//             GameObjectType.tank1.categoryBitMask() | GameObjectType.candy3.categoryBitMask(),
//             GameObjectType.tank1.categoryBitMask() | GameObjectType.candy4.categoryBitMask(),
//             GameObjectType.tank1.categoryBitMask() | GameObjectType.candy5.categoryBitMask():
//            let asset : Asset?
//            let object : CellObject?
//            
//            if contact.bodyA.node is Asset{
//                asset = contact.bodyA.node as? Asset
//                object = contact.bodyB.node as? CellObject
//            }
//            else{
//                asset = contact.bodyB.node as? Asset
//                object = contact.bodyA.node as? CellObject
//            }
//            
//            self.collect(asset: asset!, cellObject: object!)
        case GameObjectType.tank1.categoryBitMask() | GameObjectType.cell.categoryBitMask():
            (contact.bodyA.node as! Cell).addContactingAsset(asset: (contact.bodyB.node as! Asset))
        default:
            return
        }
        
    }
    
    @objc(didEndContact:) func didEnd(_ contact: SKPhysicsContact) {
        switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
        case GameObjectType.tank1.categoryBitMask() | GameObjectType.cell.categoryBitMask():
            (contact.bodyA.node as! Cell).removeContactingAsset(id: (contact.bodyB.node as! Asset).id)
        default:
            return
        }
        
    }
    
    func mergeAssets(asset1 : Asset, asset2 : Asset){
        guard asset1.isRemoved == false else {
            print("Is already removed")
            return
        }
        guard asset2.isRemoved == false else {
            print("Is already removed")
            return
        }
        
        if asset1.strength > asset2.strength{
            asset1.merge(asset: asset2)
            assets.remove(asset: asset2)
        }
        else if asset1.strength < asset2.strength{
            asset2.merge(asset: asset1)
            assets.remove(asset: asset1)
        }
        else if asset1.isMine == asset2.isMine{
            asset1.merge(asset: asset2)
            assets.remove(asset: asset2)
        }
        else {
            assets.remove(asset: asset1)
            assets.remove(asset: asset2)
        }
        
        self.updateScores(thisAsset: asset1)
        self.updateScores(thisAsset: asset2)
        return
    }
    
    func collect(asset : Asset, cellObject : CellObject){
        
        guard cellObject.removed == false else {
            return
        }
        print(cellObject.type )
        cellObject.removed = true
        asset.collect(object: cellObject)
        cellObject.cell.object = nil
        cellObject.removeFromParent()
    }
}
