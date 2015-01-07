//
//  Parallax.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 06/01/15.
//  Copyright (c) 2015 Seivan Heidari. All rights reserved.
//

import SpriteKit

enum ParallaxType : UInt32 {
  case Horizontal = 1
  case Vertical = 2
}


class Parallax: Component {
  let move:(horizontal:CGFloat, vertical:CGFloat) -> (SKAction)
  
  init(type:ParallaxType? = nil) {
    self.move = { horizontal, vertical  in
      
      var group = [SKAction]()

      if let type = type {
        switch type {
        case .Horizontal:
          return SKAction.moveToX(horizontal, duration: 0)
        case .Vertical:
          return SKAction.moveToY(vertical, duration: 0)
        }
      }
      else {
        return SKAction.group([SKAction.moveToX(horizontal, duration: 0), SKAction.moveToY(vertical, duration: 0)])
      }

    }
  }
  
  func didEvaluateActions() {
    
    let scene      = self.node!.scene!
    let container  = self.node!
    
    for node in container.childNodes {
      let scenePos = scene.convertPoint(container.position, fromNode: scene)
    
      let offsetX = -1.0 + (2.0 * (scenePos.x / CGRectGetWidth(scene.frame)))
      let offsetY = -1.0 + (2.0 * (scenePos.y / CGRectGetHeight(scene.frame)))
    
      let offset:CGFloat = 25.0
      let delta =  (offset / CGFloat(node.children.count))
    

      for (var childNumber, child) in enumerate(node.childNodes) {
        let deltaForIndex =  delta * CGFloat(childNumber)
        child.runAction(
          self.move(horizontal: offsetX * deltaForIndex,
                    vertical: offsetY * deltaForIndex)
        )
//      child.position = CGPoint(x: offsetX * delta * CGFloat(childNumber), y: offsetY * delta * CGFloat(childNumber))
      }
    }

  }
}
