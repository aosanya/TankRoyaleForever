//
//  Button.swift
//  PacManRoyale
//
//  Created by Anthony on 09/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


class Button : SKNode{
    private var backgroundImage : SKSpriteNode?
    private var label : SKLabelNode?
    private var text : String
    private var action : (()  -> Void)
    
    init(text : String, action : @escaping(()  -> Void)) {
        self.text = text
        self.action = action
        super.init()
        self.addLabel()
        self.addBackground()
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabel(){
        self.label = SKLabelNode(text: self.text)
        self.label!.fontName = "ChalkboardSE-Regular"
        self.label!.fontColor = UIColor(red: 30/255, green: 69/255, blue: 62/255, alpha: 1)
        self.label!.fontSize = 35
        self.label!.position.y = 0
        self.label!.zPosition = self.zPosition + 2
        self.addChild(self.label!)
        self.label!.isUserInteractionEnabled = false
    }
    
    func addBackground(){
        let texture = SKTexture(image: #imageLiteral(resourceName: "lightgreybutton"))
        texture.filteringMode = .nearest
        let labelSize = self.label!.calculateAccumulatedFrame()
        let size = CGSize(width: labelSize.width + 100, height: labelSize.height + 30)
        backgroundImage = SKSpriteNode(texture: texture, color: UIColor.clear, size: size)
        backgroundImage!.position = CGPoint(x: 0, y: 10)
        backgroundImage!.zPosition = self.zPosition + 1
        self.addChild(backgroundImage!)
        self.backgroundImage!.isUserInteractionEnabled = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.action()
    }
}
