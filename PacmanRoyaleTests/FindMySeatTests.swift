//
//  PacmanRoyaleTests.swift
//  PacmanRoyaleTests
//
//  Created by Anthony on 21/06/2018.
//  Copyright © 2018 CodeVald. All rights reserved.
//

import XCTest
//@testable import PacmanRoyale

class PacmanRoyaleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOrientation() {
        let assetCell = Cell(id: 2, size: CGSize(width: 1, height: 1), row: 1, col: 1)
        assetCell.position = CGPoint(x: 1, y: 1)
        let asset = LivingAsset(id: 1, assetType: AssetType.tank1, cell: assetCell, isMine: true, strength: 1)
        
        var cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 0, col: 0)
        cell.position = CGPoint(x: 0, y: 0)
        var orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == 8388608)
        
        cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 0, col: 1)
        cell.position = CGPoint(x: 0, y: 1)
         orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == 4194304)
        
        cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 0, col: 2)
        cell.position = CGPoint(x: 0, y: 2)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == 536870912)
        
        cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 1, col: 0)
        cell.position = CGPoint(x: 1, y: 0)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == 16777216)
        
        cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 1, col: 2)
        cell.position = CGPoint(x: 1, y: 2)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == 268435456)
        
        cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 2, col: 0)
        cell.position = CGPoint(x: 2, y: 0)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == 33554432)
        
        cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 2, col: 1)
        cell.position = CGPoint(x: 2, y: 1)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == 67108864)
        
        cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 2, col: 2)
        cell.position = CGPoint(x: 2, y: 2)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == 134217728)
    }
    
    
    func testOrientationAssetRotating() {
        let assetCell = Cell(id: 2, size: CGSize(width: 1, height: 1), row: 1, col: 1)
        assetCell.position = CGPoint(x: 1, y: 1)
        let asset = LivingAsset(id: 1, assetType: AssetType.tank1, cell: assetCell, isMine: true, strength: 1)
        
        var cell = Cell(id: 1, size: CGSize(width: 1, height: 1), row: 0, col: 0)
        cell.position = CGPoint(x: 1, y: 2)
        asset.zRotation = angleToRadians(angle: 0)
        var orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is0Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 45)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is315Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 90)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is270Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 135)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is225Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 180)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is180Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 225)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is135Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 270)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is90Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 315)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is45Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: -45)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is45Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: -405)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is45Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 360)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is0Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 405)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is315Degrees.mask())
        
        asset.zRotation = angleToRadians(angle: 450)
        orientation = cell.relativeOrientation(requestingAsset: asset)
        assert(orientation == StateTypes.is270Degrees.mask())
    }
    
    
    func testOrientationAt90() {
        let assetCell = Cell(id: 2, size: CGSize(width: 50, height: 50), row: 1, col: 1)
        assetCell.position = CGPoint(x: 1, y: 1)
        let asset = LivingAsset(id: 1, assetType: AssetType.tank1, cell: assetCell, isMine: true, strength: 1)
        asset.zRotation = angleToRadians(angle: radiansToAngle(asset.zRotation) + 90)
        
        var cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 0, col: 0)
        cell.position = CGPoint(x: 0, y: 0)
        var orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 8388608)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 0, col: 1)
        cell.position = CGPoint(x: 0, y: 1)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 4194304)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 0, col: 2)
        cell.position = CGPoint(x: 0, y: 2)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 536870912)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 1, col: 0)
        cell.position = CGPoint(x: 1, y: 0)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 16777216)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 1, col: 2)
        cell.position = CGPoint(x: 1, y: 2)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 268435456)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 2, col: 0)
        cell.position = CGPoint(x: 2, y: 0)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 33554432)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 2, col: 1)
        cell.position = CGPoint(x: 2, y: 1)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 67108864)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 2, col: 2)
        cell.position = CGPoint(x: 2, y: 2)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 134217728)
    }
    
    func testOrientationAt180() {
        let assetCell = Cell(id: 2, size: CGSize(width: 50, height: 50), row: 1, col: 1)
        assetCell.position = CGPoint(x: 1, y: 1)
        let asset = LivingAsset(id: 1, assetType: AssetType.tank1, cell: assetCell, isMine: true, strength: 1)
        asset.zRotation = angleToRadians(angle: radiansToAngle(asset.zRotation) + 180)
        
        var cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 0, col: 0)
        cell.position = CGPoint(x: 0, y: 0)
        var orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 8388608)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 0, col: 1)
        cell.position = CGPoint(x: 0, y: 1)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 4194304)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 0, col: 2)
        cell.position = CGPoint(x: 0, y: 2)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 536870912)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 1, col: 0)
        cell.position = CGPoint(x: 1, y: 0)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 16777216)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 1, col: 2)
        cell.position = CGPoint(x: 1, y: 2)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 268435456)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 2, col: 0)
        cell.position = CGPoint(x: 2, y: 0)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 33554432)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 2, col: 1)
        cell.position = CGPoint(x: 2, y: 1)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 67108864)
        
        cell = Cell(id: 1, size: CGSize(width: 50, height: 50), row: 2, col: 2)
        cell.position = CGPoint(x: 2, y: 2)
        orientation = cell.staticOrientation(requestingAsset: asset)
        assert(orientation == 134217728)
    }
    
    func GetTestLivingAsset(id : UInt, isMine : Bool, cell : Cell, assetType : AssetType, level : Double, strength : Int) -> LivingAsset{
        let asset = LivingAsset(id: id, assetType: assetType, cell: cell, isMine: isMine, strength: strength)
        asset.brain = Brain(isMine: isMine, assetType: asset.assetType.rawValue, level: level)
        return asset
    }
    
    func testDecisionStates(){
        cells = Cells(area: CGRect(x: 0, y: 0, width: 150, height: 150), rows: 3, cols: 3, delegate: nil)
        
        var id : Int = 0
        for row in 0...2{
            for col in 0...2{
                let cell = Cell(id: id, size: CGSize(width: 50, height: 50), row: row, col: col)
                cell.position = CGPoint(x: row, y: col)
                cells.set.append(cell)
                id += 1
            }
        }
        
        let assetCell = cells.getCell(row : 1, col : 1)
        let asset2Cell = cells.getCell(row : 2, col : 1)
        
        assert(assetCell!.pos == CellPos(row: 1, col: 1))
        assert(asset2Cell!.pos == CellPos(row: 2, col: 1))
        
        let asset = GetTestLivingAsset(id: 1, isMine: true, cell: assetCell!, assetType: AssetType.tank1, level: 1, strength: 1)
        assert(asset.cell.pos == CellPos(row: 1, col: 1))
        
        let asset2 = GetTestLivingAsset(id: 2, isMine: false, cell: asset2Cell!, assetType: AssetType.tank1, level: 1, strength: 1)
        assert(asset2.cell.pos == CellPos(row: 2, col: 1))
        
        let cellsWithAssets = cells.set.filter({m in m.asset != nil})
        assert(cellsWithAssets.count == 2)
        
        let prefferedState = asset2Cell!.relativeState(requestingAsset: asset, radius: 1)
        asset.brain.addDecisions(states: asset.relativeState(radius: 1, includingSelf: false), preferredState: prefferedState)
        var decision = asset.brain.getDecision(testStates: asset.relativeState(radius: 1, includingSelf: false))
        var proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.id == asset2Cell!.id)
        
        asset.zRotation = angleToRadians(angle: radiansToAngle(asset.zRotation) + 90)
        decision = asset.brain.getDecision(testStates: asset.relativeState(radius: 1, includingSelf: false))
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.id == asset2Cell!.id)
        
        asset.zRotation = angleToRadians(angle: radiansToAngle(asset.zRotation) + 90)
        decision = asset.brain.getDecision(testStates: asset.relativeState(radius: 1, includingSelf: false))
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.id == asset2Cell!.id)
        
        asset.zRotation = angleToRadians(angle: radiansToAngle(asset.zRotation) + 90)
        decision = asset.brain.getDecision(testStates: asset.relativeState(radius: 1, includingSelf: false))
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.id == asset2Cell!.id)
        
    }
    func testFrontCell(){
        cells = Cells(area: CGRect(x: 0, y: 0, width: 150, height: 150), rows: 3, cols: 3, delegate: nil)
        
        var id : Int = 0
        for row in 0...2{
            for col in 0...2{
                let cell = Cell(id: id, size: CGSize(width: 50, height: 50), row: row, col: col)
                cell.position = CGPoint(x: row, y: col)
                cells.set.append(cell)
                id += 1
            }
        }
        
        let assetCell = cells.getCell(row : 1, col : 1)
        
        let asset = LivingAsset(id: 1, assetType: AssetType.tank1, cell: assetCell!, isMine: true, strength: 1)
        asset.zRotation = angleToRadians(angle: 270)
        var frontCell = asset.frontCell()
        assert(frontCell!.pos.row == 1)
        assert(frontCell!.pos.col == 2)
 
        asset.zRotation = angleToRadians(angle: 45)
        frontCell = asset.frontCell()
        assert(frontCell!.pos.row == 2)
        assert(frontCell!.pos.col == 0)
        
        asset.zRotation = angleToRadians(angle: 90)
        frontCell = asset.frontCell()
        assert(frontCell!.pos.row == 1)
        assert(frontCell!.pos.col == 0)
        
        asset.zRotation = angleToRadians(angle: 135)
        frontCell = asset.frontCell()
        assert(frontCell!.pos.row == 0)
        assert(frontCell!.pos.col == 0)
        
        asset.zRotation = angleToRadians(angle: 180)
        frontCell = asset.frontCell()
        assert(frontCell!.pos.row == 0)
        assert(frontCell!.pos.col == 1)
        
        asset.zRotation = angleToRadians(angle: 225)
        frontCell = asset.frontCell()
        assert(frontCell!.pos.row == 0)
        assert(frontCell!.pos.col == 2)
        
        asset.zRotation = angleToRadians(angle: 315)
        frontCell = asset.frontCell()
        assert(frontCell!.pos.row == 2)
        assert(frontCell!.pos.col == 2)
        
        asset.zRotation = angleToRadians(angle: 360)
        frontCell = asset.frontCell()
        assert(frontCell!.pos.row == 2)
        assert(frontCell!.pos.col == 1)
    }
    
