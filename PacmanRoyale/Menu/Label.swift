//
//  Label.swift
//  BrainWars
//
//  Created by Anthony on 09/04/2017.
//  Copyright © 2017 CodeVald. All rights reserved.
//

import SpriteKit

class Label : SKNode{
    internal var label : SKLabelNode!
    private var icon: SKSpriteNode!
    internal var backgroundImage : SKSpriteNode?
    var horizontalAlignment : SKLabelHorizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center{
        didSet{
            
            self.align()
        }
    }
    
    var fontDetails : FontDetails
    
    var text : String{
        didSet{
            self.label.text = text
        }
    }
    
    init(text : String, fontDetails : FontDetails, backgroundImage : UIImage?){
        self.text = text
        self.fontDetails = fontDetails
        super.init()
        self.addLabel()
        self.setBackground(image: backgroundImage)
    }
    
    init(text : String, fontDetails : FontDetails, iconImage : UIImage?, iconSize : CGSize?, backgroundImage : UIImage?){
        self.text = text
        self.fontDetails = fontDetails
        super.init()
        self.addLabel()
        self.setBackground(image: backgroundImage)
        if iconImage != nil{
            self.addIcon(image: iconImage!, iconSize: iconSize)
        }
    }
    
    func deInitialize(){
        self.removeAllChildren()
        self.label = nil
        self.backgroundImage = nil
        self.icon = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backgroundAlpha : CGFloat = 0.9{
        didSet{
            guard backgroundImage != nil else {
                return
            }
            
            self.backgroundImage?.alpha = backgroundAlpha
        }
    }
    
    func addLabel(){
        self.label = SKLabelNode(fontNamed: self.fontDetails.fontName)
        self.label.fontSize = self.fontDetails.font.pointSize
        self.label.position = CGPoint(x:0, y:0)
        self.label.fontColor = fontDetails.color
        self.label.text = text
        self.label.zPosition = self.zPosition + 1
        self.addChild(label)
    }
    
    private func addIcon(image : UIImage, iconSize : CGSize?){
        let texture = SKTexture(image: image)
        var iconSize = iconSize
        texture.filteringMode = .nearest
        
        if iconSize != nil{
            icon = SKSpriteNode(texture: texture, color: UIColor.clear, size: iconSize!)
        }
        else{
            iconSize = CGSize(width: 30, height: 30)
            icon = SKSpriteNode(texture: texture, color: UIColor.clear, size: CGSize(width: 30, height: 30))
        }
        
        self.addChild(icon)
    }
    
    private func align(){
        self.label.horizontalAlignmentMode = self.horizontalAlignment
        if self.horizontalAlignment == SKLabelHorizontalAlignmentMode.right{
            icon.position = CGPoint(x: self.label.calculateAccumulatedFrame().maxX + self.icon.size.width * 0.7, y: self.icon.size.height * 0.25)
        }
        else{
            icon.position = CGPoint(x: self.label.calculateAccumulatedFrame().minX - self.icon.size.width * 0.7, y: self.icon.size.height * 0.25)
        }
    }
    
    func fade(to : CGFloat,duration : Double = 1){
        self.run(SKAction.sequence([SKAction.fadeAlpha(to: to, duration: duration)]), withKey: "fading")
    }
    
    func setBackground(image : UIImage?){
        guard image != nil else {
            self.backgroundImage?.removeFromParent()
            return
        }
        
        var size = CGSize(width: self.label.frame.width + 50, height: self.label.frame.height + 30)
        if self.backgroundImage != nil{
            size = (self.backgroundImage?.size)!
            self.backgroundImage?.removeFromParent()
        }
        
        let texture = SKTexture(image: image!)
        texture.filteringMode = .nearest
        self.backgroundImage = SKSpriteNode(texture: texture, color: UIColor.clear, size: size)
        self.backgroundImage?.position = CGPoint(x: 0, y: 5)
        self.backgroundImage?.alpha = backgroundAlpha
        self.backgroundImage?.zPosition = 1
        self.addChild(backgroundImage!)
    }
}
