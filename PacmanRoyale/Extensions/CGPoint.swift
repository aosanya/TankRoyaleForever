//
//  CGPoint.swift
//  PacManRoyale
//
//  Created by Anthony on 20/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

extension CGPoint{
    func factorAspectRatio(scene : SKScene) -> CGPoint{
        
        let xRatio = scene.frame.size.width / scene.view!.bounds.width
        let yRatio = (scene.frame.size.height ) / scene.view!.bounds.height
        
        switch scene.scaleMode {
        case .aspectFill:
            return CGPoint(x : (self.x) , y : (self.y / yRatio) * xRatio)
        case .aspectFit:
            var aspectRatio : CGFloat = 0
            if xRatio < yRatio{
                aspectRatio = xRatio / yRatio
            }
            else{
                aspectRatio = yRatio / xRatio
            }
            return CGPoint(x : (self.x) * aspectRatio , y : self.y * aspectRatio)
        default:
            return self
        }
    }
    
//    func factorTopSafeArea(scene : SKScene) -> CGPoint{
//        //Ayayayai!
//        var topSafe  = scene.view!.safeAreaInsets.top
//        if topSafe > 0{
//            topSafe = topSafe + 20
//        }
//        return CGPoint(x: self.x, y: self.y - (topSafe * scene.aspectRatio()))
//    }
}
