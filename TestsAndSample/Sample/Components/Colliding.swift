//
//  ColliderType.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 04/01/15.
//  Copyright (c) 2015 Seivan Heidari. All rights reserved.
//

import SpriteKit

public class Colliding: Component {
  public let collisionsAs:UInt32
  let collisionsWith:UInt32?
  let contactsWith:UInt32?
  
  init(collisionsAs:UInt32, collisionsWith:UInt32? = nil, contactWith:UInt32? = nil) {
    self.collisionsAs = collisionsAs
    self.collisionsWith = collisionsWith
    self.contactsWith = contactWith
  }
  
  func didAddToNode(node:SKNode) {
    node.physicsBody?.categoryBitMask = self.collisionsAs
    if let collisionsWith = self.collisionsWith {  node.physicsBody?.collisionBitMask = collisionsWith }
    if let contactsWith = self.contactsWith           {  node.physicsBody?.contactTestBitMask = contactsWith      }
  }
  
}
