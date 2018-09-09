//
//  GameOverControl.swift
//  PacManRoyale
//
//  Created by Anthony on 26/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol GameOverDelegate {
    func showingPoints()
    func restartGame()
}

class GameOverControl: SKNode {
    var lblGameOver : SKLabelNode!
    var lblPoints : SKLabelNode!
    var playButton : Button!
    var points : SKNode = SKNode()
    var delegate : GameOverDelegate?
    var scoreChange : Double
    var Iwin : Bool
    
    init(pointsChange : Double) {
        self.scoreChange = pointsChange * 0.1
        self.Iwin = pointsChange > 0
        super.init()
        self.normalizeScoreChange()
        UserInfo.changeScore(change: self.scoreChange)
        self.addLabels()
        self.schedulePlayButton()
    }
    
    func normalizeScoreChange(){
        let currentScore = UserInfo.getScore()
        
        if self.scoreChange + currentScore > 10{
            self.scoreChange = 10 - currentScore
        }
        
        if self.scoreChange + currentScore < 0{
            self.scoreChange = currentScore * -1
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabels(){
        self.lblGameOver = SKLabelNode(text: "Game Over")
        self.lblGameOver.fontName = "ChalkboardSE-Regular"
        self.lblGameOver.fontSize = 35
        self.addChild(self.lblGameOver!)
        self.lblGameOver.zPosition = self.zPosition + 2
        self.lblGameOver.setScale(0)
        self.lblGameOver.popOut(duration: 2, callBack: showWinner)
        self.setLabelTheme(lbl: lblGameOver)
    }
    
    
    private func showWinner(){
        if self.Iwin == true{
            self.lblGameOver.text = "You win"
        }
        else{
            self.lblGameOver.text = "You Lose"
        }
        self.lblGameOver.popOut(duration: 1, callBack: addPointsLabel)
        
    }
    
    private func addPointsLabel(){
        self.lblPoints = SKLabelNode(text: "Next Level : \(UserInfo.getLevel())")
        self.lblPoints.fontName = "ChalkboardSE-Regular"
        self.lblPoints.fontColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        self.lblPoints.fontSize = 30
        self.lblPoints.position.y = 0
        self.points.addChild(self.lblPoints!)
        self.lblPoints.zPosition = self.zPosition + 2
        
        points.position.y = lblGameOver.frame.minY - lblPoints.frame.height - 30
        points.position.x = 0 //points.calculateAccumulatedFrame().width //* -0.5
        self.addChild(points)
        
        points.setScale(0)
        points.popOut(duration: 1, callBack: nil)
        
        self.delegate!.showingPoints()
        
    }
        
    private func schedulePlayButton(){
        self.run(scheduleAction(duration: 7, callBack: addPlayButton))
    }
    
    private func addPlayButton(){
        self.playButton = Button(text: "Play Again", action: restartGame)
        self.playButton.zPosition = self.zPosition + 2
        self.addChild(self.playButton)
        self.playButton.position.y = points.calculateAccumulatedFrame().minY - self.playButton.calculateAccumulatedFrame().height - 30
    }
    
    func restartGame(){
        self.delegate!.restartGame()
    }
    
    private func setLabelTheme(lbl : SKLabelNode) {
        if self.Iwin == true{
            lbl.fontColor = UIColor(red: 0/255, green: 198/255, blue: 0/255, alpha: 1)
            lbl.fontColor = UIColor(red: 0/255, green: 198/255, blue: 0/255, alpha: 1)
        }
        else{
            lbl.fontColor = UIColor(red: 198/255, green: 0/255, blue: 0/255, alpha: 1)
            lbl.fontColor = UIColor(red: 198/255, green: 0/255, blue: 0/255, alpha: 1)
        }
    }
    
    
}
