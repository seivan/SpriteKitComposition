//
//  Skying.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 20/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

class Skying : Component {
  
  func didAddToNode() {
    let skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    (self.node as SKScene).backgroundColor = skyColor
  }
  
}
