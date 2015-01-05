//
//  GameScene.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 18/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

enum ColliderType : UInt32 {
  case Bird = 0
  case Ground = 2
  case Pipe = 4
  case Score = 8
}



class GameScene: SKScene {
  
  var bird:SKSpriteNode!
  var skyColor:SKColor!
  var pipeTextureUp:SKTexture!
  var pipeTextureDown:SKTexture!
  var moving:SKNode!
//  var pipes:SKNode!
  var canRestart = Bool()
  var scoreLabelNode:SKLabelNode!
  var score = NSInteger()
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)

    
    // ground
    let groundTexture = SKTexture(imageNamed: "land")
    groundTexture.filteringMode = .Nearest // shorter form for SKTextureFilteringMode.Nearest
    // skyline
    let skyTexture = SKTexture(imageNamed: "sky")
    skyTexture.filteringMode = .Nearest
    // setup our bird
    let birdTexture1 = SKTexture(imageNamed: "bird-01")
    birdTexture1.filteringMode = .Nearest
    let birdTexture2 = SKTexture(imageNamed: "bird-02")
    birdTexture2.filteringMode = .Nearest
    let birdTexture3 = SKTexture(imageNamed: "bird-03")
    birdTexture2.filteringMode = .Nearest
    let birdTexture4 = SKTexture(imageNamed: "bird-04")
    birdTexture2.filteringMode = .Nearest
    // create the pipes textures
    self.pipeTextureUp = SKTexture(imageNamed: "PipeUp")
    self.pipeTextureUp.filteringMode = .Nearest
    self.pipeTextureDown = SKTexture(imageNamed: "PipeDown")
    self.pipeTextureDown.filteringMode = .Nearest

  
  
    self.moving = SKNode()
    self.addChild(self.moving)

    
    self.canRestart = false

    self.scene?.addComponent(Debugging())

    self.moving.addComponent(GroundMoving(texture: groundTexture))
    self.moving.addComponent(SkyMoving(texture: skyTexture, aboveGroundTexture:groundTexture))
    
    
    // setup physics
    self.addComponent(Gravitating())
    
    //Setup background color
    self.addComponent(Skying())

    
    
    // spawn the pipes
    
    self.moving.addComponent(ObstacleSpawning(
      topObstacleGesture: self.pipeTextureUp,
      bottomObstacleGesture: self.pipeTextureDown)
    )

    

    
    
    
    
    
    self.bird = SKSpriteNode()
    self.bird.setScale(2.0)
    self.bird.position = CGPoint(x: self.scene!.frame.size.width * 0.35, y:self.scene!.frame.size.height * 0.6)

    self.bird.addComponent(Texturing(texture: birdTexture1))
    self.bird.addComponent(Rotating())
    self.bird.addComponent(Flapping())
    self.bird.addComponent(RepeatAnimating(textures: [birdTexture1, birdTexture2, birdTexture3, birdTexture4], timePerFrame: 0.2))
    
    
    self.bird.addComponent(Colliding(
      collisionsAs: ColliderType.Bird.rawValue,
      collisionsWith: ColliderType.Ground.rawValue | ColliderType.Pipe.rawValue,
      contactWith: ColliderType.Ground.rawValue | ColliderType.Pipe.rawValue)
    )
    self.bird.addComponent(
      Physical(dynamic:true,
               shape:.Circle(50)
      )
    )
    
    
    self.addChild(bird)
    
    // create the ground
    var ground = SKSpriteNode()
    ground.position = CGPoint(x:0, y:groundTexture.size().height)
    ground.size = groundTexture.size()
    
    ground.addComponent(Colliding(
      collisionsAs: ColliderType.Ground.rawValue,
      collisionsWith: ColliderType.Bird.rawValue
      )
    )

    ground.addComponent(
      Physical(
        dynamic:false,
        shape:.Rectangle(CGSizeMake(self.scene!.frame.size.width,
          ground.size.height * 2.0)))
    )

    self.addChild(ground)
    
    // Initialize label and create a label which holds the score
    self.score = 0
    self.scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
    self.scoreLabelNode.position = CGPointMake( CGRectGetMidX( self.frame ), 3 * self.frame.size.height / 4 )
    self.scoreLabelNode.zPosition = 100
    self.scoreLabelNode.text = String(self.score)
    self.addChild(self.scoreLabelNode)
    
  } 
  
  
  func resetScene (){
    // Move bird to original position and reset velocity
    bird.position = CGPointMake(self.frame.size.width / 2.5, CGRectGetMidY(self.frame))
    bird.physicsBody?.velocity = CGVectorMake( 0, 0 )
    bird.physicsBody?.collisionBitMask = ColliderType.Ground.rawValue | ColliderType.Pipe.rawValue
    bird.speed = 1.0
    bird.zRotation = 0.0
    
    // Remove all existing pipes
//    pipes.removeAllChildren()

    let component = self.moving.removeComponentWithClass(ObstacleSpawning.self)
    self.moving.addComponent(component!)
    
    // Reset _canRestart
    canRestart = false
    
    // Reset score
    score = 0
    scoreLabelNode.text = String(score)
    
    // Restart animation
    moving.speed = 1
    self.bird.addComponent(Flapping())
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)
    /* Called when a touch begins */
    if canRestart {
      self.resetScene()
    }
  }
  
  
  
  
  override func didBeginContact(contact: SKPhysicsContact) {
    if moving.speed > 0 {
      if ( contact.bodyA.categoryBitMask & ColliderType.Score.rawValue ) == ColliderType.Score.rawValue || ( contact.bodyB.categoryBitMask & ColliderType.Score.rawValue ) == ColliderType.Score.rawValue {
        // Bird has contact with score entity
        score++
        scoreLabelNode.text = String(score)
        
        // Add a little visual feedback for the score increment
        scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
      }
      else {
        
        
        bird.physicsBody?.collisionBitMask = ColliderType.Ground.rawValue

        
        self.bird.removeComponentWithClass(Flapping.self)
        moving.speed = 0
        
        bird.runAction(  SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{ self.bird.speed = 0 })
        
        
       self.canRestart = true

      }
    }
  }
}
