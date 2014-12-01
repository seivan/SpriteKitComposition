//
//  SceneTests.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 26/11/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import UIKit
import XCTest
import SpriteKit




class SceneTests: SpriteKitTestCase {
  
  var notificationName:String!
  var notificationSender:AnyObject!
  var notificationUserInfo:Any?
  
  override func setUp() {
    super.setUp()
    self.scene = SKScene()
  }
  override func tearDown() {
    self.notificationName     = nil
    self.notificationSender   = nil
    self.notificationUserInfo = nil
    self.scene = nil

  }
  
  func testsConformsToSKPhysicsContactDelegate() {
    XCTAssertTrue(self.scene.conformsToProtocol(SKPhysicsContactDelegate))
    XCTAssertTrue(self.scene.respondsToSelector("didBeginContact:"))
    XCTAssertTrue(self.scene.respondsToSelector("didEndContact:"))
  }
  
  func testDidChangeSize() {
    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
      self.notificationName = name
      self.notificationSender = sender
      self.notificationUserInfo = userInfo
    }
    self.scene.didChangeSize(CGSizeZero)
    XCTAssertEqual(self.notificationName, "didChangeSceneSizedFrom")
    XCTAssertEqual(self.notificationSender! as SKScene, self.scene)
    XCTAssertEqual(self.notificationUserInfo! as CGSize, CGSizeZero)
  }

  func testDidMoveToView() {
    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
      self.notificationName = name
      self.notificationSender = sender
      self.notificationUserInfo = userInfo
    }
    let view = SKView()
    self.scene.didMoveToView(view)
    XCTAssertEqual(self.notificationName, "didMoveToView")
    XCTAssertEqual(self.notificationSender! as SKScene, self.scene)
    XCTAssertEqual(self.notificationUserInfo! as SKView, view)
  }

  func testWillMoveFromView() {
    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
      self.notificationName = name
      self.notificationSender = sender
      self.notificationUserInfo = userInfo
    }
    let view = SKView()
    self.scene.willMoveFromView(view)
    XCTAssertEqual(self.notificationName, "willMoveFromView")
    XCTAssertEqual(self.notificationSender! as SKScene, self.scene)
    XCTAssertEqual(self.notificationUserInfo! as SKView, view)
  }
  
  func testUpdate() {
    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
      self.notificationName = name
      self.notificationSender = sender
      self.notificationUserInfo = userInfo
    }

    self.scene.update(2)
    XCTAssertEqual(self.notificationName, "didUpdate")
    XCTAssertEqual(self.notificationSender! as SKScene, self.scene)
    XCTAssertEqualWithAccuracy(self.notificationUserInfo! as NSTimeInterval, 0.0166666666666667,
      0.0000000000000001)
  }
  
  func testDidEvaluateActions() {
    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
      self.notificationName = name
      self.notificationSender = sender
      self.notificationUserInfo = userInfo
    }
    
    self.scene.didEvaluateActions()
    XCTAssertEqual(self.notificationName, "didEvaluateActions")
    XCTAssertEqual(self.notificationSender! as SKScene, self.scene)
    XCTAssertTrue(self.notificationUserInfo == nil)
  }
  
  func testDidSimulatePhysics() {
    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
      self.notificationName = name
      self.notificationSender = sender
      self.notificationUserInfo = userInfo
    }
    
    self.scene.didSimulatePhysics()
    XCTAssertEqual(self.notificationName, "didSimulatePhysics")
    XCTAssertEqual(self.notificationSender! as SKScene, self.scene)
    XCTAssertTrue(self.notificationUserInfo == nil)
  }

  
  func testDidApplyConstraints() {
    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
      self.notificationName = name
      self.notificationSender = sender
      self.notificationUserInfo = userInfo
    }
    
    self.scene.didApplyConstraints()
    XCTAssertEqual(self.notificationName, "didApplyConstraints")
    XCTAssertEqual(self.notificationSender! as SKScene, self.scene)
    XCTAssertTrue(self.notificationUserInfo == nil)
  }

  func testDidFinishUpdate() {
    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
      self.notificationName = name
      self.notificationSender = sender
      self.notificationUserInfo = userInfo
    }
    
    self.scene.didFinishUpdate()
    XCTAssertEqual(self.notificationName, "didFinishUpdate")
    XCTAssertEqual(self.notificationSender! as SKScene, self.scene)
    XCTAssertTrue(self.notificationUserInfo == nil)
  }

  func testDidBeginContact() {

    let currentScene = self.scene
    self.setUpScene()
    let component = SampleComponent()
    self.node.addComponent(component)
    self.nextPhysicsContact { (otherNode) -> () in
      var counter = 0
      NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
        if counter == 0 {
          XCTAssertEqual(name, "didBeginContact")
        }
        counter += 1
      }
      currentScene.didBeginContact(component.assertionDidBeginContactWithNode.contact)
      XCTAssertEqual(counter, 3)
      
    }


  }
  
  
