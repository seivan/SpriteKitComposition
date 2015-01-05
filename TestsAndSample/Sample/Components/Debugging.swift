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
    view.showsFPS = true
    view.showsNodeCount = true
    view.showsDrawCount = true
    view.showsQuadCount = true
    view.showsPhysics = true
    view.showsFields = true
    view.setValue(NSNumber(bool: true), forKey: "_showsCulledNodesInNodeCount")
  }
}
