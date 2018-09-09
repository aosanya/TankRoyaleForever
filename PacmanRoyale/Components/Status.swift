//
//  State.swift
//  PacManRoyale
//
//  Created by Anthony on 06/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol StateDelegate {
    func stateChange(thisStatu : Status)
    func stateLow(thisStatus : Status)
    func recovered(thisStatus : Status)
    func zeroState(thisStatus : Status)
}

class Status {
    var statusBar : SKSpriteNode!
    var minState : Double
    var maxState : Double
    var size : CGSize
    var pos : CGPoint
    var stateDelegate : StateDelegate?
    
    var state : Double{
        didSet{
            
            if state > oldValue{
                //print("increased")
            }
            if state < minState{
                state = minState
            }
            if state > maxState{
                state = maxState
            }
            guard state != oldValue else {
                return
            }
            
            self.updateStatusBar()
            
            if stateDelegate != nil{
                self.stateDelegate!.stateChange(thisStatu: self)
                if state == 0{
                    self.stateDelegate!.zeroState(thisStatus: self)
                }
                if oldValue < maxState && state == maxState {
                    self.stateDelegate!.recovered(thisStatus: self)
                }
                if state < maxState{
                    self.stateDelegate!.stateLow(thisStatus: self)
                }
            }
        }
    }
    
    init(minState : Double, maxState : Double, size : CGSize, pos : CGPoint){
        self.minState = minState
        self.maxState = maxState
        self.state = self.maxState
        self.size = size
        self.pos = pos
        self.addStateBar()
    }
    
    func addStateBar(){
        let bodyTexture = SKTexture(image:StatusDisplay(rawValue: 100)!.displayImage())
        bodyTexture.filteringMode = .nearest
        self.statusBar = SKSpriteNode(texture: bodyTexture, color: UIColor.clear, size: self.size)
        self.statusBar.position = pos
        self.statusBar.alpha = 0.75
    }
    
    var percentageStatus : Double{
        get{
            return Double(convertRange(Float(minState), fromMax: Float(maxState), toMin: 0, toMax: 100, convertVal: Float(self.state)))
        }
    }
    
    
    
    private func updateStatusBar(){
        var val = Int(self.percentageStatus / 5)
        val = val * 5
        self.statusBar.texture = SKTexture(image: StatusDisplay(rawValue: val)!.displayImage())
    }
}
