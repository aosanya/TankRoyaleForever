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
    
    func testThink() {
        
        var states = [State]()
        states.append(State(index: 1, value: 1))
        states.append(State(index: 2, value: 2))
        states.append(State(index: 3, value: 3))
        
        var brain = Brain(isMine: true)
        brain.addDecisions(states: States(set: Set(states)), preferredState: 1)
        var testStates = [State]()
        testStates.append(State(index: 1, value: 1))
        var assetStates = States(set: Set(testStates))
        var decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 1)
        
        brain = Brain(isMine: true)
        brain.addDecisions(states: States(set: Set(states)), preferredState: 2)
        testStates = [State]()
        testStates.append(State(index: 2, value: 2))
        assetStates = States(set: Set(testStates))
        decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 2)
        
        brain = Brain(isMine: true)
        brain.addDecisions(states: States(set: Set(states)), preferredState: 3)
        testStates = [State]()
        testStates.append(State(index: 3, value: 3))
        assetStates = States(set: Set(testStates))
        decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 3)
    }
    
    func testThink2() {
        
        var states = [State]()
        states.append(State(index: 1, value: 3))
        states.append(State(index: 2, value: 2))
        states.append(State(index: 3, value: 1))
        
        var brain = Brain(isMine: true)
        brain.addDecisions(states: States(set: Set(states)), preferredState: 1)
        var testStates = [State]()
        testStates.append(State(index: 1, value: 1))
        var assetStates = States(set: Set(testStates))
        var decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 1)
        
        brain = Brain(isMine: true)
        brain.addDecisions(states: States(set: Set(states)), preferredState: 2)
        testStates = [State]()
        testStates.append(State(index: 1, value: 1))
        testStates.append(State(index: 2, value: 2))
        assetStates = States(set: Set(testStates))
        decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 2)
        
        brain = Brain(isMine: true)
        brain.addDecisions(states: States(set: Set(states)), preferredState: 3)
        testStates = [State]()
        testStates.append(State(index: 1, value: 1))
        testStates.append(State(index: 2, value: 2))
        testStates.append(State(index: 3, value: 3))
        assetStates = States(set: Set(testStates))
        decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 3)
    }
    
    func testThinkIntersects() {
        //let brain = Brain(isMine: true)
        
        var states = [State]()
        states.append(State(index: 1, value: 1))
        states.append(State(index: 2, value: 2))
        brain.addDecisions(states: States(set: Set(states)), preferredState: 1)
        
        states = [State]()
        states.append(State(index: 1, value: 3))
        states.append(State(index: 2, value: 4))
        brain.addDecisions(states: States(set: Set(states)), preferredState: 2)

        var testStates = [State]()
        testStates.append(State(index: 1, value: 1))
        var assetStates = States(set: Set(testStates))
        var decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        
        testStates = [State]()
        testStates.append(State(index: 1, value: 1))
        assetStates = States(set: Set(testStates))
        decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 1)
        
        testStates = [State]()
        testStates.append(State(index: 1, value: 4))
        assetStates = States(set: Set(testStates))
        decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 2)
        
        testStates = [State]()
        testStates.append(State(index: 1, value: 1))
        testStates.append(State(index: 2, value: 5))
        assetStates = States(set: Set(testStates))
        decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 1)
        
        testStates = [State]()
        testStates.append(State(index: 1, value: 3))
        testStates.append(State(index: 2, value: 5))
        assetStates = States(set: Set(testStates))
        decision = brain.getDecision(testStates: assetStates)
        XCTAssert(decision != nil)
        XCTAssert(decision == 2)
    }
    
}
