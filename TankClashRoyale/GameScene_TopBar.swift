//
//  GameScene_TopBar.swift
//  TankClashRoyale
//
//  Created by Anthony on 25/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


protocol GameScene_TopBar {
    
}

extension GameScene : GameScene_TopBar{
    
    func addTopMenu(){
        topMenu = TopBar(size : CGSize(width: self.frame.width, height: 100))
        topMenu.position = CGPoint(x: 0, y: self.frame.maxY - 50)
        self.addChild(topMenu)
        
        greenScore = Score(image: #imageLiteral(resourceName: "Tank1"), isMine: true)
        greenScore.position = CGPoint(x: -240 , y: 0)
        topMenu.addChild(greenScore)
        
        redScore = Score(image: #imageLiteral(resourceName: "Tank1"), isMine: false)
        redScore.position = CGPoint(x: 200 , y: 0)
        topMenu.addChild(redScore)
        
        self.addTimer()
        self.startTimer(frequency: 1)
    }
    
    func startTimer(frequency : Double){
        self.removeAction(forKey: "UpdateInfo")
        let updateTimerAction = SKAction.run({() in self.updateTimer()})
        let interval = SKAction.wait(forDuration: frequency)
        let sequence = SKAction.sequence([updateTimerAction, interval])
        let forever = SKAction.repeatForever(sequence)
        self.run(forever, withKey: "UpdateInfo")
    }
    
    func addTimer(){
        self.timerLabel = Label(text: "", fontDetails : Fonts.header(scale: 0.9), backgroundImage: nil)
        self.timerLabel.position = CGPoint(x : 0, y : 0)
        self.timerLabel.text = "Time left"
        topMenu.addChild(self.timerLabel)
        
        self.timer = Label(text: "", fontDetails : Fonts.header(scale: 0.9), backgroundImage: nil)
        self.timer.position = CGPoint(x : 0 , y : -40)
        topMenu.addChild(self.timer)
    }

    func updateTimer(){
        guard self.gameOver == false else {
            return
        }
        self.timeLeft -= 1
        let minutes = self.timeLeft / 60
        let seconds = self.timeLeft % 60
        self.timer.text = "\(minutes)" + ":" + String(format: "%02d", seconds)
        self.timer.run(blinkSmallerAction())
        guard self.timeLeft > 0 else {
            self.removeAction(forKey: "UpdateInfo")
            self.gameOver = true
            return
        }

    }
    
}


