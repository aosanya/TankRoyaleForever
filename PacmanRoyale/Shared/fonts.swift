//
//  fonts.swift
//  BrainWars
//
//  Created by Anthony on 22/07/2017.
//  Copyright © 2017 CodeVald. All rights reserved.
//

import UIKit

protocol DelegateFontDetails{
    func fontColorChanged(oldValue : UIColor, newValue : UIColor)
}

class FontDetails{
    var delegate : DelegateFontDetails?
    var color : UIColor{
        didSet{
            self.delegate?.fontColorChanged(oldValue: oldValue, newValue: self.color)
        }
    }
    var font : UIFont
    
    init(name : String, size : CGFloat, color : UIColor){
        self.font = UIFont(name: name, size: size)!
        self.color = color
    }
    
    var pointSize : CGFloat{
        get{
            return self.font.pointSize
        }
    }
    
    
    var fontName : String{
        get{
            return self.font.fontName
        }
    }    
}

class Fonts {
    var defaultFontName = "ChalkboardSE-Regular"
    
    let defaultFont : FontDetails
    

    
    init(defaultFontName : String = "TrebuchetMS", scale : CGFloat){
        self.defaultFontName = defaultFontName        
        self.defaultFont = FontDetails(name: self.defaultFontName, size: 30 * scale, color: UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1))
    }
    
    static func header(scale : CGFloat) -> FontDetails{
        return FontDetails(name: "AppleSDGothicNeo-Bold", size: 30 * scale, color: UIColor(hue: 160/255, saturation: 0/255, brightness: 102/255, alpha: 1))
    }
}
