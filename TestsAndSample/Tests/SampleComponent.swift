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
  var assertionDidChangeSceneSizedFrom:CGSize? = nil
  var assertionDidMoveToView:SKView? = nil
  var assertionWillMoveFromView:SKView? = nil
  var assertionDidUpdate:NSTimeInterval? = nil
  var assertionDidEvaluateActions = false
  var assertionDidSimulatePhysics = false
  var assertionDidApplyConstraints = false
  var assertionDidFinishUpdate = false
  var assertionDidBeginContactWithNode:(node:SKNode, contact:SKPhysicsContact)? = nil
  var assertionDidEndContactWithNode:(node:SKNode, contact:SKPhysicsContact)? = nil
  var assertionDidBeginContact:SKPhysicsContact? = nil
  var assertionDidEndContact:SKPhysicsContact? = nil
  
  
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
  func didBeginContactWithNode(node:SKNode, contact:SKPhysicsContact) {
    self.assertionDidBeginContactWithNode = (node:node, contact:contact)
  }
  func didEndContactWithNode(node:SKNode, contact:SKPhysicsContact) {
    self.assertionDidEndContactWithNode = (node:node, contact:contact)
  }
  func didBeginContact(contact:SKPhysicsContact) {
    self.assertionDidBeginContact = contact
  }
  func didEndContact(contact:SKPhysicsContact) {
    self.assertionDidEndContact = contact
  }
  func touchesBegan(touches: [UITouch], withEvent event: UIEvent) {
    
  }


}
