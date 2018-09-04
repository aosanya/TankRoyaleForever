//
//  Score.swift
//  PacManRoyale
//
//  Created by Anthony on 20/07/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


class Score : SKNode{
    private var icon : SKSpriteNode?
    private var scoreValue : SKLabelNode?
    private var isMine : Bool
    var score : Int = 0{
        didSet{
            self.scoreValue!.text = "\(score)"
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
    
    private func addLabels(){
        self.scoreValue = SKLabelNode(text: "")
        self.scoreValue!.fontName = "AppleSDGothicNeo-Bold"
        self.scoreValue!.fontColor = UIColor(hue: 160/255, saturation: 0/255, brightness: 102/255, alpha: 1)
        
        self.scoreValue!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(scoreValue!)
        self.scoreValue!.zPosition = self.zPosition  +  1
        self.scoreValue!.position = CGPoint(x: self.icon!.frame.maxY + 10, y: self.icon!.frame.origin.y + 5)
    }
    
    
}

