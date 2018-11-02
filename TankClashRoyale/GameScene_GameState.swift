//
//  GameScene_GameOver.swift
//  TankClashRoyale
//
//  Created by Anthony on 27/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol GameScene_GameState {
    
}

extension  GameScene : GameScene_GameState{
    private func stopActions(){
        self.stopResourceGeneration()
        
        for each in assets.living{
            each.removeAllActions()
            each.isPaused = true
        }
        for each in assets.nonliving{
            each.removeAllActions()
            each.isPaused = true
        }
        for each in cells.set{
            each.removeAllActions()
            each.isPaused = true
        }
    }
    
    func loadGameOver(){
        self.hideSelectors()
        self.stopActions()
        
        self.updateScores(isMine: true)
        self.updateScores(isMine: false)
        
        self.greenScore.closeScore()
        self.redScore.closeScore()
        
        let pointsChange = (Double(self.greenScore.score - self.redScore.score) / 100) * 2
        
        self.gameOverControl = GameOverControl(pointsChange: pointsChange, scoreDiff : Double(self.greenScore.score - self.redScore.score))
        self.gameOverControl!.delegate = self
        self.gameOverControl!.position = CGPoint(x: 0, y: self.topMenu.frame.minY - 100)
        self.addChild(self.gameOverControl!)
        self.repositionCellNode()
        
        for each in self.delegates{
            each.gameOver(Iwin : pointsChange > 0)
        }
        
        if pointsChange > 0 {
            self.greenScore.blinkBigger()
            self.redScore.blinkSmaller()
        }
        else{
            self.greenScore.blinkSmaller()
            self.redScore.blinkBigger()
        }
        
    }
    
    func hideLoser(){
        if self.greenScore.score > self.redScore.score{
            self.assets.hide(isMine: false)
        }
        else if self.greenScore.score < self.redScore.score{
            self.assets.hide(isMine: true)
        }
        
    }
    
    func hideSelectors(){
        self.greenSelector.fadeOut(duration: 1)
        self.redSelector.fadeOut(duration: 1)
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
