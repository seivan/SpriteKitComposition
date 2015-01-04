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
    var addedComponent = self.node.addComponent(component, withKey:"added")!
    XCTAssertEqual(addedComponent, component)
    XCTAssertNil(self.node.addComponent(Component(), withKey:"added"))
    XCTAssertEqual(self.node.components, [component])
    XCTAssertEqual(self.node, component.node!)
  }
  
  func testAddComponent() {
    let component = Component()
    let addedComponent = self.node.addComponent(component)!
    XCTAssertEqual(addedComponent, component)
    XCTAssertNil(self.node.addComponent(component))
    XCTAssertNil(self.node.addComponent(Component()))
    XCTAssertEqual(self.node.components, [component])
    XCTAssertEqual(self.node, component.node!)    
  }
  
  func testRemoveComponentWithClass() {
    let component = Component()
    self.node.addComponent(component)
    XCTAssertFalse(self.node.components.isEmpty)
    let removedComponent = self.node.removeComponentWithClass(component.dynamicType)!
    XCTAssertEqual(removedComponent, component)
    XCTAssertNil(self.node.removeComponentWithClass(component.dynamicType))
    XCTAssertTrue(self.node.components.isEmpty)

    self.node.addComponent(component)
    XCTAssertFalse(self.node.components.isEmpty)
    let anotherRemovedComponent = self.node.removeComponentWithClass(Component.self)!
    

    XCTAssertEqual(anotherRemovedComponent,component)
    XCTAssertNil(self.node.removeComponentWithClass(Component.self))
    XCTAssertTrue(self.node.components.isEmpty)

    
  }
  
  func testRemoveComponentWithKey() {
    let component = Component()
    self.node.addComponent(component, withKey: "removed")
    XCTAssertFalse(self.node.components.isEmpty)
    let removedComponent = self.node.removeComponentWithKey("removed")!
    XCTAssertEqual(removedComponent, component)
    XCTAssertNil(self.node.removeComponentWithKey("removed"))
    XCTAssertTrue(self.node.components.isEmpty)
    
  }
  
  func testRemoveComponent() {
    let component = Component()
    self.node.addComponent(component)
    XCTAssertFalse(self.node.components.isEmpty)
    let removedComponent = self.node.removeComponent(component)!

    XCTAssertEqual(removedComponent, component)
    XCTAssertNil(self.node.removeComponent(component))
    XCTAssertTrue(self.node.components.isEmpty)
    
  }
  
  func testAddChild() {
    let mainComponent   = SampleComponent()
    let nestedComponent = SampleComponent()
    self.node.addComponent(mainComponent)
    let node = SKNode()
    node.addComponent(nestedComponent)
    self.node.addChild(node)
    
    
    XCTAssertNil(mainComponent.assertionDidAddNodeToScene)
    XCTAssertNil(nestedComponent.assertionDidAddNodeToScene)
    
    self.scene.addChild(self.node)
    XCTAssertEqual(self.scene,mainComponent.assertionDidAddNodeToScene)
    XCTAssertEqual(self.scene,nestedComponent.assertionDidAddNodeToScene)
    mainComponent.assertionDidAddNodeToScene = nil
    nestedComponent.assertionDidAddNodeToScene = nil
    
    let oldScene = self.scene
    self.scene = SKScene()
    self.scene.addChild(self.node)
    
    XCTAssertEqual(self.scene,mainComponent.assertionDidAddNodeToScene)
    XCTAssertEqual(self.scene,nestedComponent.assertionDidAddNodeToScene)
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
    
    
    XCTAssertNil(mainComponent.assertionDidAddNodeToScene)
    XCTAssertNil(nestedComponent.assertionDidAddNodeToScene)
    
    self.scene.insertChild(self.node, atIndex:0)
    XCTAssertEqual(self.scene,mainComponent.assertionDidAddNodeToScene)
    XCTAssertEqual(self.scene,nestedComponent.assertionDidAddNodeToScene)
    mainComponent.assertionDidAddNodeToScene = nil
    nestedComponent.assertionDidAddNodeToScene = nil
    
    let oldScene = self.scene
    self.scene = SKScene()
    self.scene.addChild(self.node)
    
    XCTAssertEqual(self.scene,mainComponent.assertionDidAddNodeToScene)
    XCTAssertEqual(self.scene,nestedComponent.assertionDidAddNodeToScene)
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
    XCTAssertEqual(self.scene,mainComponent.assertionDidRemoveNodeFromScene)
    XCTAssertEqual(self.scene,nestedComponent.assertionDidRemoveNodeFromScene)
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
    XCTAssertEqual(self.scene,mainComponent.assertionDidRemoveNodeFromScene)
    XCTAssertEqual(self.scene,nestedComponent.assertionDidRemoveNodeFromScene)
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
    XCTAssertEqual(self.scene,mainComponent.assertionDidRemoveNodeFromScene)
    XCTAssertEqual(self.scene,nestedComponent.assertionDidRemoveNodeFromScene)
    XCTAssertNil(self.node.scene)
    XCTAssertNil(node.scene)
    
  }
  
  func testEnableUserinteractionOnNode() {
    let mainComponent   = SampleComponent()
    XCTAssertFalse(self.node.userInteractionEnabled)
    self.node.addComponent(mainComponent)
    self.scene.addChild(self.node)
    XCTAssertTrue(self.node.userInteractionEnabled)
    
  }


  


}
