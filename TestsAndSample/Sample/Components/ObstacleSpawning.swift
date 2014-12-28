////
////  ObstacleSpawning.swift
////  TestsAndSample
////
////  Created by Seivan Heidari on 28/12/14.
////  Copyright (c) 2014 Seivan Heidari. All rights reserved.
////
//
//import SpriteKit
//
//class ObstacleSpawning: Component {
//
//  var closure:((SKScene)->())?
//  override init() {
//    super.init()
//    self.closure = { scene in
//      let spawn = SKAction.runBlock {
//        
//        let pipePair = SKNode()
//        pipePair.position = CGPoint( x: scene.frame.size.width + self.pipeTextureUp.size().width * 2, y:0)
//        pipePair.zPosition = -10
//        
//        let height = UInt32( UInt(scene.frame.size.height / 4) )
//        let y = arc4random() % height + height
//        
//        let pipeDown = SKSpriteNode(texture: self.pipeTextureDown)
//        pipeDown.setScale(2.0)
//        pipeDown.position = CGPoint(x:0.0, y:CGFloat(Double(y)) + pipeDown.size.height + CGFloat(self.verticalPipeGap))
//        
//        pipeDown.addComponent(
//          Physical(collisionsAs: self.pipeCategory,
//            collisionsWith: self.birdCategory,
//            dynamic: false,
//            shape: .Rectangle(pipeDown.size)
//          )
//        )
//        
//        pipePair.addChild(pipeDown)
//        
//        let pipeUp = SKSpriteNode(texture: self.pipeTextureUp)
//        pipeUp.setScale(2.0)
//        pipeUp.position = CGPointMake(0.0, CGFloat(Double(y)))
//        
//        pipeUp.addComponent(
//          Physical(collisionsAs: self.pipeCategory,
//            collisionsWith: self.birdCategory,
//            dynamic: false,
//            shape: .Rectangle(pipeUp.size)
//          )
//        )
//        pipePair.addChild(pipeUp)
//        
//        var contactNode = SKNode()
//        contactNode.position = CGPoint(x:pipeDown.size.width + self.bird.size.width / 2, y:CGRectGetMidY( self.frame ) )
//        
//        contactNode.addComponent(
//          Physical(collisionsAs: self.scoreCategory,
//            contactWith: self.birdCategory,
//            dynamic: false,
//            shape: .Rectangle(CGSizeMake( pipeUp.size.width, self.frame.size.height ))
//          )
//        )
//        
//        
//        pipePair.addChild(contactNode)
//        
//        pipePair.addComponent(ObstacleMoving(width: self.pipeTextureUp.size().width))
//        self.pipes.addChild(pipePair)
//        
//      }
//      let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
//      let spawnThenDelay = SKAction.sequence([spawn, delay])
//      let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
//      scene.runAction(spawnThenDelayForever)
//    }
//  }
//  
//  func didAddNodeToScene(scene:SKScene) {
//    self.closure!(scene)
//  }
//
//}
