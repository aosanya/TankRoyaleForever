//
//  global.swift
//  PacmanRoyale
//
//  Created by Anthony on 23/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import UIKit

func randint(_ lowerLimit : Int, upperLimit : Int) -> Int{
    var negative = 0
    var lowerLimit  = lowerLimit
    var upperLimit = upperLimit
    
    if lowerLimit < 0{
        negative = lowerLimit
        lowerLimit = 0
        upperLimit = upperLimit - negative
    }
    
    return Int(arc4random_uniform(UInt32(upperLimit - lowerLimit)) + UInt32(lowerLimit)) - negative
}

func getDistanceWithDelta(_ dx : Int, dy : Int) -> Double{
    return sqrt(pow(Double(dx), 2) + pow(Double(dy), 2))
}

func getCellDistance(_ posA : CellPos, posB : CellPos) -> Double{
    let deltaRow = Double(posA.row - posB.row)
    let deltaCol = Double(posA.col - posB.col)
    return sqrt(pow(deltaRow, 2) + pow(deltaCol, 2))
}

func angleToRadians(angle : CGFloat) -> CGFloat{
   return (angle * CGFloat(Double.pi)) / CGFloat(180)
}

func radiansToAngle(_ radians : CGFloat) -> CGFloat{
    return (radians * CGFloat(180)) / CGFloat(Double.pi)
}

func getDistance(_ pointA : CGPoint, pointB : CGPoint) -> CGFloat{
    let deltaY = pointA.y - pointB.y
    let deltaX = pointA.x - pointB.x
    return sqrt(pow(deltaX, 2) + pow(deltaY, 2))
}

func getRadAngle(_ pointA : CGPoint, pointB : CGPoint) -> Float{
    let deltaY = Float(pointA.y - pointB.y)
    let deltaX = Float(pointA.x - pointB.x)
    return atan2f(deltaY,deltaX)
}


func convertRange(_ fromMin : Float, fromMax : Float, toMin : Float, toMax : Float, convertVal : Float) -> Float{
    var convertVal = convertVal
    convertVal = Float( Int(convertVal))
    let range1 = fromMax - fromMin
    let range2 = toMax - toMin
    
    if range1 == 0{
        return toMin
    }
    let fracOn1 = (convertVal - fromMin)/range1
    let dev = fracOn1 * range2
    var newVal = dev + toMin
    
    if toMin < toMax{
        if newVal > toMax{
            newVal = toMax
        }
        if newVal < toMin{
            newVal = toMin
        }
    }
    if toMin > toMax{
        if newVal > toMin{
            newVal = toMin
        }
        if newVal < toMax{
            newVal = toMax
        }
    }
    
    return newVal
}

