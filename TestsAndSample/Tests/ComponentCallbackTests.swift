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

class ComponentCallbackTests: SpriteKitTestCase {
  var component = SampleComponent()
  
  override func setUp() {
    super.setUp()
    var component = SampleComponent()
  }
  
  func testDidAddToNodeWithScene() {
    self.node.addComponent(self.component)
    XCTAssertTrue(self.component.assertionDidAddToNode)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }
  
  func testDidAddToNodeWithoutScene() {
    self.node.removeFromParent()
    self.node.addComponent(self.component)
    XCTAssertTrue(self.component.assertionDidAddToNode)
    XCTAssertFalse(self.component.assertionDidAddNodeToScene)
    self.scene.addChild(self.node)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }

  func testDidAddNodeToSceneBefore() {
    self.node.addComponent(self.component)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }
  
  func testDidAddNodeToSceneAfter() {
    self.node.removeFromParent()
    self.node.addComponent(self.component)
    XCTAssertFalse(self.component.assertionDidAddNodeToScene)
    self.scene.addChild(self.node)
    XCTAssertTrue(self.component.assertionDidAddNodeToScene)
  }

  func testDidRemoveFromNode() {
    self.node.addComponent(self.component)
    let didRemove = self.component.removeFromNode()
    XCTAssertTrue(didRemove)
    XCTAssertTrue(self.component.assertionDidRemoveFromNode)
  }
  
  func testDidRemoveNodeFromScene() {
    self.node.addComponent(self.component)
    self.node.removeFromParent()
    XCTAssertTrue(self.component.assertionDidRemoveNodeFromScene)
  }
  
  func testDidChangeSceneSizedFromWithScene() {
    self.node.addComponent(self.component)
    let oldSize = self.scene.size
    let size = CGSize(width: 300, height: 300)
    self.scene.size = size
    XCTAssertNotEqual(self.component.assertionDidChangeSceneSizedFrom, size)
    XCTAssertEqual(self.component.assertionDidChangeSceneSizedFrom, oldSize)
    
  }
  
  func testDidChangeSceneSizedFromWithoutScene() {
    self.node.removeFromParent()
    self.node.addComponent(self.component)
    let oldSize = self.scene.size
    let size = CGSize(width: 300, height: 300)
    self.scene.size = size
    XCTAssertFalse(self.component.assertionDidChangeSceneSizedFrom?  == size)
    XCTAssertFalse(self.component.assertionDidChangeSceneSizedFrom?  == oldSize)
    XCTAssertTrue(self.component.assertionDidChangeSceneSizedFrom   == nil)
    
  }

  func testDidMoveToView() {
    self.node.addComponent(self.component)
    let scene = self.node.scene
    let oldView = self.scene.view!
    let newView = SKView(frame: oldView.frame)
    (self.controller.view as SKView).presentScene(SKScene())
    self.controller.view = newView
    (self.controller.view as SKView).presentScene(scene)
    XCTAssertEqual(self.component.assertionWillMoveFromView, oldView)
    XCTAssertEqual(self.component.assertionDidMoveToView, newView)
  }
  
  func testWillMoveFromView() {
    self.node.addComponent(self.component)
    let scene = self.node.scene
    let oldView = self.scene.view!
    let newView = SKView(frame: oldView.frame)
    (self.controller.view as SKView).presentScene(scene)
    XCTAssertEqual(self.component.assertionWillMoveFromView, oldView)
    XCTAssertEqual(self.component.assertionDidMoveToView, oldView)
    
  }
  
  func testDidUpdate() {
    self.node.addComponent(self.component)
    
    self.nextGameLoop() {
      XCTAssertLessThanOrEqual(self.component.assertionDidUpdate, 1.0)
      XCTAssertGreaterThan(self.component.assertionDidUpdate, 0)
    }
    
    self.component.isEnabled = false
    self.component.assertionDidUpdate = 0
    self.nextGameLoop() {
      XCTAssertEqual(self.component.assertionDidUpdate, 0)
    }


  }
  
