
//  ObstacleSpawning.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 28/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.


import SpriteKit

class ObstacleSpawning: Component {
  var obstacles:SKNode = SKNode()

  var closure:((SKScene)->())?
  init(topObstacleGesture:SKTexture, bottomObstacleGesture:SKTexture, verticalGap:CGFloat = 150) {
    super.init()
    self.closure = { scene in
      let spawn = SKAction.runBlock {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: scene.frame.size.width + topObstacleGesture.size().width * 2, y:0)
        pipePair.zPosition = -10
        
        let height = UInt32( UInt(scene.frame.size.height / 4) )
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: bottomObstacleGesture)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPoint(x:0.0,
          y:CGFloat(Double(y)) + pipeDown.size.height + CGFloat(verticalGap))
        
        
        pipeDown.addComponent(Colliding(
          collisionsAs: ColliderType.Pipe.rawValue,
          collisionsWith: ColliderType.Bird.rawValue)
        )
        
        pipeDown.addComponent(
          Physical(
            dynamic: false,
            shape: .Rectangle(pipeDown.size)
          )
        )
        
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: topObstacleGesture)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(Double(y)))
        
        pipeUp.addComponent(Colliding(
          collisionsAs: ColliderType.Pipe.rawValue,
          collisionsWith: ColliderType.Bird.rawValue)
        )
        
        pipeUp.addComponent(
          Physical(
            dynamic: false,
            shape: .Rectangle(pipeUp.size)
          )
        )
        pipePair.addChild(pipeUp)
        
        var contactNode = SKNode()
        // + self.bird.size.width / 2
        contactNode.position = CGPoint(x:pipeDown.size.width,
                                       y:CGRectGetMidY(scene.frame)
                                      )
        
        contactNode.addComponent(Colliding(
          collisionsAs: ColliderType.Score.rawValue,
          contactWith: ColliderType.Bird.rawValue
          )
        )
        
        contactNode.addComponent(
          Physical(
            dynamic: false,
            shape: .Rectangle(CGSizeMake( pipeUp.size.width, scene.frame.size.height ))
          )
        )
        
        
        pipePair.addChild(contactNode)
        
        pipePair.addComponent(ObstacleMoving(width: bottomObstacleGesture.size().width))
        self.obstacles.addChild(pipePair)
        
      }
      let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
      let spawnThenDelay = SKAction.sequence([spawn, delay])
      let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
      self.node?.addChild(self.obstacles)
      self.node!.runAction(spawnThenDelayForever)

    }
  }
  
  func didAddNodeToScene(scene:SKScene) {
    self.closure!(scene)
  }
  
  func didRemoveFromNode(node:SKNode) {
    node.removeAllActions()
    self.obstacles.removeAllChildren()
  }

}
