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
  let component = SampleComponent()
  
  override func setUp() {
    super.setUp()
    self.scene?.addComponent(self.component)
  }
  func testDidAddToNode() {
    XCTAssertTrue(self.component.assertionDidAddToNode)
    self.scene?.removeComponent(self.component);
  }
  func testDidAddNodeToScene() {
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }
  func testDidRemoveFromNode() {
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