  func testDidEvaluateActions() {
    self.node.addComponent(self.component)
    
    self.nextGameLoop() {
      XCTAssertTrue(self.component.assertionDidEvaluateActions)
    }

    
    self.component.isEnabled = false
    self.component.assertionDidEvaluateActions = false
    self.nextGameLoop() {
      XCTAssertFalse(self.component.assertionDidEvaluateActions)
    }
    
  }
  
  func testDidSimulatePhysics() {
    self.node.addComponent(self.component)
    
    self.nextGameLoop() {
      XCTAssertTrue(self.component.assertionDidSimulatePhysics)
    }
    
    
    self.component.isEnabled = false
    self.component.assertionDidSimulatePhysics = false
    self.nextGameLoop() {
      XCTAssertFalse(self.component.assertionDidSimulatePhysics)
    }
  
  }
  
  func testDidApplyConstraints() {
    self.node.addComponent(self.component)
    
    self.nextGameLoop() {
      XCTAssertTrue(self.component.assertionDidApplyConstraints)
    }
    
    
    self.component.isEnabled = false
    self.component.assertionDidApplyConstraints = false
    self.nextGameLoop() {
      XCTAssertFalse(self.component.assertionDidApplyConstraints)
    }
    
  }
  
  func testDidFinishUpdate() {
    self.node.addComponent(self.component)
    
    self.nextGameLoop() {
      XCTAssertTrue(self.component.assertionDidFinishUpdate)
    }
    
    
    self.component.isEnabled = false
    self.component.assertionDidFinishUpdate = false
    self.nextGameLoop() {
      XCTAssertFalse(self.component.assertionDidFinishUpdate)
    }
    
  }
  

