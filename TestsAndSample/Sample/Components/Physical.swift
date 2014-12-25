//
//  Physical.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 19/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit
enum PhysicalBodyShape {
  case Circle
  case Rectangle
}

class Physical : Component {
  var closure:(()->())?
  init(collisionsAs:UInt32, collisionsWith:UInt32, dynamic:Bool, shape:PhysicalBodyShape) {
    super.init()
    self.closure = {
      let sprite = self.node! as SKSpriteNode
      switch shape {
      case .Circle:
        let radius = sprite.size.height / 2
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: radius)
      case .Rectangle:
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize:
          CGSizeMake(sprite.scene!.frame.size.width,
            sprite.size.height * 2.0))

      }
      sprite.physicsBody?.dynamic = dynamic
      sprite.physicsBody?.allowsRotation = false
      
      sprite.physicsBody?.categoryBitMask = collisionsAs
      sprite.physicsBody?.collisionBitMask = collisionsWith
      sprite.physicsBody?.contactTestBitMask = collisionsWith

    }
  }

  func didAddNodeToScene(scene:SKScene) {
    self.closure!()

  }
}
