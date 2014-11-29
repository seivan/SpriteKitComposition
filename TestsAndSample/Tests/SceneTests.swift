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
  var notificationSender:AnyObject?
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
    XCTAssertEqual(notificationName, "didChangeSceneSizedFrom")
    XCTAssertEqual(notificationSender! as SKScene, self.scene)
    XCTAssertEqual(notificationUserInfo! as CGSize, CGSizeZero)
  }

}
