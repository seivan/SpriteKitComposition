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
  
  func setUpScene() {
    let app = UIApplication.sharedApplication().delegate!
    let controller = UIViewController()
    let view = SKView(frame: controller.view.frame)
    let window = app.window!!
    controller.view = view
    window.rootViewController = controller
    self.scene = SKScene(size: controller.view.frame.size)
    self.node = SKNode()
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
