//
//  Debugging.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 05/01/15.
//  Copyright (c) 2015 Seivan Heidari. All rights reserved.
//

import SpriteKIt

class Debugging: Component {
  

  
  func didMoveToView(view:SKView) {
    self.didEnable(true)
  }
  
  func didEnable(isEnabled:Bool) {
    if let view = self.node?.scene?.view {
      view.showsFPS = isEnabled
      view.showsNodeCount = isEnabled
      view.showsDrawCount = isEnabled
      view.showsQuadCount = isEnabled
      view.showsPhysics = isEnabled
      view.showsFields = isEnabled
      view.setValue(NSNumber(bool: isEnabled), forKey: "_showsCulledNodesInNodeCount")

    }
  }
}