//    func testRotatational(){
//        cells = Cells(area: CGRect(x: 0, y: 0, width: 150, height: 150), rows: 3, cols: 3, delegate: nil)
//
//        var id : Int = 0
//        for row in 0...2{
//            for col in 0...2{
//                let cell = Cell(id: id, size: CGSize(width: 50, height: 50), row: row, col: col)
//                cell.position = CGPoint(x: row, y: col)
//                cells.set.append(cell)
//                id += 1
//            }
//        }
//
//        let assetCell = cells.getCell(row : 1, col : 1)
//        let asset2Cell = cells.getCell(row : 2, col : 1)
//
//        let asset = GetTestLivingAsset(id: 1, isMine: true, cell: assetCell!, assetType: AssetType.tank1, level: 1, strength: 1)
//        asset.zRotation = angleToRadians(angle: 270)
//        let asset2 = GetTestLivingAsset(id: 2, isMine: false, cell: asset2Cell!, assetType: AssetType.tank1, level: 1, strength: 1)
//        asset2.zRotation = angleToRadians(angle: 90)
//
//        let prefferedState = asset2Cell!.relativeState(requestingAsset: asset, radius: 1)
//        asset.brain.addDecisions(states: asset.relativeState(radius: 1, includingSelf: false), preferredState: prefferedState)
//        asset2.brain = asset.brain
//
//
//        let decision = asset.brain.getDecision(testStates: asset.relativeState(radius: 1, includingSelf: false))
//        let proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
//        assert(proposedCell.id == asset2Cell!.id)
//
//        let oppositeDecision = asset2.brain.getDecision(testStates: asset2.relativeState(radius: 1, includingSelf: false))
//        let oppositeProposedCell2 = cells.adjacentCell(cell: asset2Cell!, state: oppositeDecision!).first!
//        assert(oppositeProposedCell2.id == assetCell!.id)
//
//
//        asset.zRotation = angleToRadians(angle: 360)
//
//
//    }
    
    
    
    func testRotatational(){
        cells = Cells(area: CGRect(x: 0, y: 0, width: 3, height: 3), rows: 3, cols: 3, delegate: nil)
        
        var id : Int = 0
        for row in 0...2{
            for col in 0...2{
                let cell = Cell(id: id, size: CGSize(width: 1, height: 1), row: row, col: col)
                cells.set.append(cell)
                id += 1
            }
        }
        
        let assetCell = cells.getCell(row : 1, col : 1)
        
        
        let asset = GetTestLivingAsset(id: 1, isMine: true, cell: assetCell!, assetType: AssetType.tank1, level: 1, strength: 1)
        asset.zRotation = angleToRadians(angle: 0)
        let frontCell = asset.frontCell()
        
        let prefferedState = frontCell!.relativeState(requestingAsset: asset, radius: 1)
        asset.brain.addDecisions(states: asset.relativeState(radius: 1, includingSelf: false), preferredState: prefferedState)
        
        let decision = asset.brain.getDecision(testStates: asset.relativeState(radius: 1, includingSelf: false))
        var proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.pos == CellPos(row: 2, col: 1))
        
        asset.zRotation = angleToRadians(angle: 45)
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.pos == asset.frontCell()!.pos)
        assert(proposedCell.pos == CellPos(row: 2, col: 0))
        
        asset.zRotation = angleToRadians(angle: 90)
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.pos == asset.frontCell()!.pos)
        assert(proposedCell.pos == CellPos(row: 1, col: 0))
      
        asset.zRotation = angleToRadians(angle: 135)
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.pos == asset.frontCell()!.pos)
        assert(proposedCell.pos == CellPos(row: 0, col: 0))

        asset.zRotation = angleToRadians(angle: 180)
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.pos == asset.frontCell()!.pos)
        assert(proposedCell.pos == CellPos(row: 0, col: 1))

        asset.zRotation = angleToRadians(angle: 225)
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.pos == asset.frontCell()!.pos)
        assert(proposedCell.pos == CellPos(row: 0, col: 2))

       asset.zRotation = angleToRadians(angle: 315)
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.pos == asset.frontCell()!.pos)
        assert(proposedCell.pos == CellPos(row: 2, col: 2))

       asset.zRotation = angleToRadians(angle: 360)
        proposedCell = cells.adjacentCell(cell: assetCell!, state: decision!).first!
        assert(proposedCell.pos == asset.frontCell()!.pos)
        assert(proposedCell.pos == CellPos(row: 2, col: 1))
    }
    