//  func testDidBeginContactWithNode() {
//    
//    let currentScene = self.scene
//    self.setUpScene()
//    let component = SampleComponent()
//    self.node.addComponent(component)
//    self.nextPhysicsContact { (otherNode) -> () in
//      var counter = 0
//      NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
//        if counter == 0 {
//          XCTAssertNotEqual(name, "didBeginContactWithNode")
//        }
//        else {
//          let tuple = userInfo as (SKNode, contact: SKPhysicsContact)
//          XCTAssertEqual(name, "didBeginContactWithNode")
//          XCTAssertNotNil(sender as SKNode)
//          XCTAssertNotNil(tuple.0)
//          XCTAssertNotEqual(sender as SKNode, tuple.0)
//          XCTAssertEqual(tuple.contact, component.assertionDidBeginContactWithNode.contact)
//        }
//        counter += 1
//      }
//      currentScene.didBeginContact(component.assertionDidBeginContactWithNode.contact)
//      XCTAssertEqual(counter, 3)
//      
//    }
//  }
//
//
//  func testDidEndContact() {
//    
//    let currentScene = self.scene
//    self.setUpScene()
//    NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
//      if name == "didEndContact" {
//        self.notificationName = name
//        self.notificationSender = sender
//        self.notificationUserInfo = userInfo
//      }
//    }
//    
//    let component = SampleComponent()
//    self.node.addComponent(component)
//    self.nextPhysicsContact { (otherNode) -> () in
//      currentScene.didEndContact(component.assertionDidBeginContact)
//      XCTAssertEqual(self.notificationName, "didEndContact")
//      XCTAssertEqual(self.notificationSender! as SKScene, currentScene)
//      XCTAssertTrue(self.notificationUserInfo != nil)
//      
//    }
//    
//  }
//  
//  
//  func testDidEndContactWithNode() {
//
//    let currentScene = self.scene
//    self.setUpScene()
//    let component = SampleComponent()
//    self.node.addComponent(component)
//    self.nextPhysicsContact { (otherNode) -> () in
//      var counter = 0
//      NotificationHubMock.onPublishingMockHandler { (name, sender, userInfo) -> (Void) in
//        if counter == 0 {
//          XCTAssertNotEqual(name, "didEndContactWithNode")
//        }
//        else {
//          let tuple = userInfo as (SKNode, contact: SKPhysicsContact)
//          XCTAssertEqual(name, "didEndContactWithNode")
//          XCTAssertNotNil(sender as SKNode)
//          XCTAssertNotNil(tuple.0)
//          XCTAssertNotEqual(sender as SKNode, tuple.0)
//          XCTAssertEqual(tuple.contact, component.assertionDidEndContactWithNode.contact)
//        }
//        counter += 1
//      }
//      currentScene.didEndContact(component.assertionDidEndContactWithNode.contact)
//      XCTAssertEqual(counter, 3)
// 
//    }
//  }

  
  


}
