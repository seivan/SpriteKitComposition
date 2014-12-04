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
    self.scene = SKScene()
    self.node = SKNode()
  }
  
  override func tearDown() {
    super.tearDown()
    self.node = nil
    self.scene = nil
  }
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
  
  func testAddChild() {
    let mainComponent   = SampleComponent()
    let nestedComponent = SampleComponent()
    self.node.addComponent(mainComponent)
    let node = SKNode()
    node.addComponent(nestedComponent)
    self.node.addChild(node)
    
    
    XCTAssertFalse(mainComponent.assertionDidAddNodeToScene)
    XCTAssertFalse(nestedComponent.assertionDidAddNodeToScene)
    
    self.scene.addChild(self.node)
    XCTAssertTrue(mainComponent.assertionDidAddNodeToScene)
    XCTAssertTrue(nestedComponent.assertionDidAddNodeToScene)
    mainComponent.assertionDidAddNodeToScene = false
    nestedComponent.assertionDidAddNodeToScene = false
    
    let oldScene = self.scene
    self.scene = SKScene()
    self.scene.addChild(self.node)
    
    XCTAssertTrue(mainComponent.assertionDidAddNodeToScene)
    XCTAssertTrue(nestedComponent.assertionDidAddNodeToScene)
    XCTAssertNotEqual(self.node.scene!, oldScene)
    XCTAssertNotEqual(node.scene!, oldScene)

  }

  func testInsertChild() {
    let mainComponent   = SampleComponent()
    let nestedComponent = SampleComponent()
    self.node.addComponent(mainComponent)
    let node = SKNode()
    node.addComponent(nestedComponent)
    self.node.insertChild(node, atIndex:0)
    
    
    XCTAssertFalse(mainComponent.assertionDidAddNodeToScene)
    XCTAssertFalse(nestedComponent.assertionDidAddNodeToScene)
    
    self.scene.insertChild(self.node, atIndex:0)
    XCTAssertTrue(mainComponent.assertionDidAddNodeToScene)
    XCTAssertTrue(nestedComponent.assertionDidAddNodeToScene)
    mainComponent.assertionDidAddNodeToScene = false
    nestedComponent.assertionDidAddNodeToScene = false
    
    let oldScene = self.scene
    self.scene = SKScene()
    self.scene.addChild(self.node)
    
    XCTAssertTrue(mainComponent.assertionDidAddNodeToScene)
    XCTAssertTrue(nestedComponent.assertionDidAddNodeToScene)
    XCTAssertNotEqual(self.node.scene!, oldScene)
    XCTAssertNotEqual(node.scene!, oldScene)

  }

  func testRemoveFromParent() {
    let mainComponent   = SampleComponent()
    let nestedComponent = SampleComponent()
    self.node.addComponent(mainComponent)
    let node = SKNode()
    node.addComponent(nestedComponent)
    self.node.addChild(node)
    self.scene.addChild(self.node)
    
    
    self.node.removeFromParent()
    XCTAssertTrue(mainComponent.assertionDidRemoveNodeFromScene)
    XCTAssertTrue(nestedComponent.assertionDidRemoveNodeFromScene)
    XCTAssertNil(self.node.scene)
    XCTAssertNil(node.scene)

  }
  
  func testRemoveAllChildren() {
    let mainComponent   = SampleComponent()
    let nestedComponent = SampleComponent()
    self.node.addComponent(mainComponent)
    let node = SKNode()
    node.addComponent(nestedComponent)
    self.node.addChild(node)
    self.scene.addChild(self.node)
    
    
    self.scene.removeAllChildren()
    XCTAssertTrue(mainComponent.assertionDidRemoveNodeFromScene)
    XCTAssertTrue(nestedComponent.assertionDidRemoveNodeFromScene)
    XCTAssertNil(self.node.scene)
    XCTAssertNil(node.scene)
    
  }

  func testRemoveChildrenInArray() {
    let mainComponent   = SampleComponent()
    let nestedComponent = SampleComponent()
    self.node.addComponent(mainComponent)
    let node = SKNode()
    node.addComponent(nestedComponent)
    self.node.addChild(node)
    self.scene.addChild(self.node)
    
    
    self.scene.removeChildrenInArray([self.node])
    XCTAssertTrue(mainComponent.assertionDidRemoveNodeFromScene)
    XCTAssertTrue(nestedComponent.assertionDidRemoveNodeFromScene)
    XCTAssertNil(self.node.scene)
    XCTAssertNil(node.scene)
    
  }


  


}
