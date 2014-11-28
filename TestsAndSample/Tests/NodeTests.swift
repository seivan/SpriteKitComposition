//
//  NodeTests.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 26/11/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import UIKit
import XCTest
import SpriteKit
class NodeTests: SpriteKitTestCase {
  
  override func setUp() {
    super.setUp()

  }

  func testComponents() {
    var components = [Component]()
    for i in 0..<5 {
      let component = Component()
      self.node?.addComponent(component, withKey: String(i))
      components.append(component)
    }
    
    XCTAssertEqual(self.node!.components.count, components.count)

    for component in components {
      XCTAssertTrue(contains(self.node!.components, component))
    }
    
  }
  
  
  func testchildNodes() {
    for i in 0..<5 { self.node!.addChild(SKNode()) }
    XCTAssertEqual(self.node!.childNodes.count, self.node!.children.count)
    XCTAssertEqual(self.node!.childNodes, self.node!.children as [SKNode])
  }
  
  func testComponentWithClass() {
    
  }
  
  func testComponentWithKey() {
    
  }
  
  func testAddComponentWithKey() {
    
  }
  
  func testAddComponent() {
    
  }
  
  func testRemoveComponentWithClass() {
    
  }
  
  func testRemoveComponentWithKey() {
    
  }
  
  func testRemoveComponent() {
    
  }

}
