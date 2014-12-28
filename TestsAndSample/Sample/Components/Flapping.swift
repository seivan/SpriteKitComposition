//
//  FlappingPhysics.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 18/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//


import UIKit
import SpriteKit

class Flapping: Component {
  
  func didTouchScene(touches:[UITouch],state:ComponentState) {
    if state == ComponentState.Started  {
//      let location = touches.first!.locationInNode(self.node?.scene)
      self.node?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
      self.node?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
    }    
  }
}
