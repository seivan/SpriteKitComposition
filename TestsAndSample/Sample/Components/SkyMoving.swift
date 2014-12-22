//
//  SkyMoving.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 21/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

class SkyMoving: Component {
  let texture:SKTexture
  let groundTexture:SKTexture
  init(texture:SKTexture, aboveGroundTexture:SKTexture) {
    self.texture = texture
    self.groundTexture = aboveGroundTexture
  }
  func didAddToNode() {
    let skyTexture = self.texture
    let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width * 2.0))
    let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
    let moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
    
    let width =  self.node?.scene?.frame.size.width

    for var i:CGFloat = 0; i < 2.0 + width! / ( skyTexture.size().width * 2.0 ); ++i {
      let sprite = SKSpriteNode(texture: skyTexture)
      sprite.setScale(2.0)
      sprite.zPosition = -20
      
//      sprite.position = CGPointMake(i * sprite.size.width,
//                                    sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
      sprite.position = CGPoint(x: i * sprite.size.width,
                                y: sprite.size.height / 2.0 + self.groundTexture.size().height * 2.0)
      sprite.runAction(moveSkySpritesForever)
      self.node?.addChild(sprite)
    }
    
  }
}



