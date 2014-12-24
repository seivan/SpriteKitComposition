//
//  Gravity.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 18/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//


import SpriteKit
class Gravitating: Component {

  func didAddNodeToScene() {
    self.node!.scene?.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
  }
  
}
