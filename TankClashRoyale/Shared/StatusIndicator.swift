//
//  HomeStatus.swift
//  TankClashRoyale
//
//  Created by Anthony on 19/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


class StatusIndicator : SKSpriteNode{
    init() {
        super.init(texture: SKTexture(image: #imageLiteral(resourceName: "3_Stars_Filled")), color: UIColor.clear, size: CGSize(width: 60, height: 30))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
