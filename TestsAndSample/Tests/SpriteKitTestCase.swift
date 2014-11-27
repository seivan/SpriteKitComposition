//
//  TestHostTests.swift
//  TestHostTests
//
//  Created by Seivan Heidari on 26/11/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import UIKit
import XCTest
import SpriteKit

class SpriteKitTestCase: XCTestCase {

  var scene:SKScene?
  var node:SKNode?
  var controller:UIViewController?
  
  func nextGameLoop(handler:()->()) {
    let time:NSTimeInterval = 0.1
    let expectation = self.expectationWithDescription(__FUNCTION__)
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
    }
    self.waitForExpectationsWithTimeout(time+0.1, nil)
    
  }
  
  func setUpPhysicsContact(handler:(otherNode:SKNode)->()) {
    var expectation = self.expectationWithDescription(__FUNCTION__)
    self.scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    let otherNode = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 50, height: 50))
    otherNode.name = "blueNode"
    self.scene?.addChild(otherNode)
    
    for node in [otherNode, self.node!] {
      node.position = CGPoint(x: 100, y: 100)
      node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 40, height: 40))
      node.physicsBody?.dynamic = true
      node.physicsBody?.pinned = false
    }

    self.node?.physicsBody?.contactTestBitMask = 1
    self.node?.physicsBody?.categoryBitMask = 2
    
    otherNode.physicsBody?.categoryBitMask = 1
    otherNode.physicsBody?.contactTestBitMask = 2
    
    self.node?.position = CGPoint(x: 20, y: 20)
    self.node?.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
    
    
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
      expectation.fulfill()
      handler(otherNode: otherNode)
    }
    self.waitForExpectationsWithTimeout(1.1, nil)

  }

  func setUpScene() {
    let app = UIApplication.sharedApplication().delegate!
    self.controller = UIViewController()
    let view = SKView(frame: self.controller!.view.frame)
    let window = app.window!!
    self.controller!.view = view
    window.rootViewController = controller
    self.scene = SKScene(size: self.controller!.view.frame.size)
    self.node = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 50, height: 50))
    self.node?.name = "redNode"
    view.presentScene(self.scene)
    self.scene?.addChild(self.node!)
    window.makeKeyAndVisible()
    
  }
  override func setUp() {
    super.setUp()
    self.setUpScene()
  }
    
  override func tearDown() {
    super.tearDown()
  }
    
  
}
