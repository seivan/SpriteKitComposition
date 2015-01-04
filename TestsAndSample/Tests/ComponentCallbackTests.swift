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
    XCTAssertEqual(self.node, self.component.assertionDidAddToNode)
    XCTAssertEqual(self.scene, self.component.assertionDidAddNodeToScene)
  }
  
  func testDidAddToNodeWithoutScene() {
    self.node.removeFromParent()
    self.node.addComponent(self.component)
    XCTAssertEqual(self.node, self.component.assertionDidAddToNode)
    XCTAssertNil(self.component.assertionDidAddNodeToScene)
    self.scene.addChild(self.node)
    XCTAssertEqual(self.scene, self.component.assertionDidAddNodeToScene)
  }

  func testDidAddNodeToSceneBefore() {
    self.node.addComponent(self.component)
    XCTAssertEqual(self.scene, self.component.assertionDidAddNodeToScene)
  }
  
  func testDidAddNodeToSceneAfter() {
    self.node.removeFromParent()
    self.node.addComponent(self.component)
    XCTAssertNil(self.component.assertionDidAddNodeToScene)
    self.scene.addChild(self.node)
    XCTAssertEqual(self.scene, self.component.assertionDidAddNodeToScene)
  }

  func testDidRemoveFromNode() {
    self.node.addComponent(self.component)
    let didRemove = self.component.removeFromNode()
    XCTAssertEqual(self.component, didRemove!)
    XCTAssertNotNil(self.component.assertionDidRemoveFromNode)
  }
  
  func testDidRemoveNodeFromScene() {
    self.node.addComponent(self.component)
    self.node.removeFromParent()
    XCTAssertEqual(self.scene, self.component.assertionDidRemoveNodeFromScene)
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
  
  
    func testDidContactSceneStarted() {
      self.node.addComponent(self.component)
      self.nextPhysicsContact() { node in
        XCTAssertEqual(self.component.assertionDidContactSceneStarted.contact.bodyA.node!, node)
        XCTAssertEqual(self.component.assertionDidContactSceneStarted.contact.bodyB.node!, self.node)
        XCTAssertEqual(self.component.assertionDidContactSceneStarted.state, ComponentState.Started)
        

      }
  
      self.setUpScene()
      self.node.addComponent(self.component)
      self.component.isEnabled = false
      self.component.assertionDidContactSceneStarted = nil
      self.nextPhysicsContact() { node in
        XCTAssertTrue(self.component.assertionDidContactSceneStarted == nil)
      }
  
    }

  func testDidContactSceneCompleted() {
    self.node.addComponent(self.component)
    self.nextPhysicsContact() { node in
      XCTAssertEqual(self.component.assertionDidContactSceneCompleted.contact.bodyA.node!, node)
      XCTAssertEqual(self.component.assertionDidContactSceneCompleted.contact.bodyB.node!, self.node)
      XCTAssertEqual(self.component.assertionDidContactSceneCompleted.state, ComponentState.Completed)
    }
    
    self.setUpScene()
    self.node.addComponent(self.component)
    self.component.isEnabled = false
    self.component.assertionDidContactSceneCompleted = nil
    self.nextPhysicsContact() { node in
      XCTAssertTrue(self.component.assertionDidContactSceneCompleted == nil)
    }
    
  }
  
  
  func testDidContactWithNodeStarted() {
    self.node.addComponent(self.component)
    self.nextPhysicsContact() { node in
      XCTAssertEqual(self.component.assertionDidContactNodeStarted.node, node)
      XCTAssertEqual(self.component.assertionDidContactNodeStarted.contact.bodyB.node!, self.node)
      XCTAssertEqual(self.component.assertionDidContactNodeStarted.state, ComponentState.Started)
    }
    
    self.setUpScene()
    self.node.addComponent(self.component)
    self.component.isEnabled = false
    self.component.assertionDidContactSceneStarted = nil
    self.nextPhysicsContact() { node in
      XCTAssertTrue(self.component.assertionDidContactSceneStarted == nil)
    }

    
  }

  func testDidContactWithNodeCompleted() {
    self.node.addComponent(self.component)
    self.nextPhysicsContact() { node in
      XCTAssertEqual(self.component.assertionDidContactNodeCompleted.node, node)
      XCTAssertEqual(self.component.assertionDidContactNodeCompleted.contact.bodyB.node!, self.node)
      XCTAssertEqual(self.component.assertionDidContactNodeCompleted.state, ComponentState.Completed)
    }
    
    self.setUpScene()
    self.node.addComponent(self.component)
    self.component.isEnabled = false
    self.component.assertionDidContactNodeCompleted = nil
    self.nextPhysicsContact() { node in
      XCTAssertTrue(self.component.assertionDidContactNodeCompleted == nil)
    }
    
    
  }

  
  func testDidTouchSceneStarted() {
    self.node.addComponent(self.component)
    self.scene.touchesBegan(NSSet(), withEvent: UIEvent())
    XCTAssertNotNil(self.component.assertionDidTouchSceneStarted.touches)
    XCTAssertEqual(self.component.assertionDidTouchSceneStarted.state, ComponentState.Started)
  }

  func testDidTouchSceneChanged() {
    self.node.addComponent(self.component)
    self.scene.touchesMoved(NSSet(), withEvent: UIEvent())
    XCTAssertNotNil(self.component.assertionDidTouchSceneChanged.touches)
    XCTAssertEqual(self.component.assertionDidTouchSceneChanged.state, ComponentState.Changed)
  }

  func testDidTouchSceneCompleted() {
    self.node.addComponent(self.component)
    self.scene.touchesEnded(NSSet(), withEvent: UIEvent())
    XCTAssertNotNil(self.component.assertionDidTouchSceneCompleted.touches)
    XCTAssertEqual(self.component.assertionDidTouchSceneCompleted.state, ComponentState.Completed)
  }

  func testDidTouchSceneCancelled() {
    self.node.addComponent(self.component)
    self.scene.touchesCancelled(NSSet(), withEvent: UIEvent())
    XCTAssertNotNil(self.component.assertionDidTouchSceneCancelled.touches)
    XCTAssertEqual(self.component.assertionDidTouchSceneCancelled.state, ComponentState.Cancelled)
  }

  func testDidTouchNodeStarted() {
    self.node.addComponent(self.component)
    self.node.touchesBegan(NSSet(), withEvent: UIEvent())
    XCTAssertNotNil(self.component.assertionDidTouchNodeStarted.touches)
    XCTAssertEqual(self.component.assertionDidTouchNodeStarted.state, ComponentState.Started)
  }
  
  func testDidTouchNodeChanged() {
    self.node.addComponent(self.component)
    self.node.touchesMoved(NSSet(), withEvent: UIEvent())
    XCTAssertNotNil(self.component.assertionDidTouchNodeChanged.touches)
    XCTAssertEqual(self.component.assertionDidTouchNodeChanged.state, ComponentState.Changed)
  }
  
  func testDidTouchNodeCompleted() {
    self.node.addComponent(self.component)
    self.node.touchesEnded(NSSet(), withEvent: UIEvent())
    XCTAssertNotNil(self.component.assertionDidTouchSceneCompleted.touches)
    XCTAssertEqual(self.component.assertionDidTouchSceneCompleted.state, ComponentState.Completed)
  }
  
  func testDidTouchNodeCancelled() {
    self.node.addComponent(self.component)
    self.node.touchesCancelled(NSSet(), withEvent: UIEvent())
    XCTAssertNotNil(self.component.assertionDidTouchNodeCancelled.touches)
    XCTAssertEqual(self.component.assertionDidTouchNodeCancelled.state, ComponentState.Cancelled)
  }

}