  func didContactOnSceneStarted() {
    self.node.addComponent(self.component)
    self.nextPhysicsContact() { node in
      XCTAssertEqual(self.component.assertionDidBeginContactWithNode.node, node)
      XCTAssertEqual(self.component.assertionDidBeginContactWithNode.contact.bodyB.node!, self.node)
    }

    self.setUpScene()
    self.node.addComponent(self.component)
    self.component.isEnabled = false
    self.component.assertionDidBeginContactWithNode = nil
    self.nextPhysicsContact() { node in
      XCTAssertTrue(self.component.assertionDidBeginContactWithNode == nil)
    }
  }

  
//  func testDidBeginContactWithNode() {
//    self.node.addComponent(self.component)
//    self.nextPhysicsContact() { node in
//      XCTAssertEqual(self.component.assertionDidBeginContactWithNode.node, node)
//      XCTAssertEqual(self.component.assertionDidBeginContactWithNode.contact.bodyB.node!, self.node)
//    }
//    
//    self.setUpScene()
//    self.node.addComponent(self.component)
//    self.component.isEnabled = false
//    self.component.assertionDidBeginContactWithNode = nil
//    self.nextPhysicsContact() { node in
//      XCTAssertTrue(self.component.assertionDidBeginContactWithNode == nil)
//    }
//
//    
//  }
//  
//  func testDidEndContactWithNode() {
//    self.node.addComponent(self.component)
//    self.nextPhysicsContact() { node in
//      XCTAssertEqual(self.component.assertionDidEndContactWithNode.node, node)
//      XCTAssertEqual(self.component.assertionDidEndContactWithNode.contact.bodyB.node!, self.node)
//    }
//    
//    self.setUpScene()
//    self.node.addComponent(self.component)
//    self.component.isEnabled = false
//    self.component.assertionDidEndContactWithNode = nil
//    self.nextPhysicsContact() { node in
//      XCTAssertTrue(self.component.assertionDidEndContactWithNode == nil)
//    }
//    
//  }
//  
//  func testBeginContact() {
//    self.node.addComponent(self.component)
//    self.nextPhysicsContact() { node in
//      XCTAssertEqual(self.component.assertionDidBeginContact.bodyA.node!, node)
//      XCTAssertEqual(self.component.assertionDidBeginContact.bodyB.node!, self.node)
//    }
//    
//    self.setUpScene()
//    self.node.addComponent(self.component)
//    self.component.isEnabled = false
//    self.component.assertionDidBeginContact = nil
//    self.nextPhysicsContact() { node in
//      XCTAssertTrue(self.component.assertionDidBeginContact == nil)
//    }
//    
//  }
//  
//  func testDidEndContact() {
//    self.node.addComponent(self.component)
//    self.nextPhysicsContact() { node in
//      XCTAssertEqual(self.component.assertionDidEndContact.bodyA.node!, node)
//      XCTAssertEqual(self.component.assertionDidEndContact.bodyB.node!, self.node)
//    }
//    
//    self.setUpScene()
//    self.node.addComponent(self.component)
//    self.component.isEnabled = false
//    self.component.assertionDidEndContact = nil
//    self.nextPhysicsContact() { node in
//      XCTAssertTrue(self.component.assertionDidEndContact == nil)
//    }
//    
//  }
//  
//  func testDidBeginNodeTouches() {
//    self.node.addComponent(self.component)
//    self.node.touchesBegan(NSSet(), withEvent: UIEvent())
//    XCTAssertNotNil(self.component.assertionDidBeginNodeTouches)
//    XCTAssertNotNil(self.component.assertionDidBeginSceneTouches)
//  }
//  
//  func testDidMoveNodeTouches() {
//    self.node.addComponent(self.component)
//    self.node.touchesMoved(NSSet(), withEvent: UIEvent())
//    XCTAssertNotNil(self.component.assertionDidMoveNodeTouches)
//    XCTAssertNotNil(self.component.assertionDidMoveSceneTouches)
//  }
//  func testDidEndNodeTouches() {
//    self.node.addComponent(self.component)
//    self.node.touchesEnded(NSSet(), withEvent: UIEvent())
//    XCTAssertNotNil(self.component.assertionDidEndNodeTouches)
//    XCTAssertNotNil(self.component.assertionDidEndSceneTouches)
//  }
//  func testDidCancelNodeTouches() {
//    self.node.addComponent(self.component)
//    self.node.touchesCancelled(NSSet(), withEvent: UIEvent())
//    XCTAssertNotNil(self.component.assertionDidCancelNodeTouches)
//    XCTAssertNotNil(self.component.assertionDidCancelSceneTouches)
//  }
//  func testDidBeginSceneTouches() {
//    self.node.addComponent(self.component)
//    self.scene.touchesBegan(NSSet(), withEvent: UIEvent())
//    XCTAssertNil(self.component.assertionDidBeginNodeTouches)
//    XCTAssertNotNil(self.component.assertionDidBeginSceneTouches)
//  }
//  func testDidMoveSceneTouches() {
//    self.node.addComponent(self.component)
//    self.scene.touchesMoved(NSSet(), withEvent: UIEvent())
//    XCTAssertNil(self.component.assertionDidMoveNodeTouches)
//    XCTAssertNotNil(self.component.assertionDidMoveSceneTouches)
//  }
//  func testDidEndSceneTouches() {
//    self.node.addComponent(self.component)
//    self.scene.touchesEnded(NSSet(), withEvent: UIEvent())
//    XCTAssertNil(self.component.assertionDidEndNodeTouches)
//    XCTAssertNotNil(self.component.assertionDidEndSceneTouches)
//  }
//  func testDidCancelSceneTouches() {
//    self.node.addComponent(self.component)
//    self.scene.touchesCancelled(NSSet(), withEvent: UIEvent())
//    XCTAssertNil(self.component.assertionDidCancelNodeTouches)
//    XCTAssertNotNil(self.component.assertionDidCancelSceneTouches)
//  }


}
