//
//  PhysicsRotation.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 18/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

class RotationPhysics: Component {

  func didUpdate(time:NSTimeInterval) {
    if let node = self.node {
      if let body  = node.physicsBody {
        let angle = body.velocity.dy * ( body.velocity.dy < 0 ? 0.003 : 0.001 )
        node.zRotation = self.clamp(min:-1, max: 0.5, value: angle )
      }
    }

  }
  
  private func clamp(#min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
    if( value > max ) { return max }
    else if( value < min ) { return min }
    else { return value }
  }

}
