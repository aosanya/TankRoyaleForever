//
//  Cells.swift
//  PacmanRoyale
//
//  Created by Anthony on 23/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import SpriteKit

protocol CellsDelegate{
    func cellCreated(thisCell : Cell)
    func createAsset(cell : Cell, isMine : Bool)
    func assetCreationComplete(cell : Cell, isMine : Bool)
    func canCreateAsset(isMine : Bool)
}



class Cells : CellDelegate, GameSceneDelegate{

    

    


    var set : [Cell]! = [Cell]()
    var area : CGRect
    var rows : Int
    var cols : Int
    var delegates = [CellsDelegate]()
    var cellWidth : CGFloat
    var cellHeight : CGFloat
    let maxWidth : CGFloat = 150
    let maxHeight : CGFloat = 150
    var abundance : Resources = Resources()
    

    
    init(area : CGRect, rows : Int, cols : Int, delegate : CellsDelegate?){
        self.area = area
        self.rows = rows
        self.cols = cols
        self.cellWidth = self.area.width / CGFloat(self.cols)
        self.cellHeight = self.area.height / CGFloat(self.rows)
        
        if self.cellWidth  > maxWidth {
            self.cellWidth = maxWidth
        }
        
        if self.cellHeight  > maxHeight {
            self.cellHeight = maxHeight
        }
        
        if delegate != nil{
            self.delegates.append(delegate!)
        }
        
        self.createCells()        
    }
    
    
    private func actualWidth() -> CGFloat{
        return CGFloat(self.cols) * cellWidth
    }
    
    private func actualHeight() -> CGFloat{
        return CGFloat(self.rows) * cellHeight
    }
    
    private func createCells(){
        var leftStart : CGFloat = 0
        var topStart : CGFloat = 0
        
        for i in 0...self.rows - 1{
            if i == 0 {
                topStart = self.actualHeight() * -0.5 + (actualCellHeight(row: 0) * 0.5)
            }
            else{
                topStart = topStart + actualCellHeight(row: i - 1)/2 + actualCellHeight(row: i)/2
            }
            
            for j in 0...self.cols - 1{
                if j == 0 {
                     leftStart = self.actualWidth() * -0.5  + (actualCellWidth(col: 0) * 0.5)
                }
                else{
                     leftStart = leftStart + actualCellWidth(col: j)
                }
                let size = cellSize(row: i, col: j)
               
                self.addCell(row: i, col: j, size: size, pos: CGPoint(x: leftStart , y: topStart))
            }
        }
    }
    
    func createAsset(cell: Cell, isMine: Bool) {
        for each in self.delegates{
            each.createAsset(cell: cell, isMine: isMine)
        }
    }
    
    func assetCreationComplete(cell: Cell, isMine: Bool) {
        for each in self.delegates{
            each.assetCreationComplete(cell: cell, isMine: isMine)
        }
    }
    
    private func randomEmptyCell() -> Cell?{
        var candidates = self.set.filter({m in m.isEmpty() && m.isCreatingAsset == false && m.isRedHomeCell == false && m.isGreenHomeCell == false})
        
        guard candidates.count > 0 else {
            return nil
        }
        
        candidates = candidates.filter({m in m.contactingAssets.count == 0})
        
        guard candidates.count > 0 else {
            return nil
        }
        
        let candidate = candidates[randint(0, upperLimit: candidates.count - 1)]
        
        return candidate
    }
    
    func randomEmptyCell(row : Int) -> Cell?{
        var candidates = self.set.filter({m in m.pos.row == row && m.isEmpty() && m.isCreatingAsset == false})
        
        guard candidates.count > 0 else {
            return nil
        }
        
        candidates = candidates.filter({m in m.contactingAssets.count == 0})
        
        guard candidates.count > 0 else {
            return nil
        }
        
        let candidate = candidates[randint(0, upperLimit: candidates.count - 1)]
        
        return candidate
    }
    
    
    
    func addRandomObject(){
        if let emptyCell = self.randomEmptyCell(){
            if let resource = abundance.pop(){
                emptyCell.addObject(type: resource.type)
            }
        }
    }
    
    func setRedHomeCells(row : Int){
        let cells = self.getRowCells(row: row)
        for each in cells{
            each.isRedHomeCell = true
        }
    }
    
    func setGreenHomeCells(row : Int){
        let cells = self.getRowCells(row: row)
        for each in cells{
            each.isGreenHomeCell = true
        }
    }
    
    private func actualCellHeight(row : Int) -> CGFloat{
//        if row % 2 == 0{
//            return cellHeight * 0.7
//        }
//        let diff = cellHeight - cellHeight * 0.7
//
//        return cellHeight + diff
        return cellHeight
    }
    
    private func actualCellWidth( col : Int) -> CGFloat{
        return cellWidth
    }
    
