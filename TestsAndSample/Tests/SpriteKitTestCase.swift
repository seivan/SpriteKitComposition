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
  
  func setUpScene() {
    let app = UIApplication.sharedApplication().delegate!
    self.controller = UIViewController()
    let view = SKView(frame: self.controller!.view.frame)
    let window = app.window!!
    self.controller!.view = view
    window.rootViewController = controller
    self.scene = SKScene(size: self.controller!.view.frame.size)
    self.node = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 50, height: 50))
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
