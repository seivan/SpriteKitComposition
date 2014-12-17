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
  var assertionDidAddToNode = false
  var assertionDidAddNodeToScene = false
  var assertionDidRemoveFromNode = false
  var assertionDidRemoveNodeFromScene = false
  var assertionDidChangeSceneSizedFrom:CGSize! = nil
  var assertionDidMoveToView:SKView! = nil
  var assertionWillMoveFromView:SKView! = nil
  var assertionDidUpdate:NSTimeInterval! = nil
  var assertionDidEvaluateActions = false
  var assertionDidSimulatePhysics = false
  var assertionDidApplyConstraints = false
  var assertionDidFinishUpdate = false
  
  var assertionDidContactOnSceneStarted:(contact:SKPhysicsContact, state:ComponentState)! = nil
  var assertionDidContactOnSceneCompleted:(contact:SKPhysicsContact, state:ComponentState)! = nil
  
  var assertionDidContactWithNodeStarted:(node:SKNode, contact:SKPhysicsContact, state:ComponentState)! = nil
  var assertionDidContactWithNodeCompleted:(node:SKNode, contact:SKPhysicsContact, state:ComponentState)! = nil

  var assertionDidTouchOnSceneStarted:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchOnSceneChanged:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchOnSceneCompleted:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchOnSceneCancelled:(touches:[UITouch], state:ComponentState)! = nil
  
  var assertionDidTouchOnNodeStarted:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchOnNodeChanged:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchOnNodeCompleted:(touches:[UITouch], state:ComponentState)! = nil
  var assertionDidTouchOnNodeCancelled:(touches:[UITouch], state:ComponentState)! = nil
  
  
  
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
  
  
  
  func didAddToNode() {
    self.assertionDidAddToNode = true
  }
  func didAddNodeToScene() {
    self.assertionDidAddNodeToScene = true
  }
  func didRemoveFromNode() {
    self.assertionDidRemoveFromNode = true
  }
  func didRemoveNodeFromScene() {
    self.assertionDidRemoveNodeFromScene = true
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
  
  func didContactOnScene(contact:SKPhysicsContact, state:ComponentState) {
    switch state.value {
    case ComponentState.Started.value:
      self.assertionDidContactOnSceneStarted = (contact:contact, state:state)
    case ComponentState.Completed.value:
      self.assertionDidContactOnSceneCompleted = (contact:contact, state:state)
    default:
      self.assertionDidContactOnSceneCompleted = nil
      self.assertionDidContactOnSceneStarted = nil
    }
    
  }
  func didContactWithNode(node:SKNode, contact:SKPhysicsContact, state:ComponentState) {
    switch state.value {
    case ComponentState.Started.value:
      self.assertionDidContactWithNodeStarted = (node:node, contact:contact, state:state)
    case ComponentState.Completed.value:
      self.assertionDidContactWithNodeCompleted = (node:node, contact:contact, state:state)
    default:
      self.assertionDidContactWithNodeStarted = (node:node, contact:contact, state:state)
      self.assertionDidContactWithNodeCompleted = (node:node, contact:contact, state:state)
    }

  }
  func didTouchOnScene(touches:[UITouch], state:ComponentState) {
    switch state.value {
    case ComponentState.Started.value:
      self.assertionDidTouchOnSceneStarted = (touches:touches, state:state)
    case ComponentState.Changed.value:
      self.assertionDidTouchOnSceneChanged = (touches:touches, state:state)
    case ComponentState.Completed.value:
      self.assertionDidTouchOnSceneCompleted = (touches:touches, state:state)
    case ComponentState.Cancelled.value:
      self.assertionDidTouchOnSceneCancelled = (touches:touches, state:state)
    default:
     self.assertionDidTouchOnSceneStarted   = nil
     self.assertionDidTouchOnSceneChanged   = nil
     self.assertionDidTouchOnSceneCompleted = nil
     self.assertionDidTouchOnSceneCancelled = nil
    }

  }
  func didTouchOnNode(touches:[UITouch], state:ComponentState) {
    switch state.value {
    case ComponentState.Started.value:
      self.assertionDidTouchOnNodeStarted = (touches:touches, state:state)
    case ComponentState.Changed.value:
      self.assertionDidTouchOnNodeChanged = (touches:touches, state:state)
    case ComponentState.Completed.value:
      self.assertionDidTouchOnNodeCompleted = (touches:touches, state:state)
    case ComponentState.Cancelled.value:
      self.assertionDidTouchOnNodeCancelled = (touches:touches, state:state)
    default:
      self.assertionDidTouchOnNodeStarted   = nil
      self.assertionDidTouchOnNodeChanged   = nil
      self.assertionDidTouchOnNodeCompleted = nil
      self.assertionDidTouchOnNodeCancelled = nil
    }
    
  }
  

}
