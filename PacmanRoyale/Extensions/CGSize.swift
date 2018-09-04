//
//  CGSize.swift
//  PacManRoyale
//
//  Created by Anthony on 20/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

extension CGSize{
    func factor(_ factor : CGFloat) -> CGSize{
        return CGSize(width: self.width * factor, height: self.height * factor)
    }
    
    func factor(xFactor : CGFloat, yFactor : CGFloat) -> CGSize{
        return CGSize(width: self.width * xFactor, height: self.height * yFactor)
    }
    
    func area() -> CGFloat{
        return self.width * self.height
    }
    
    func fitTo(size : CGSize) -> CGSize{
        var factor : CGFloat = 1
        if self.width > self.height{
            factor =   size.width / self.width
        }
        else{
            factor =  size.height / self.height
        }
        return self.factor(factor)
    }
}
