//
//  GameScene_GameOver.swift
//  PacManRoyale
//
//  Created by Anthony on 27/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol GameScene_GameState {
    
}

extension  GameScene : GameScene_GameState{
    func loadGameOver(){
        
        self.gameOverControl = GameOverControl(pointsChange: self.greenScore.score - self.redScore.score)
        self.gameOverControl!.delegate = self
        self.gameOverControl!.position = CGPoint(x: 0, y: self.topMenu.frame.minY - 100)
        self.addChild(self.gameOverControl!)
        self.repositionCellNode()
        
        for each in self.delegates{
            each.gameOver(Iwin : self.greenScore.score > self.redScore.score)
        }
    }
    
    func showingPoints() {
        self.cellsNode.popOut(duration: 1, callBack: fadeOutCellsNode)
    }
    
    func fadeOutCellsNode(){
        self.cellsNode.fadeOut(duration: 1, callBack: centerGameOver)
    }
    
    func centerGameOver(){
        self.gameOverControl!.move(to: CGPoint(x: 0, y: 100), duration: 1)
    }
    
    func repositionCellNode(){
        let test = topMenu.calculateAccumulatedFrame().maxY - self.cellsNode!.calculateAccumulatedFrame().maxY
        if test < 300{
            self.cellsNode!.move(by: CGVector(dx: 0, dy: (test - 300)), duration: 1)
        }
    }
    
//    func showGameOver(){
//        self.gameOverControl = GameOverControl(pointsChange: 20)
//        self.gameOverControl!.delegate = self
//        self.gameOverControl!.position = CGPoint(x: 0, y: self.topMenu.frame.minY - 100)
//        self.addChild(self.gameOverControl!)
//        self.repositionCellNode()
//    }
    
    func loadGameStart(){
//        for each in self.delegates{
//            
//        }
    }
}