    private func cellSize(row : Int, col : Int) -> CGSize{
        return CGSize(width: actualCellWidth(col: col), height: actualCellHeight(row: row))
    }
    
    private func addCell(row : Int, col : Int, size : CGSize, pos : CGPoint){
        let cell = Cell(id : self.set.count + 1, size: size,row: row, col: col)
        cell.delegate = self
        cell.position = pos
        
        
        self.set.append(cell)
        
        for each in self.delegates{
            each.cellCreated(thisCell: cell)
        }
    }
    
    func getCell(id : Int) -> Cell?{
        return self.set.filter({m in m.id == id}).first
    }
    
    func getColCells(col : Int) -> [Cell]{
        return self.set.filter({m in m.pos.col == col})
    }
    
    func getRowCells(row : Int) -> [Cell]{
        return self.set.filter({m in m.pos.row == row})
    }
    
    func relativeCell(cell : Cell, row : Int, col : Int) -> Cell?{
        return self.set.filter({m in m.pos.row == cell.pos.row + row && m.pos.col == cell.pos.col + col}).first
    }
    
    func adjacentCell(cell : Cell, state : UInt) -> [Cell]{
        guard cell.asset != nil else {
            return [Cell]()
        }
        return self.radialCells(cell: cell, radius: 1, includingSelf: false).filter({m in m.state(requestingAsset: cell.asset!) == state})
    }
    
    func relativeCell(cell : Cell, radAngle : CGFloat) -> Cell?{
        let row = Double(cos(radAngle)).rounded()
        let col = Double(sin(radAngle)).rounded()
        
        return relativeCell(cell: cell, row: Int(row), col: Int(col))
    }
    
    func radialCells(cell : Cell, radius : Int, includingSelf : Bool) -> [Cell]{
        guard radius > 0 else {
             return [cell]
        }
        
        let results = self.set.filter({m in m.pos.row >= cell.pos.row - radius && m.pos.row <= cell.pos.row + radius
            && m.pos.col >= cell.pos.col - radius && m.pos.col <= cell.pos.col + radius})
        
        guard includingSelf == false else {
            return results
        }
        
        return results.filter({m in m.id != cell.id})
    }
    
    func radialCellsState(asset : Asset, cell : Cell, radius : Int, includingSelf : Bool) -> States{
        
        let rCells = self.radialCells(cell: cell, radius: radius, includingSelf: false)
        let states = rCells.sorted(by: {$0.pos.row < $1.pos.row  && $0.pos.col < $1.pos.col}).enumerated().map{($0, $1.state(requestingAsset: asset))}
        
        return States(set: Set(states.map({m in State(index: m.0, value: m.1)})))
    }
    
    func objectChanged(cell: Cell) {
        let myRadialCells = self.radialCells(cell: cell, radius: 1, includingSelf: true)
        for each in myRadialCells{
            each.neighboringObjectChanged(cell: cell)
        }
    }
    
    func isCreatingAsset(isMine : Bool) -> Bool{
        if isMine{
            return self.set.filter({m in m.isCreatingAsset == true && m.isGreenHomeCell == true}).count > 0
        }
        else{
            return self.set.filter({m in m.isCreatingAsset == true && m.isRedHomeCell == true}).count > 0
        }
    }
    
    func canCreateAsset(isMine : Bool) -> Bool{
        if isMine{
            return self.set.filter({m in (m.isCreatingAsset == true && m.isReadyToCreatAsset == false) && m.isGreenHomeCell == true}).count == 0
        }
        else{
            return self.set.filter({m in (m.isCreatingAsset == true && m.isReadyToCreatAsset == false) == true && m.isRedHomeCell == true}).count == 0
        }
    }
    
    func assetChanged(cell: Cell) {
        let myRadialCells = self.radialCells(cell: cell, radius: 1, includingSelf: true)
        for each in myRadialCells{
            each.neighboringAssetChanged(cell: cell)
        }
        
        if cell.canCreateAsset(){
            for each in self.delegates{
                if cell.isGreenHomeCell {
                    each.canCreateAsset(isMine: true)
                }
                else if cell.isRedHomeCell {
                    each.canCreateAsset(isMine: false)
                }
            }
        }
    }
    
    func gameOver(Iwin : Bool) {
        var sortedCellls : [Cell]
        if Iwin == true{
            sortedCellls = self.set.sorted(by: {$0.id < $1.id})
        }
        else{
            sortedCellls = self.set.sorted(by: {$0.id > $1.id})
        }
        
        var currVal : Float = 1
        for each in sortedCellls{
            let duration = convertRange(1, fromMax: Float(sortedCellls.count), toMin: 0.5, toMax: 1.5, convertVal: currVal)
            if each.object != nil{
                each.object!.fadeOut(duration: Double(duration / 2))
            }
            each.fadeOut(duration: Double(duration))
            currVal += 1
        }
    }
    
    func gameStart() {
        
    }
}
