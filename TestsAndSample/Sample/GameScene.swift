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
  var movePipesAndRemove:SKAction!
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
    canRestart = false
    
    // setup physics
    self.addComponent(Gravitating())
    
    //Setup background color
    self.addComponent(Skying())
    
    
    
    moving = SKNode()
    self.addChild(moving)
    pipes = SKNode()
    moving.addChild(pipes)
    
    // ground
    let groundTexture = SKTexture(imageNamed: "land")
    groundTexture.filteringMode = .Nearest // shorter form for SKTextureFilteringMode.Nearest
    // skyline
    let skyTexture = SKTexture(imageNamed: "sky")
    skyTexture.filteringMode = .Nearest
    
  
    
    self.moving.addComponent(GroundMoving(texture: groundTexture))
    self.moving.addComponent(SkyMoving(texture: skyTexture, aboveGroundTexture:groundTexture))
    
    // create the pipes textures
    pipeTextureUp = SKTexture(imageNamed: "PipeUp")
    pipeTextureUp.filteringMode = .Nearest
    pipeTextureDown = SKTexture(imageNamed: "PipeDown")
    pipeTextureDown.filteringMode = .Nearest
    
    // create the pipes movement actions
    let distanceToMove = CGFloat(self.scene!.frame.size.width + 2.0 * pipeTextureUp.size().width)
    let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
    let removePipes = SKAction.removeFromParent()
    movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
    
    // spawn the pipes
    let spawn = SKAction.runBlock { self.spawnPipes() }
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
    
    
    
    bird = SKSpriteNode()
    bird.addComponent(Texturing(texture: birdTexture1))
    bird.addComponent(Rotating())
    bird.addComponent(Flapping(level: moving))
    bird.addComponent(RepeatAnimating(textures: [birdTexture1, birdTexture2, birdTexture3, birdTexture4], timePerFrame: 0.2))
    
    bird.setScale(2.0)
    bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
    
    bird.addComponent(
      Physical(collisionsAs: birdCategory,
               collisionsWith: worldCategory | pipeCategory,
               dynamic:true,
               shape:.Circle)
    )
    
    
    self.addChild(bird)
    
    // create the ground
    var ground = SKSpriteNode()
    ground.position = CGPointMake(0, groundTexture.size().height)
    ground.size = groundTexture.size()
    ground.addComponent(
      Physical(collisionsAs: worldCategory,
        collisionsWith: birdCategory,
        dynamic:false,
        shape:.Rectangle)
    )

//    ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
//    ground.physicsBody?.dynamic = false
//    ground.physicsBody?.categoryBitMask = worldCategory
    self.addChild(ground)
    
    // Initialize label and create a label which holds the score
    score = 0
    scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
    scoreLabelNode.position = CGPointMake( CGRectGetMidX( self.frame ), 3 * self.frame.size.height / 4 )
    scoreLabelNode.zPosition = 100
    scoreLabelNode.text = String(score)
    self.addChild(scoreLabelNode)
    
  }
  
  func spawnPipes() {
    let pipePair = SKNode()
    pipePair.position = CGPointMake( self.frame.size.width + pipeTextureUp.size().width * 2, 0 )
    pipePair.zPosition = -10
    
    let height = UInt32( UInt(self.frame.size.height / 4) )
    let y = arc4random() % height + height
    
    let pipeDown = SKSpriteNode(texture: pipeTextureDown)
    pipeDown.setScale(2.0)
    pipeDown.position = CGPointMake(0.0, CGFloat(Double(y)) + pipeDown.size.height + CGFloat(verticalPipeGap))
    
    
    pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
    pipeDown.physicsBody?.dynamic = false
    pipeDown.physicsBody?.categoryBitMask = pipeCategory
    pipeDown.physicsBody?.contactTestBitMask = birdCategory
    pipePair.addChild(pipeDown)
    
    let pipeUp = SKSpriteNode(texture: pipeTextureUp)
    pipeUp.setScale(2.0)
    pipeUp.position = CGPointMake(0.0, CGFloat(Double(y)))
    
    pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
    pipeUp.physicsBody?.dynamic = false
    pipeUp.physicsBody?.categoryBitMask = pipeCategory
    pipeUp.physicsBody?.contactTestBitMask = birdCategory
    pipePair.addChild(pipeUp)
    
    var contactNode = SKNode()
    contactNode.position = CGPointMake( pipeDown.size.width + bird.size.width / 2, CGRectGetMidY( self.frame ) )
    contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( pipeUp.size.width, self.frame.size.height ))
    contactNode.physicsBody?.dynamic = false
    contactNode.physicsBody?.categoryBitMask = scoreCategory
    contactNode.physicsBody?.contactTestBitMask = birdCategory
    pipePair.addChild(contactNode)
    
    pipePair.runAction(movePipesAndRemove)
    pipes.addChild(pipePair)
    
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
      } else {
        
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
