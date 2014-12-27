//
//  Physical.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 19/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

enum PhysicalBodyShape {
  case Circle(radius:Double)
  case Rectangle(size:CGSize)
}

class Physical : Component {
  var closure:(()->())?

  init(collisionsAs:UInt32, collisionsWith:UInt32, dynamic:Bool, shape:PhysicalBodyShape) {
    super.init()
    self.closure = {
      let sprite = self.node! as SKSpriteNode
      switch shape {
      case .Circle(let radius):
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
      case .Rectangle(let size):
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize:size)
      }
      if let body = sprite.physicsBody {
        body.dynamic            = dynamic
        body.allowsRotation     = false
        body.categoryBitMask    = collisionsAs
        body.collisionBitMask   = collisionsWith
        body.contactTestBitMask = collisionsWith
      }

    }
  }

  func didAddNodeToScene(scene:SKScene) { self.closure!() }
}
