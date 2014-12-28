//
//  ObstacleMoving.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 25/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

class ObstacleMoving : Component {
  var closure:((SKScene)->())?
  init(width:CGFloat) {
    super.init()
    self.closure = { scene in
      let distanceToMove = CGFloat(scene.frame.size.width + 2.0 * width)
      let moveObstacle = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
      let removeObstacle = SKAction.removeFromParent()
      let moveObstacleAndRemove = SKAction.sequence([moveObstacle, removeObstacle])
      self.node?.runAction(moveObstacleAndRemove)
    }
  }
  
  func didAddNodeToScene(scene:SKScene) {
    self.closure!(scene)
  }
  
}
