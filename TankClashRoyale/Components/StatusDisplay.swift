//
//  StatusDisplay.swift
//  TankClashRoyale
//
//  Created by Anthony on 06/09/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

enum StatusDisplay : Int{
    case status0 = 0
    case status5 = 5
    case status10 = 10
    case status15 = 15
    case status20 = 20
    case status25 = 25
    case status30 = 30
    case status35 = 35
    case status40 = 40
    case status45 = 45
    case status50 = 50
    case status55 = 55
    case status60 = 60
    case status65 = 65
    case status70 = 70
    case status75 = 75
    case status80 = 80
    case status85 = 85
    case status90 = 90
    case status95 = 95
    case status100 = 100
    
    func displayImage() -> UIImage{
        switch self {
        case .status0: return #imageLiteral(resourceName: "redStatus0")
        case .status5: return #imageLiteral(resourceName: "redStatus5")
        case .status10: return #imageLiteral(resourceName: "redStatus10")
        case .status15: return #imageLiteral(resourceName: "redStatus15")
        case .status20: return #imageLiteral(resourceName: "redStatus20")
        case .status25: return #imageLiteral(resourceName: "redStatus25")
        case .status30: return #imageLiteral(resourceName: "redStatus30")
        case .status35: return #imageLiteral(resourceName: "redStatus35")
        case .status40: return  #imageLiteral(resourceName: "redStatus40")
        case .status45: return  #imageLiteral(resourceName: "redStatus45")
        case .status50: return  #imageLiteral(resourceName: "redStatus50")
        case .status55: return  #imageLiteral(resourceName: "redStatus55")
        case .status60: return #imageLiteral(resourceName: "redStatus60")
        case .status65: return #imageLiteral(resourceName: "redStatus65")
        case .status70: return #imageLiteral(resourceName: "redStatus70")
        case .status75: return #imageLiteral(resourceName: "redStatus75")
        case .status80: return #imageLiteral(resourceName: "redStatus80")
        case .status85: return #imageLiteral(resourceName: "redStatus85")
        case .status90: return #imageLiteral(resourceName: "redStatus90")
        case .status95: return #imageLiteral(resourceName: "redStatus95")
        case .status100: return #imageLiteral(resourceName: "redStatus100")
            
        }
    }
}
