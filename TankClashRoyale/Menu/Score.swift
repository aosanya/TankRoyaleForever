//
//  Score.swift
//  TankClashRoyale
//
//  Created by Anthony on 20/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


class Score : SKNode{
    private var icon : SKSpriteNode?
    private var scoreValue : SKLabelNode?
    private var isMine : Bool
    
    private var showingScore : Double = 0
    
    var score : Double = 0{
        didSet{
            //self.scoreValue!.text = "\(round(100 * score)/100)"
            self.changeScore()
        }
    }
    
    init(image : UIImage, isMine : Bool) {
        self.isMine = isMine
        super.init()
        self.addIcon(image: image)
        self.addLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addIcon(image : UIImage){
        self.icon = SKSpriteNode(texture: SKTexture(image: image), color: UIColor.clear, size: CGSize(width: 50, height: 50))
        
        self.addChild(self.icon!)
        self.icon!.zPosition = self.zPosition  +  1
        self.colorTeam()
    }
    
    
    private func colorTeam() {
        if self.isMine == true{
            self.icon!.color = UIColor.green
            self.icon!.colorBlendFactor = 0.5
        }
        else{
            self.icon!.color = UIColor.red
            self.icon!.colorBlendFactor = 0.5
        }
    }
    
    private func changeScore(){
        if self.action(forKey: "updatingScores") != nil{
            return
        }
        self.removeAction(forKey: "updatingScores")
        let updateScores = SKAction.run({() in self.updateScore()})
        let sequence = SKAction.sequence([SKAction.wait(forDuration: 0.05), updateScores])
        self.run(SKAction.repeatForever(sequence), withKey : "updatingScores")
    }
    
    private func updateScore(){
        let diff = abs(showingScore - score)
        var change = 0.01
        if diff > 0.1{
            change = 0.1
        }
        
        if showingScore < score{
            showingScore += change
            if showingScore > score{
                showingScore = score
            }
            icon!.run(blinkLargerAction(speed: 2))
            scoreValue!.run(blinkLargerAction(speed: 2))
        }
        else if showingScore > score {
            showingScore -= change
            if showingScore < score{
                showingScore = score
            }
            icon!.run(blinkSmallerAction(speed: 2))
            scoreValue!.run(blinkSmallerAction(speed: 2))
        }
        else{
            removeAction(forKey: "updatingScores")
        }
        self.scoreValue!.text = "\(round(100 * showingScore)/100)"
    }
    
    private func addLabels(){
        
        self.scoreValue = SKLabelNode(text: "")
        self.scoreValue!.fontName = Fonts.header(scale: 1).fontName
        self.scoreValue!.fontColor = Fonts.header(scale: 1).color
        
        self.scoreValue!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(scoreValue!)
        self.scoreValue!.zPosition = self.zPosition  +  1
        self.scoreValue!.position = CGPoint(x: self.icon!.frame.maxY + 10, y: self.icon!.frame.origin.y + 5)
    }
    
    
}

