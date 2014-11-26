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
  func testDidAddToNode() {
    self.node?.addComponent(self.component)
    XCTAssertTrue(self.component.assertionDidAddToNode)
  }
  func testDidAddNodeToScene() {
    self.node?.addComponent(self.component)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }
  func testDidRemoveFromNode() {
    self.node?.addComponent(self.component)
    let didRemove = self.component.removeFromNode()
    XCTAssertTrue(didRemove)
    XCTAssertTrue(self.component.assertionDidRemoveFromNode)

  }
  func testDidRemoveNodeFromScene() {
    XCTAssertTrue(self.component.assertionDidRemoveFromNode)    
  }
  func testDidChangeSceneSizedFrom() {
    
  }
  func testDidMoveToView() {
    
  }
  func testWillMoveFromView() {
    
  }
  func testDidUpdate() {
    
  }
  func testDidEvaluateActions() {
    
  }
  func testDidSimulatePhysics() {
    
  }
  func testDidApplyConstraints() {
    
  }
  func testDidFinishUpdate() {
    
  }
  func testDidBeginContactWithNode() {
      
  }
  func testDidEndContactWithNode() {
    
  }
  func testBeginContact() {
    
  }
  func testDidEndContact() {
    
  }

}
