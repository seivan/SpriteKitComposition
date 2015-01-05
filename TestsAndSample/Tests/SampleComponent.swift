//
//  SampleComponent.swift
//  TestsAndSample
//
//  Created by Seivan Heidari on 26/11/14.
//  Copyright (c) 2014 Seivan Heidari. All rights reserved.
//

import UIKit
import SpriteKit

class SampleComponent: Component {
  var assertionDidAddToNode:SKNode! = nil
  var assertionDidAddNodeToScene:SKScene! = nil
  var assertionDidRemoveFromNode:SKNode! = nil
  var assertionDidRemoveNodeFromScene:SKScene! = nil
  var assertionDidChangeSceneSizedFrom:CGSize! = nil
  var assertionDidMoveToView:SKView! = nil
  var assertionWillMoveFromView:SKView! = nil
  var assertionDidUpdate:NSTimeInterval! = nil
  var assertionDidEvaluateActions = false
  var assertionDidSimulatePhysics = false
  var assertionDidApplyConstraints = false
  var assertionDidFinishUpdate = false
  
  var assertionDidContactSceneStarted:(contact:SKPhysicsContact, state:ComponentState)! = nil
  var assertionDidContactSceneCompleted:(contact:SKPhysicsContact, state:ComponentState)! = nil
  
  var assertionDidContactNodeStarted:(node:SKNode, contact:SKPhysicsContact, state:ComponentState)! = nil
  var assertionDidContactNodeCompleted:(node:SKNode, contact:SKPhysicsContact, state:ComponentState)! = nil

  var assertionDidTouchSceneStarted:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchSceneChanged:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchSceneCompleted:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchSceneCancelled:(touches:[UITouch], state:ComponentState)! = nil
  
  var assertionDidTouchNodeStarted:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchNodeChanged:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchNodeCompleted:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchNodeCancelled:(touches:[UITouch], state:ComponentState)! = nil
  
  
  var assertionDidEnable:Bool = false
  
  
  
//  var assertionDidBeginContactWithNode:(node:SKNode, contact:SKPhysicsContact)! = nil
//  var assertionDidEndContactWithNode:(node:SKNode, contact:SKPhysicsContact)! = nil
//  var assertionDidBeginContact:SKPhysicsContact! = nil
//  var assertionDidEndContact:SKPhysicsContact! = nil
//
//  var assertionDidBeginNodeTouches:[UITouch]! = nil
//  var assertionDidMoveNodeTouches:[UITouch]! = nil
//  var assertionDidEndNodeTouches:[UITouch]! = nil
//  var assertionDidCancelNodeTouches:[UITouch]! = nil
//  var assertionDidBeginSceneTouches:[UITouch]! = nil
//  var assertionDidMoveSceneTouches:[UITouch]! = nil
//  var assertionDidEndSceneTouches:[UITouch]! = nil
//  var assertionDidCancelSceneTouches:[UITouch]! = nil
  
  
  
  func didAddToNode(node:SKNode) {
    self.assertionDidAddToNode = node
  }
  func didAddNodeToScene(scene:SKScene) {
    self.assertionDidAddNodeToScene = scene
  }
  func didRemoveFromNode(node:SKNode) {
    self.assertionDidRemoveFromNode = node
  }
  func didRemoveNodeFromScene(scene:SKScene) {
    self.assertionDidRemoveNodeFromScene = scene
  }
  func didChangeSceneSizedFrom(previousSize:CGSize) {
    self.assertionDidChangeSceneSizedFrom = previousSize
  }
  func didMoveToView(view: SKView) {
    self.assertionDidMoveToView = view
  }
  func willMoveFromView(view: SKView) {
    self.assertionWillMoveFromView = view
  }
  func didUpdate(time:NSTimeInterval) {
    self.assertionDidUpdate = time
  }
  func didEvaluateActions() {
    self.assertionDidEvaluateActions = true
  }
  func didSimulatePhysics() {
    self.assertionDidSimulatePhysics = true
  }
  func didApplyConstraints() {
    self.assertionDidApplyConstraints = true
  }
  func didFinishUpdate() {
    self.assertionDidFinishUpdate = true
  }
  
  func didContactScene(contact:SKPhysicsContact, state:ComponentState) {
    switch state.value {
    case ComponentState.Started.value:
      self.assertionDidContactSceneStarted = (contact:contact, state:state)
    case ComponentState.Completed.value:
      self.assertionDidContactSceneCompleted = (contact:contact, state:state)
    default:
      self.assertionDidContactSceneCompleted = nil
      self.assertionDidContactSceneStarted = nil
    }
    
  }
  func didContactNode(node:SKNode, contact:SKPhysicsContact, state:ComponentState) {
    switch state.value {
    case ComponentState.Started.value:
      self.assertionDidContactNodeStarted = (node:node, contact:contact, state:state)
    case ComponentState.Completed.value:
      self.assertionDidContactNodeCompleted = (node:node, contact:contact, state:state)
    default:
      self.assertionDidContactNodeStarted = (node:node, contact:contact, state:state)
      self.assertionDidContactNodeCompleted = (node:node, contact:contact, state:state)
    }

  }
  func didTouchScene(touches:[UITouch], state:ComponentState) {
    switch state.value {
    case ComponentState.Started.value:
      self.assertionDidTouchSceneStarted = (touches:touches, state:state)
    case ComponentState.Changed.value:
      self.assertionDidTouchSceneChanged = (touches:touches, state:state)
    case ComponentState.Completed.value:
      self.assertionDidTouchSceneCompleted = (touches:touches, state:state)
    case ComponentState.Cancelled.value:
      self.assertionDidTouchSceneCancelled = (touches:touches, state:state)
    default:
     self.assertionDidTouchSceneStarted   = nil
     self.assertionDidTouchSceneChanged   = nil
     self.assertionDidTouchSceneCompleted = nil
     self.assertionDidTouchSceneCancelled = nil
    }

  }
  func didTouchNode(touches:[UITouch], state:ComponentState) {
    switch state.value {
    case ComponentState.Started.value:
      self.assertionDidTouchNodeStarted = (touches:touches, state:state)
    case ComponentState.Changed.value:
      self.assertionDidTouchNodeChanged = (touches:touches, state:state)
    case ComponentState.Completed.value:
      self.assertionDidTouchNodeCompleted = (touches:touches, state:state)
    case ComponentState.Cancelled.value:
      self.assertionDidTouchNodeCancelled = (touches:touches, state:state)
    default:
      self.assertionDidTouchNodeStarted   = nil
      self.assertionDidTouchNodeChanged   = nil
      self.assertionDidTouchNodeCompleted = nil
      self.assertionDidTouchNodeCancelled = nil
    }
    
  }
  
  func didEnable(isEnabled:Bool) {
    self.assertionDidEnable = isEnabled
  }
  

}
