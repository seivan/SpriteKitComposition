//
//  Physical.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 19/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

class Physical : Component {
  let collisionsAs:UInt32
  let collisionsWith:UInt32
  init(collisionsAs:UInt32, collisionsWith:UInt32) {
    self.collisionsAs = collisionsAs
    self.collisionsWith = collisionsWith
  }
  
  func didAddToNode() {
    let sprite = self.node! as SKSpriteNode
    let radius = sprite.size.height / 2
    sprite.physicsBody = SKPhysicsBody(circleOfRadius: radius)
    sprite.physicsBody?.dynamic = true
    sprite.physicsBody?.allowsRotation = false
    
    sprite.physicsBody?.categoryBitMask = self.collisionsAs
    sprite.physicsBody?.collisionBitMask = self.collisionsWith
    sprite.physicsBody?.contactTestBitMask = self.collisionsWith
    
  }
}
