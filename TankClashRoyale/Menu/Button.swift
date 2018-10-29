//
//  Button.swift
//  TankClashRoyale
//
//  Created by Anthony on 09/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit


class Button : SKNode{
    var id : String = UUID().uuidString
    private var backgroundImage : SKSpriteNode?
    private var backgroundImage2 : SKSpriteNode?
    
    private var label : SKLabelNode?
    private var text : String
    private var action : ((Button)  -> Void)
    var data : AnyObject?
    
    init(text : String, action : @escaping((Button)  -> Void)) {
        self.text = text
        self.action = action
        super.init()
        self.addLabel()
        let labelSize = self.label!.calculateAccumulatedFrame()
        self.addBackground(size: CGSize(width: labelSize.width + 100, height: labelSize.height + 30))
        self.isUserInteractionEnabled = true
    }
    
    init(image : UIImage, action : @escaping((Button)  -> Void), size : CGSize = CGSize(width: 50, height: 50)) {
        self.text = ""
        self.action = action
        super.init()
        self.addBackground(image: image, size: size)
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
    
    func addBackground(image : UIImage = #imageLiteral(resourceName: "lightgreybutton"), size : CGSize){
        let texture = SKTexture(image: image)
        texture.filteringMode = .nearest
        backgroundImage = SKSpriteNode(texture: texture, color: UIColor.clear, size: size)
        backgroundImage!.position = CGPoint(x: 0, y: 10)
        backgroundImage!.zPosition = self.zPosition + 1
        self.addChild(backgroundImage!)
        self.backgroundImage!.isUserInteractionEnabled = false
    }
    
    func setBackground2(image : UIImage = #imageLiteral(resourceName: "lightgreybutton"), size : CGSize? = nil){
        let texture = SKTexture(image: image)
        texture.filteringMode = .nearest
        
        if backgroundImage2 != nil{
            backgroundImage2?.texture = texture
        }
        else{
            backgroundImage2 = SKSpriteNode(texture: texture, color: UIColor.clear, size: size!)
            backgroundImage2!.position = CGPoint(x: 0, y: 10)
            backgroundImage2!.zPosition = backgroundImage!.zPosition - 1
            self.addChild(backgroundImage2!)
            self.backgroundImage2!.isUserInteractionEnabled = false
        }
        
//        self.backgroundImage2!.color = UIColor.green
//        self.backgroundImage2!.colorBlendFactor = 0.5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.action(self)
    }
}
