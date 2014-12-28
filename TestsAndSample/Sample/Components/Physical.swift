//
//  Physical.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 19/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit
enum PhysicalBodyShape {
  case Circle(CGFloat)
  case Rectangle(CGSize)
}

class Physical : Component {
  var closure:(()->())?
  init(collisionsAs:UInt32, collisionsWith:UInt32? = nil, contactWith:UInt32? = nil, dynamic:Bool, shape:PhysicalBodyShape) {
    super.init()
    self.closure = {
      let sprite = self.node!
      switch shape {
      case .Circle(var radius):
        if radius > 0.0 { radius = (sprite as SKSpriteNode).size.height / 2.0 }
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: radius)
      case .Rectangle(let size):
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize:size)
      }

      sprite.physicsBody?.dynamic             = dynamic
      sprite.physicsBody?.allowsRotation      = false
      sprite.physicsBody?.categoryBitMask     = collisionsAs

      if let collisionsWith = collisionsWith { sprite.physicsBody?.collisionBitMask    = collisionsWith }
      if let contactWith    = contactWith    { sprite.physicsBody?.contactTestBitMask  = contactWith    }



    }
  }

  func didAddNodeToScene(scene:SKScene) {
    self.closure!()

  }
}
