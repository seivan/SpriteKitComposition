//
//  AppDelegate.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 29/06/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import UIKit
import SpriteKit


class Player : SKSpriteNode {


  override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
    super.init(texture:texture, color:color, size:size)
  }
  
  init(color: UIColor!, size: CGSize) {
    super.init()
    self.color = color
    self.size = size
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  

  
  func didEndContact(contact: SKPhysicsContact) {
    println("DID END CONTACT")
  }
  
}

//color: UIColor.blueColor(), size: CGSize(width: 40, height: 40))

class Toucher : Component {

  func didAddToNode() {
    self.node?.userInteractionEnabled = true
  }

  func touchesBegan(touches: [UITouch], withEvent event: UIEvent) {
    println("TOUCH \(self.node?.name)")
  }
}


class MyScene : SKScene {
  override func update(currentTime: NSTimeInterval) {
    super.update(currentTime)
  }
  override func didEvaluateActions() {
    super.didEvaluateActions()
  }
  override func didSimulatePhysics() {
    super.didSimulatePhysics()
  }
  override func didFinishUpdate() {
    super.didSimulatePhysics()
  }
  override func didEndContact(contact: SKPhysicsContact) {
    super.didEndContact(contact)
  }

 
}

class SceneDebugger : Component {
  func didAddToNode() {
    let skView = (self.node as SKScene).view
    skView?.showsFPS       = true
    skView?.showsNodeCount = true
    skView?.showsDrawCount = true
    skView?.showsQuadCount = true
    skView?.showsPhysics   = true
    skView?.showsFields    = true
    skView?.setValue(NSNumber(bool: true), forKey: "_showsCulledNodesInNodeCount")
//    skView?.multipleTouchEnabled = true
  }
}

class Sample : Component {
  
  func didAddToNode() {
    println("didAddToNode \(self.node?.name) & \(self.node?.scene?.name)")
  }
  
  func didAddNodeToScene() {
    println("didAddNodeToScene \(self.node?.scene?.name) & \(self.node?.scene?.name)")

  }
  
  func didRemoveFromNode() {
    println("didRemoveFromNode \(self.node?.name) & \(self.node?.scene?.name)")

  }
  
  func didRemoveNodeFromScene() {
    println("didRemoveNodeFromScene \(self.node?.name) & \(self.node?.scene?.name)")
  }
  
  func didChangeSceneSizedFrom(previousSize:CGSize) {
    
  }
  
  func didMoveToView(view: SKView) {
    println("didMoveToView \(self.node?.name)")
  }
  
  func willMoveFromView(view: SKView) {
    println("willMoveFromView \(self.node?.name)")
  }
  
  func didUpdate(time:NSTimeInterval) {
//    println("didUpdate \(time)")
//    self.isEnabled = false
  }

  
  func didContactOnScene(contact:SKPhysicsContact, state:ComponentState) {
    
  }
  func didContactWithNode(node:SKNode, contact:SKPhysicsContact, state:ComponentState) {
    
  }
  
  func didTouchOnScene(touches:[UITouch], state:ComponentState) {
    println(state)
  }
  
  func didTouchOnNode(touches:[UITouch], state:ComponentState) {
    println(state)
  }


}




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?


  func fuck(t:UIPanGestureRecognizer) {
    print(t)
  }
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    let controller = UIViewController()
    controller.view = SKView(frame: controller.view.frame)
    // Configure the view.
    let scene = MyScene(size: controller.view.frame.size)
    let skView = controller.view as SKView
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = .AspectFill
    scene.name = "MAAAAAAAAAAIn"
    skView.presentScene(scene)
    self.window?.rootViewController = controller
    let enemy = Player(color: UIColor.redColor(), size: CGSize(width: 40, height: 40))
    enemy.name = "ENEMY"
    let player = Player(color: UIColor.blueColor(), size:  CGSize(width: 40, height: 40))
    player.name = "PLAYER"
    let gun = Player(color: UIColor.orangeColor(), size:  CGSize(width: 20, height: 20))
    gun.name = "GUN"
    player.position = CGPoint(x: 100, y: 100)

    

//    player.addChild(gun)

    
//    scene.addComponent(SceneDebugger())
//    
//    scene.addChild(enemy)

    let sample = Sample()
    gun.addComponent(sample)
    
    player.addChild(gun)
    scene.addChild(player)

    var delay = 1.0 * Double(NSEC_PER_SEC)
    var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    dispatch_after(time, dispatch_get_main_queue()) {
      gun.removeFromParent()
      sample.removeFromNode()
      return
    }

    
    var delayX = 2 * Double(NSEC_PER_SEC)
    var timeX = dispatch_time(DISPATCH_TIME_NOW, Int64(delayX))
    dispatch_after(timeX, dispatch_get_main_queue()) {
      player.addChild(gun)
      gun.addComponent(sample)
      
    }

    var delayXZ = 3 * Double(NSEC_PER_SEC)
    var timeXZ = dispatch_time(DISPATCH_TIME_NOW, Int64(delayXZ))
    dispatch_after(timeXZ, dispatch_get_main_queue()) {
      sample.isEnabled = true
    }



//   player.removeFromParent()
//   gun.removeComponentWithClass(Sample.self)
//    sample.removeFromNode()


    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

