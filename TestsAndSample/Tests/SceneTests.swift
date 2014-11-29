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

var notificationName:String!
var notificationSender:AnyObject?
var notificationUserInfo:Any?



class SceneTests: SpriteKitTestCase {
  override func setUp() {
    super.setUp()
    #if DEBUG
        println("AAAAAAAAAAAAAAAAAAAAAAE")
      #else
      
    #endif

//    NotificationHubMock.onPublishMockHandler { (name, sender, userInfo) -> Void in
//      notificationName = name
//      notificationSender = sender
//    }
//    NotificationHubMock.onSubscribeMockHandler { (name, sender, userInfo) -> Void in
//      
//    }
  }
  
  func testsConformsToSKPhysicsContactDelegate() {
    XCTAssertTrue(self.scene.conformsToProtocol(SKPhysicsContactDelegate))
    XCTAssertTrue(self.scene.respondsToSelector("didBeginContact:"))
    XCTAssertTrue(self.scene.respondsToSelector("didEndContact:"))
  }
  func testDidChangeSize() {
    self.scene.didChangeSize(CGSizeZero)
//    XCTAssertEqual(notificationName, "didChangeSize")
//    XCTAssertEqual(notificationSender! as SKScene, self.scene)
//    XCTAssertEqual(notificationUserInfo! as CGSize, CGSizeZero)
  }

}
