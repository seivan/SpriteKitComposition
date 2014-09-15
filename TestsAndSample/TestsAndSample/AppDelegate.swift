//
//  AppDelegate.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 29/06/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import UIKit
import SpriteKit



class MyScene : SKScene {
  override func update(currentTime: NSTimeInterval) {
//    super.update(currentTime)
  }
}


class Movement : Component {
  var isEnabled:Bool = true
  weak var node:SKNode?
  func didAddToNode() {
    println("didAddToNode Movement \(self.node?.name)")
  }
  func didRemoveFromNode() {
    println("didRemoveFromNode Movement \(self.node?.name)")
  }
  
  func didAddNodeToScene() {
    println("didAddNodeToScene Movement \(self.node?.name) and scene \(self.node?.scene?.name)")
    
  }
  
  func didRemoveNodeFromScene() {
    println("didRemoveNodeFromScene Movement \(self.node?.name)")
  }
  func didUpdate(time:NSTimeInterval) {
    println("didUpdate \(time) Movement \(self.node?.name)")
  }
  func didChangeSceneSizedFrom(previousSize:CGSize) {
    println("didChangeSceneSizedFrom \(previousSize) Movement \(self.node?.name)")
  }
  func didEvaluateActions() {
    println("didEvaluateActions Movement \(self.node?.name)")
  }
  func didSimulatePhysics() {
    println("didSimulatePhysics Movement \(self.node?.name)")
  }
  func didBeginContact(contact:SKPhysicsContact) {
    println("didBeginContact \(contact) Movement \(self.node?.name)")
  }
  func didEndContact(contact:SKPhysicsContact) {
    println("didEndContact \(contact) Movement \(self.node?.name)")
  }
  
}


class Life :  Component {
  var isEnabled:Bool = true
  weak var node:SKNode?
  func didAddToNode() {
    println("didAddToNode LIVING \(self.node?.name)")
  }
  func didRemoveFromNode() {
    println("didRemoveFromNode LIVING \(self.node?.name)")
  }

  func didAddNodeToScene() {
    println("didAddNodeToScene LIVING \(self.node?.name) and scene \(self.node?.scene?.name)")
  }

  func didRemoveNodeFromScene() {
    println("didRemoveNodeFromScene LIVING \(self.node?.name)")
  }
  func didUpdate(time:NSTimeInterval) {
    println("didUpdate \(time) LIVING  \(self.node?.name)")
  }
  func didChangeSceneSizedFrom(previousSize:CGSize) {
    println("didChangeSceneSizedFrom \(previousSize) LIVING \(self.node?.name)")
  }
  func didEvaluateActions() {
    println("didEvaluateActions LIVING \(self.node?.name)")
  }
  func didSimulatePhysics() {
    println("didSimulatePhysics LIVING \(self.node?.name)")
  }
  func didBeginContact(contact:SKPhysicsContact) {
    println("didBeginContact \(contact) LIVING \(self.node?.name)")
  }
  func didEndContact(contact:SKPhysicsContact) {
    println("didEndContact \(contact) LIVING \(self.node?.name)")
  }

  
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?


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
//    skView.showsFPS = true
//    skView.showsNodeCount = true
//    skView.showsDrawCount = true
//    skView.showsQuadCount = true
//    skView.showsPhysics = true
//    skView.showsFields = true
//    skView.setValue(NSNumber(bool: true), forKey: "_showsCulledNodesInNodeCount")
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = .AspectFill
    scene.name = "MAAAAAAAAAAIn"
    skView.presentScene(scene)
    self.window?.rootViewController = controller
    
    
    


    
    let gun = SKNode()
    gun.name = "GUN"
    let player = SKNode()
    player.name = "PLAYER"
    
    let life = Life()
    let movement = Movement()

    player.addComponent(life, withKey:"Living")
    gun.addComponent(Life())
    player.addChild(gun)
    
    
    scene.insertChild(player, atIndex: 0)

    scene.removeChildrenInArray([player])
//    scene.insertChild(player, atIndex: 0)
    let g = SKScene()
    g.name = "GGGGGGGGGGG"
//    skView.presentScene(g)
//     g.addChild(player)

//    scene.insertChild(player, atIndex: 0)
//    scene.removeChildrenInArray([player])
    
    
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

