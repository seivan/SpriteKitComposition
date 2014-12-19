//
//  Gravity.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 18/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//


import SpriteKit
class Gravitating: Component {

  func didMoveToView(view:SKView) {
    view.scene?.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
  }
  
}
