//
//  GameScene.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 18/12/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  let verticalPipeGap = 150.0
  
  var bird:SKSpriteNode!
  var skyColor:SKColor!
  var pipeTextureUp:SKTexture!
  var pipeTextureDown:SKTexture!
  var moving:SKNode!
  var pipes:SKNode!
  var canRestart = Bool()
  var scoreLabelNode:SKLabelNode!
  var score = NSInteger()
  
  let birdCategory:UInt32   = 1 << 0
  let worldCategory:UInt32  = 1 << 1
  let pipeCategory:UInt32   = 1 << 2
  let scoreCategory:UInt32  = 1 << 3
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    self.canRestart = false
    
    // setup physics
    self.addComponent(Gravitating())
    
    //Setup background color
    self.addComponent(Skying())
    
    
    
    self.moving = SKNode()
    self.addChild(self.moving)
    self.pipes = SKNode()
    self.moving.addChild(self.pipes)
    
    // ground
    let groundTexture = SKTexture(imageNamed: "land")
    groundTexture.filteringMode = .Nearest // shorter form for SKTextureFilteringMode.Nearest
    // skyline
    let skyTexture = SKTexture(imageNamed: "sky")
    skyTexture.filteringMode = .Nearest
    
  
    
    self.moving.addComponent(GroundMoving(texture: groundTexture))
    self.moving.addComponent(SkyMoving(texture: skyTexture, aboveGroundTexture:groundTexture))
    
    // create the pipes textures
    self.pipeTextureUp = SKTexture(imageNamed: "PipeUp")
    self.pipeTextureUp.filteringMode = .Nearest
    self.pipeTextureDown = SKTexture(imageNamed: "PipeDown")
    self.pipeTextureDown.filteringMode = .Nearest
    
    

//    class ObstacleSpawning : Component {
//      
//      func didAddNodeToScene(scene:SKScene) {
//        // spawn the pipes
//        let spawn = SKAction.runBlock { spawnPipes() }
//        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
//        let spawnThenDelay = SKAction.sequence([spawn, delay])
//        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
//        self.runAction(spawnThenDelayForever)
//        
//      }
//    }

    
    // spawn the pipes
    let spawn = SKAction.runBlock {
      let pipePair = SKNode()
      pipePair.position = CGPoint( x: self.frame.size.width + self.pipeTextureUp.size().width * 2, y:0)
      pipePair.zPosition = -10
      
      let height = UInt32( UInt(self.frame.size.height / 4) )
      let y = arc4random() % height + height
      
      let pipeDown = SKSpriteNode(texture: self.pipeTextureDown)
      pipeDown.setScale(2.0)
      pipeDown.position = CGPoint(x:0.0, y:CGFloat(Double(y)) + pipeDown.size.height + CGFloat(self.verticalPipeGap))
      
      pipeDown.addComponent(
        Physical(collisionsAs: self.pipeCategory,
                 collisionsWith: self.birdCategory,
                 dynamic: false,
                 shape: .Rectangle(pipeDown.size)
        )
      )
      
      pipePair.addChild(pipeDown)
      
      let pipeUp = SKSpriteNode(texture: self.pipeTextureUp)
      pipeUp.setScale(2.0)
      pipeUp.position = CGPointMake(0.0, CGFloat(Double(y)))
      
      pipeUp.addComponent(
        Physical(collisionsAs: self.pipeCategory,
          collisionsWith: self.birdCategory,
          dynamic: false,
          shape: .Rectangle(pipeUp.size)
        )
      )
      pipePair.addChild(pipeUp)
      
      var contactNode = SKNode()
      contactNode.position = CGPoint(x:pipeDown.size.width + self.bird.size.width / 2, y:CGRectGetMidY( self.frame ) )
      
      contactNode.addComponent(
        Physical(collisionsAs: self.scoreCategory,
          contactWith: self.birdCategory,
          dynamic: false,
          shape: .Rectangle(CGSizeMake( pipeUp.size.width, self.frame.size.height ))
        )
      )
      
      
      pipePair.addChild(contactNode)
      
      pipePair.addComponent(ObstacleMoving(width: self.pipeTextureUp.size().width))
      self.pipes.addChild(pipePair)

    }
    let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
    let spawnThenDelay = SKAction.sequence([spawn, delay])
    let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
    self.runAction(spawnThenDelayForever)
    
    
    
    
    
    // setup our bird
    let birdTexture1 = SKTexture(imageNamed: "bird-01")
    birdTexture1.filteringMode = .Nearest
    let birdTexture2 = SKTexture(imageNamed: "bird-02")
    birdTexture2.filteringMode = .Nearest
    let birdTexture3 = SKTexture(imageNamed: "bird-03")
    birdTexture2.filteringMode = .Nearest
    let birdTexture4 = SKTexture(imageNamed: "bird-04")
    birdTexture2.filteringMode = .Nearest
    
    
    
    self.bird = SKSpriteNode()
    self.bird.setScale(2.0)
    self.bird.position = CGPoint(x: self.scene!.frame.size.width * 0.35, y:self.scene!.frame.size.height * 0.6)

    self.bird.addComponent(Texturing(texture: birdTexture1))
    self.bird.addComponent(Rotating())
    self.bird.addComponent(Flapping())
    self.bird.addComponent(RepeatAnimating(textures: [birdTexture1, birdTexture2, birdTexture3, birdTexture4], timePerFrame: 0.2))
    
    
    self.bird.addComponent(
      Physical(collisionsAs: birdCategory,
               collisionsWith: worldCategory | pipeCategory,
               contactWith: worldCategory | pipeCategory,
               dynamic:true,
               shape:.Circle(50))
    )
    
    
    self.addChild(bird)
    
    // create the ground
    var ground = SKSpriteNode()
    ground.position = CGPoint(x:0, y:groundTexture.size().height)
    ground.size = groundTexture.size()
    ground.addComponent(
      Physical(collisionsAs: worldCategory,
        collisionsWith: birdCategory,
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
    bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
    bird.speed = 1.0
    bird.zRotation = 0.0
    
    // Remove all existing pipes
    pipes.removeAllChildren()
    
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
      if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
        // Bird has contact with score entity
        score++
        scoreLabelNode.text = String(score)
        
        // Add a little visual feedback for the score increment
        scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
      }
      else {
        
        
        self.bird.removeComponentWithClass(Flapping.self)
        moving.speed = 0
        
        bird.physicsBody?.collisionBitMask = worldCategory
        bird.runAction(  SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{self.bird.speed = 0 })
        
        
        // Flash background if contact is detected
        self.removeActionForKey("flash")
        self.runAction(SKAction.sequence([SKAction.repeatAction(SKAction.sequence([SKAction.runBlock({
          self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        }),SKAction.waitForDuration(NSTimeInterval(0.05)), SKAction.runBlock({
          //          self.backgroundColor = self.skyColor
        }), SKAction.waitForDuration(NSTimeInterval(0.05))]), count:4), SKAction.runBlock({
          self.canRestart = true
        })]), withKey: "flash")
      }
    }
  }
}
