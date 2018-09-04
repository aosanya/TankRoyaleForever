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
}

class GameOverControl: SKNode {
    var lblGameOver : SKLabelNode!
    var lblPoints : SKLabelNode!
    var lblChange : SKLabelNode!
    var lblLevel : SKLabelNode!
    var points : SKNode = SKNode()
    var delegate : GameOverDelegate?
    var pointsChange : Int
    var Iwin : Bool
    
    init(pointsChange : Int) {
        self.pointsChange = pointsChange
        self.Iwin = pointsChange > 0
        super.init()
        UserInfo.changeScore(change: pointsChange)
        self.addLabels()
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
            self.lblGameOver.popOut(duration: 1, callBack: addPointsLabel)
        }
        else{
            self.lblGameOver.text = "You Loose"
        }
        
    }
    
    private func addPointsLabel(){
        self.lblPoints = SKLabelNode(text: "\(UserInfo.getScore())")
        self.lblPoints.fontName = "ChalkboardSE-Regular"
        self.lblPoints.fontColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        self.lblPoints.fontSize = 30
        self.lblPoints.position.y = 0
        self.points.addChild(self.lblPoints!)
        self.lblPoints.zPosition = self.zPosition + 2
        
        var pointsChangeLabel = ""
        if self.pointsChange > 0{
            pointsChangeLabel = "+\(pointsChange)"
        }
        else{
            pointsChangeLabel = "-\(pointsChange)"
        }
        
        self.lblChange = SKLabelNode(text: pointsChangeLabel)
        self.lblChange.fontName = "ChalkboardSE-Regular"
        self.lblChange.fontSize = 20
        self.lblChange.position.y =  5
        self.lblChange.position.x = lblPoints.calculateAccumulatedFrame().maxX + lblChange.calculateAccumulatedFrame().width / 2 + 10
        points.addChild(self.lblChange!)
        self.lblChange.zPosition = self.zPosition + 2
        self.setLabelTheme(lbl: lblChange)
        
        points.position.y = lblGameOver.frame.minY - lblPoints.frame.height - 30
        points.position.x = points.calculateAccumulatedFrame().width * -0.27
        self.addChild(points)
        
        points.setScale(0)
        points.popOut(duration: 1, callBack: addLevelLabel)
        
        self.delegate!.showingPoints()
    }
    
    private func addLevelLabel(){
        self.lblLevel = SKLabelNode(text: "\(UserInfo.getLevel())")
        self.lblLevel.fontName = "ChalkboardSE-Regular"
        self.lblLevel.fontColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        self.lblLevel.fontSize = 28
        self.lblLevel.position.y = self.points.calculateAccumulatedFrame().minY - lblLevel.frame.height - 30
        self.addChild(self.lblLevel!)
        self.lblLevel.zPosition = self.zPosition + 2
        self.lblLevel.setScale(0)
        self.lblLevel.popOut(duration: 1, callBack: nil)
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
