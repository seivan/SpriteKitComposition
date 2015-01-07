//
//  Pooling.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 07/01/15.
//  Copyright (c) 2015 Seivan Heidari. All rights reserved.
//

import SpriteKit

class ObjectPooling : Component {
  var availableObjects = [SKNode]()
  func didRemoveChildNode(node:SKNode) {
    self.availableObjects.append(node)
  }
  
  func popAvailableObject() -> SKNode? {
    return self.availableObjects.isEmpty ? nil : self.availableObjects.removeLast()
  }
}
