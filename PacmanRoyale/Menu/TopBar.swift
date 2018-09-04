//
//  TopBar.swift
//  PacManRoyale
//
//  Created by Anthony on 20/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


class TopBar : SKSpriteNode{
    
    init(size : CGSize) {
        super.init(texture: SKTexture(image: #imageLiteral(resourceName: "TopBar")), color: UIColor.clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
