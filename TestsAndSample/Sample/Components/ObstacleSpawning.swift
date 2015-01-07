
//  ObstacleSpawning.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 28/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.


import SpriteKit

class ObjectPooling : Component {
  var availableObjects = [SKNode]()
  func didRemoveChildNode(node:SKNode) {
    self.availableObjects.append(node)
  }
  
  func popAvailableObject() -> SKNode? {
    return self.availableObjects.isEmpty ? nil : self.availableObjects.removeLast()
  }
}

class ObstacleSpawning: Component {
  var obstacles:SKNode = SKNode()
  let pooling = ObjectPooling()

  var closure:((SKScene)->())?
  init(topObstacleGesture:SKTexture, bottomObstacleGesture:SKTexture, verticalGap:CGFloat = 150) {
    super.init()
    
    self.obstacles.addComponent(self.pooling)
    
    self.closure = { scene in
      let spawnPosition = CGPoint( x: scene.frame.size.width + topObstacleGesture.size().width * 2, y:0)
      let spawn = SKAction.runBlock {
        var pipePair = SKNode()
        pipePair.position = spawnPosition
        pipePair.zPosition = -10
        
        if let existingPipe = self.pooling.popAvailableObject() {
          pipePair = existingPipe
          pipePair.position = spawnPosition
          pipePair.zPosition = -10

        }
        
        else {
        let height = UInt32( UInt(scene.frame.size.height / 4) )
        let y = arc4random() % height + height
        
        
        
        let pipeDown = SKSpriteNode(texture: bottomObstacleGesture)
        pipeDown.setScale(2.0)
      
        pipeDown.position = CGPoint(x:0.0,
          y:CGFloat(Double(y)) + pipeDown.size.height + CGFloat(verticalGap))
        
        
        pipeDown.addComponent(
          Colliding( collisionsAs: ColliderType.Pipe.rawValue, contactWith: ColliderType.Bird.rawValue)
        )
        
        pipeDown.addComponent(
          Physical( dynamic: false, shape: .Rectangle(pipeDown.size) )
        )
        
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: topObstacleGesture)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPoint(x:0.0, y:CGFloat(Double(y)))
        
        pipeUp.addComponent(
          Colliding( collisionsAs: ColliderType.Pipe.rawValue, contactWith: ColliderType.Bird.rawValue)
        )
        
        pipeUp.addComponent(
          Physical( dynamic: false, shape: .Rectangle(pipeUp.size)
          )
        )
        pipePair.addChild(pipeUp)
        
        var contactNode = SKNode()
        contactNode.position = CGPoint(x:bottomObstacleGesture.size().width, y:CGRectGetMidY(scene.frame) )
        
        contactNode.addComponent(
          Colliding( collisionsAs: ColliderType.Score.rawValue, contactWith: ColliderType.Bird.rawValue )
        )
        
        contactNode.addComponent(
          Physical( dynamic: false, shape: .Rectangle(CGSize( width: pipeUp.size.width, height:scene.frame.size.height ))
          )
        )
        
        
        pipePair.addChild(contactNode)
        
        pipePair.addComponent(Parallax(type: .Horizontal))
        pipePair.addComponent(ObstacleMoving(width: bottomObstacleGesture.size().width))
      }
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
