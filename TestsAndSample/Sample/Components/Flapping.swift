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
  let level:SKNode
  
  init(level:SKNode) {
    self.level = level
  }
  
  func didTouchScene(touches:[UITouch],state:ComponentState) {
    if self.level.speed > 0 && state == ComponentState.Started  {
//      let location = touches.first!.locationInNode(self.node?.scene)
      self.node?.physicsBody?.velocity = CGVectorMake(0, 0)
      self.node?.physicsBody?.applyImpulse(CGVectorMake(0, 30))
    }    
  }
}
