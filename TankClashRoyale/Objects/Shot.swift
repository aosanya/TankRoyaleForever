//
//  Shot.swift
//  TankClashRoyale
//
//  Created by Anthony on 05/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

class Shot : SKSpriteNode {
    var launcher : UInt
    var payload : Double
    init(pos : CGPoint, direction : CGFloat, launcher : UInt, payload : Double) {
        self.launcher = launcher
        self.payload = payload
        super.init(texture: SKTexture(image: GameObjectType.shot.image()), color: UIColor.clear, size: GameObjectType.shot.size()!)
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.categoryBitMask = GameObjectType.shot.categoryBitMask()
        self.physicsBody?.contactTestBitMask = GameObjectType.shot.contactTestBitMask()
        self.physicsBody?.collisionBitMask = 0
   
        self.physicsBody?.restitution = 1
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.friction = 0
        
        self.zRotation =  direction
        self.position = pos
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(direction : CGVector){
        
    }
    
    func remove(){
        self.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody = nil

        let removeAction = SKAction.run({() in self.removeFromParent()})
        let sequence = SKAction.sequence([ removeAction])
        self.run(sequence)
        
    }

    
}
