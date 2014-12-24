//
//  Texturing.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 18/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit
class Texturing: Component {
  let texture:SKTexture
  
  init(texture:SKTexture) {
    self.texture = texture
  }
  func didAddToNode() {
    let sprite = (self.node as SKSpriteNode?)
    sprite?.texture = self.texture
    sprite?.size = self.texture.size()
  }
  
  func didRemoveFromNode() {
    let sprite = (self.node as SKSpriteNode?)
    sprite!.texture = nil
  }
}
