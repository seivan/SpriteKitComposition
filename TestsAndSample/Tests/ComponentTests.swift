//
//  ComponentTests.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 26/11/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import UIKit
import XCTest
import SpriteKit

class ComponentTests: SpriteKitTestCase {
  var component = SampleComponent()
  
  override func setUp() {
    super.setUp()
    var component = SampleComponent()
  }
  
  func testDidAddToNodeWithScene() {
    self.node?.addComponent(self.component)
    XCTAssertTrue(self.component.assertionDidAddToNode)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }
  
  func testDidAddToNodeWithoutScene() {
    self.node?.removeFromParent()
    self.node?.addComponent(self.component)
    XCTAssertTrue(self.component.assertionDidAddToNode)
    XCTAssertFalse(self.component.assertionDidAddNodeToScene)
    self.scene?.addChild(self.node!)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }

  func testDidAddNodeToSceneBefore() {
    self.node?.addComponent(self.component)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }
  
  func testDidAddNodeToSceneAfter() {
    self.node?.removeFromParent()
    self.node?.addComponent(self.component)
    XCTAssertFalse(self.component.assertionDidAddNodeToScene)
    self.scene?.addChild(self.node!)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }

  func testDidRemoveFromNode() {
    self.node?.addComponent(self.component)
    let didRemove = self.component.removeFromNode()
    XCTAssertTrue(didRemove)
    XCTAssertTrue(self.component.assertionDidRemoveFromNode)
  }
  
  func testDidRemoveNodeFromScene() {
    self.node?.addComponent(self.component)
    self.node?.removeFromParent()
    XCTAssertTrue(self.component.assertionDidRemoveNodeFromScene)
  }
  
  func testDidChangeSceneSizedFromWithScene() {
    self.node?.addComponent(self.component)
    let oldSize = self.scene?.size
    let size = CGSize(width: 300, height: 300)
    self.scene?.size = size
    XCTAssertNotEqual(self.component.assertionDidChangeSceneSizedFrom!, size)
    XCTAssertEqual(self.component.assertionDidChangeSceneSizedFrom!, oldSize!)
    
  }
  
  func testDidChangeSceneSizedFromWithoutScene() {
    self.node?.removeFromParent()
    self.node?.addComponent(self.component)
    let oldSize = self.scene?.size
    let size = CGSize(width: 300, height: 300)
    self.scene?.size = size
    XCTAssertFalse(self.component.assertionDidChangeSceneSizedFrom  == size)
    XCTAssertFalse(self.component.assertionDidChangeSceneSizedFrom  == oldSize!)
    XCTAssertTrue(self.component.assertionDidChangeSceneSizedFrom   == nil)
    
  }

  func testDidMoveToView() {
    self.node?.addComponent(self.component)
    let scene = self.node?.scene
    let oldView = self.scene?.view!
    let newView = SKView(frame: oldView!.frame)
    (self.controller?.view as SKView).presentScene(SKScene())
    self.controller?.view = newView
    (self.controller?.view as SKView).presentScene(scene)
    XCTAssertEqual(self.component.assertionWillMoveFromView!, oldView!)
    XCTAssertEqual(self.component.assertionDidMoveToView!, newView)
  }
  
  func testWillMoveFromView() {
    self.node?.addComponent(self.component)
    let scene = self.node?.scene
    let oldView = self.scene?.view!
    let newView = SKView(frame: oldView!.frame)
    (self.controller?.view as SKView).presentScene(scene)
    XCTAssertEqual(self.component.assertionWillMoveFromView!, oldView!)
    XCTAssertEqual(self.component.assertionDidMoveToView!, oldView!)
    
  }
  
  func testDidUpdate() {
    self.node?.addComponent(self.component)
    
    var expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.1, nil)
    XCTAssertLessThanOrEqual(self.component.assertionDidUpdate!, 1.0)
    XCTAssertGreaterThan(self.component.assertionDidUpdate!, 0)
    
    self.component.isEnabled = false
    self.component.assertionDidUpdate = 0
    expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.1, nil)
    XCTAssertEqual(self.component.assertionDidUpdate!, 0)


  }
  
  func testDidEvaluateActions() {
    self.node?.addComponent(self.component)
    
    var expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.2, nil)
    XCTAssertTrue(self.component.assertionDidEvaluateActions)

    
    self.component.isEnabled = false
    self.component.assertionDidEvaluateActions = false
    expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.2, nil)
    XCTAssertFalse(self.component.assertionDidEvaluateActions)
    
  }
  
  func testDidSimulatePhysics() {
    self.node?.addComponent(self.component)
    
    var expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.2, nil)
    XCTAssertTrue(self.component.assertionDidSimulatePhysics)
    
    
    self.component.isEnabled = false
    self.component.assertionDidSimulatePhysics = false
    expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.2, nil)
    XCTAssertFalse(self.component.assertionDidSimulatePhysics)
  
  }
  
  func testDidApplyConstraints() {
    self.node?.addComponent(self.component)
    
    var expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.2, nil)
    XCTAssertTrue(self.component.assertionDidApplyConstraints)
    
    
    self.component.isEnabled = false
    self.component.assertionDidApplyConstraints = false
    expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.2, nil)
    XCTAssertFalse(self.component.assertionDidApplyConstraints)
    
  }
  
  func testDidFinishUpdate() {
    self.node?.addComponent(self.component)
    
    var expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.2, nil)
    XCTAssertTrue(self.component.assertionDidFinishUpdate)
    
    
    self.component.isEnabled = false
    self.component.assertionDidFinishUpdate = false
    expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(0.2, nil)
    XCTAssertFalse(self.component.assertionDidFinishUpdate)
    
  }
  
  func testDidBeginContactWithNodeEnabled() {
    var expectation = self.expectationWithDescription(__FUNCTION__)
    self.scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.node?.addComponent(self.component)
    let otherNode = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 50, height: 50))
    self.scene?.addChild(otherNode)
    
    for node in [otherNode, self.node!] {
      node.position = CGPoint(x: 100, y: 100)
      node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 40, height: 40))
      node.physicsBody?.dynamic = true
      node.physicsBody?.pinned = false
    }
    
    self.node?.physicsBody?.categoryBitMask = 2
    otherNode.physicsBody?.categoryBitMask = 1
    self.node?.physicsBody?.contactTestBitMask = 1
    otherNode.physicsBody?.contactTestBitMask = 2
    
    self.node?.position = CGPoint(x: 20, y: 20)
    self.node?.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))

    
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(10, nil)

    


    
  }
  
  func testDidEndContactWithNode() {
    
  }
  
  func testBeginContact() {
    
  }
  
  func testDidEndContact() {
    
  }

}
