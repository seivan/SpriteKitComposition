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
    var components = [Component]()
    for i in 0..<5 {
      let component = Component()
      self.node?.addComponent(component, withKey: String(i))
      components.append(component)
    }
    
    XCTAssertEqual(self.node.components.count, components.count)
    for component in components { XCTAssertTrue(contains(self.node.components, component)) }
    
  }
  
  
  func testchildNodes() {
    for i in 0..<5 { self.node.addChild(SKNode()) }
    XCTAssertEqual(self.node.childNodes.count, self.node.children.count)
    XCTAssertEqual(self.node.childNodes, self.node.children as [SKNode])
  }
  
  func testComponentWithClass() {
    
    let component = Component()

    self.node.addComponent(component)
    let dynamictype = self.node.componentWithClass(component.dynamicType)
    let classSelf = self.node.componentWithClass(Component.self)

    XCTAssertEqual(component, dynamictype!)
    XCTAssertEqual(component, classSelf!)
    
    
  }
  
  func testComponentWithKey() {
    var components = [Component]()
    for i in 0..<5 {
      let component = Component()
      self.node?.addComponent(component, withKey: String(i))
      components.append(component)
    }
    
    XCTAssertEqual(self.node.components.count, components.count)
    for i in 0..<5 {
      XCTAssertTrue(contains(self.node.components, self.node.componentWithKey(String(i))!))
    }

  }
  
  func testAddComponentWithKey() {
    let component = Component()
    XCTAssertTrue(self.node.addComponent(component, withKey:"added"))
    XCTAssertFalse(self.node.addComponent(Component(), withKey:"added"))
    XCTAssertEqual(self.node.components, [component])
  }
  
  func testAddComponent() {
    let component = Component()
    XCTAssertTrue(self.node.addComponent(component))
    XCTAssertFalse(self.node.addComponent(component))
    XCTAssertFalse(self.node.addComponent(Component()))
    XCTAssertEqual(self.node.components, [component])
    
  }
  
  func testRemoveComponentWithClass() {
    let component = Component()
    self.node.addComponent(component)
    XCTAssertFalse(self.node.components.isEmpty)
    XCTAssertTrue(self.node.removeComponentWithClass(component.dynamicType))
    XCTAssertFalse(self.node.removeComponentWithClass(component.dynamicType))
    XCTAssertTrue(self.node.components.isEmpty)

    self.node.addComponent(component)
    XCTAssertFalse(self.node.components.isEmpty)
    XCTAssertTrue(self.node.removeComponentWithClass(Component.self))
    XCTAssertFalse(self.node.removeComponentWithClass(Component.self))
    XCTAssertTrue(self.node.components.isEmpty)

    
  }
  
  func testRemoveComponentWithKey() {
    let component = Component()
    self.node.addComponent(component, withKey: "removed")
    XCTAssertFalse(self.node.components.isEmpty)
    XCTAssertTrue(self.node.removeComponentWithKey("removed"))
    XCTAssertFalse(self.node.removeComponentWithKey("removed"))
    XCTAssertTrue(self.node.components.isEmpty)
    
  }
  
  func testRemoveComponent() {
    let component = Component()
    self.node.addComponent(component)
    XCTAssertFalse(self.node.components.isEmpty)
    XCTAssertTrue(self.node.removeComponent(component))
    XCTAssertFalse(self.node.removeComponent(component))
    XCTAssertTrue(self.node.components.isEmpty)
    
  }

}
