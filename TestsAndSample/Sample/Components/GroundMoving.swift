//
//  GroundMoving.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 21/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

    class GroundMoving : Component {
      let texture:SKTexture
      init(texture:SKTexture) {
        self.texture = texture
      }
      func didAddToNode(node:SKNode) {
        let groundTexture = self.texture
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        let width =  self.node?.scene?.frame.size.width
        for var i:CGFloat = 0; i < 2.0 + width! / ( groundTexture.size().width * 2.0 ); ++i {
          let sprite = SKSpriteNode(texture: self.texture)
          sprite.setScale(2.0)
          sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2.0)
          sprite.runAction(moveGroundSpritesForever)
          self.node?.addChild(sprite)
        }
        
      }
    }
