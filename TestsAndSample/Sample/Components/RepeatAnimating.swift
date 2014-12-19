//
//  RepeatAnimating.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 18/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import Foundation
import SpriteKit

class RepeatAnimating: Component {
  let animation:SKAction
  let key:NSUUID = NSUUID()
  
  init(textures:[SKTexture], timePerFrame:NSTimeInterval) {
    let anim = SKAction.animateWithTextures(textures, timePerFrame: 0.2)
    self.animation  = SKAction.repeatActionForever(anim)
  }
  
  func didAddToScene() {
    self.node?.removeActionForKey(self.key.UUIDString)
    self.node?.runAction(self.animation, withKey: self.key.UUIDString)
  }
  
  
  

}
