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
  
  func testComponents() {
    let node = SKNode()
    var components = [Component]()
    for i in 0..<5 {
      let component = Component()
      node.addComponent(component)
      components.append(component)
    }
    XCTAssertEqual(node.components.count, components.count)
  }
  
  func testchildNodes() {
    let node = SKNode()
    for i in 0..<5 { node.addChild(SKNode()) }
    XCTAssertEqual(node.childNodes.count, node.children.count)
    
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