//    func testThink() {
//
//        var states = [State]()
//        states.append(State(index: 1, value: 1))
//        states.append(State(index: 2, value: 2))
//        states.append(State(index: 3, value: 3))
//
//        var brain = Brain(isMine: true)
//        brain.addDecisions(states: States(set: Set(states)), preferredState: 1)
//        var testStates = [State]()
//        testStates.append(State(index: 1, value: 1))
//        var assetStates = States(set: Set(testStates))
//        var decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 1)
//
//        brain = Brain(isMine: true)
//        brain.addDecisions(states: States(set: Set(states)), preferredState: 2)
//        testStates = [State]()
//        testStates.append(State(index: 2, value: 2))
//        assetStates = States(set: Set(testStates))
//        decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 2)
//
//        brain = Brain(isMine: true)
//        brain.addDecisions(states: States(set: Set(states)), preferredState: 3)
//        testStates = [State]()
//        testStates.append(State(index: 3, value: 3))
//        assetStates = States(set: Set(testStates))
//        decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 3)
//    }
//
//    func testThink2() {
//
//        var states = [State]()
//        states.append(State(index: 1, value: 3))
//        states.append(State(index: 2, value: 2))
//        states.append(State(index: 3, value: 1))
//
//        var brain = Brain(isMine: true)
//        brain.addDecisions(states: States(set: Set(states)), preferredState: 1)
//        var testStates = [State]()
//        testStates.append(State(index: 1, value: 1))
//        var assetStates = States(set: Set(testStates))
//        var decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 1)
//
//        brain = Brain(isMine: true)
//        brain.addDecisions(states: States(set: Set(states)), preferredState: 2)
//        testStates = [State]()
//        testStates.append(State(index: 1, value: 1))
//        testStates.append(State(index: 2, value: 2))
//        assetStates = States(set: Set(testStates))
//        decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 2)
//
//        brain = Brain(isMine: true)
//        brain.addDecisions(states: States(set: Set(states)), preferredState: 3)
//        testStates = [State]()
//        testStates.append(State(index: 1, value: 1))
//        testStates.append(State(index: 2, value: 2))
//        testStates.append(State(index: 3, value: 3))
//        assetStates = States(set: Set(testStates))
//        decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 3)
//    }
//
//    func testThinkIntersects() {
//        //let brain = Brain(isMine: true)
//
//        var states = [State]()
//        states.append(State(index: 1, value: 1))
//        states.append(State(index: 2, value: 2))
//        brain.addDecisions(states: States(set: Set(states)), preferredState: 1)
//
//        states = [State]()
//        states.append(State(index: 1, value: 3))
//        states.append(State(index: 2, value: 4))
//        brain.addDecisions(states: States(set: Set(states)), preferredState: 2)
//
//        var testStates = [State]()
//        testStates.append(State(index: 1, value: 1))
//        var assetStates = States(set: Set(testStates))
//        var decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//
//        testStates = [State]()
//        testStates.append(State(index: 1, value: 1))
//        assetStates = States(set: Set(testStates))
//        decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 1)
//
//        testStates = [State]()
//        testStates.append(State(index: 1, value: 4))
//        assetStates = States(set: Set(testStates))
//        decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 2)
//
//        testStates = [State]()
//        testStates.append(State(index: 1, value: 1))
//        testStates.append(State(index: 2, value: 5))
//        assetStates = States(set: Set(testStates))
//        decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 1)
//
//        testStates = [State]()
//        testStates.append(State(index: 1, value: 3))
//        testStates.append(State(index: 2, value: 5))
//        assetStates = States(set: Set(testStates))
//        decision = brain.getDecision(testStates: assetStates)
//        XCTAssert(decision != nil)
//        XCTAssert(decision == 2)
//    }
    
}
