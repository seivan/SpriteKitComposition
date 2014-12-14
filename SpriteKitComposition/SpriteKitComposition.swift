import SpriteKit

@objc private protocol ComponentBehaviour {
  optional func didAddToNode()
  optional func didAddNodeToScene()
  
  optional func didRemoveFromNode()
  optional func didRemoveNodeFromScene()
  
  optional func didChangeSceneSizedFrom(previousSize:CGSize)
  optional func didMoveToView(view: SKView)
  optional func willMoveFromView(view: SKView)
  
  
  //if isEnabled
  optional func didUpdate(time:NSTimeInterval)
  optional func didEvaluateActions()
  optional func didSimulatePhysics()
  optional func didApplyConstraints()
  optional func didFinishUpdate()
  
  optional func didBeginContactWithNode(node:SKNode, contact:SKPhysicsContact)
  optional func didEndContactWithNode(node:SKNode, contact:SKPhysicsContact)
  
  optional func didBeginContact(contact:SKPhysicsContact)
  optional func didEndContact(contact:SKPhysicsContact)
  
  optional func touchesBegan(touches: [UITouch], withEvent event: UIEvent)
}

private struct __HubCollection {
  static let timeInterval = NotificationHub<CFTimeInterval>()
  static let node         = NotificationHub<SKNode>()
  static let size         = NotificationHub<CGSize>()
  static let view         = NotificationHub<SKView>()
  static let contact      = NotificationHub<SKPhysicsContact>()
  static let nodeContact  = NotificationHub<(SKNode, contact:SKPhysicsContact)>()
}

@objc public class Component : ComponentBehaviour  {
  private struct ObserverCollection {
    var updated:Notification<CFTimeInterval>?
    var size:Notification<CGSize>?
    var empty        = [Notification<SKNode>]()
    var view         = [Notification<SKView>]()
    var contact      = [Notification<SKPhysicsContact>]()
    var nodeContact  = [Notification<(SKNode, contact:SKPhysicsContact)>]()
    
    init(){}
    func removeAll() {
      self.updated?.remove()
      self.size?.remove()
      for observer in self.empty       { observer.remove() }
      for observer in self.contact     { observer.remove() }
      for observer in self.nodeContact { observer.remove() }
      for observer in self.view { observer.remove() }

    }
    
  }
  
  private var observerCollection = ObserverCollection()

  var isEnabled:Bool = true {
    willSet {
      self._removeObservers()
      if newValue == true && self.node?.scene != nil { self._addObservers() }
    }
  }
  private(set) weak var node:SKNode? {
    willSet { if newValue  == nil { self._didRemoveFromNode() } }
    didSet  {
      if self.node != nil { self._didAddToNode() }
    }
  }
  
  init(){}
  
  final func removeFromNode() -> Bool {
    if let n = self.node { return n.removeComponent(self) }
    else { return false }
    
  }
  
  final private func _addObservers() {
//    if let scene = self.node!.scene {
      let b = (self as ComponentBehaviour)
      let scene = self.node!.scene!
    
      if let didChangeSceneSizedFrom = b.didChangeSceneSizedFrom {
        self.observerCollection.size = __HubCollection.size.subscribeNotificationForName("didChangeSceneSizedFrom", sender: scene) {
          n in didChangeSceneSizedFrom(n.userInfo!)
        }
        
      }
      
      if let didMoveToView = b.didMoveToView {
        self.observerCollection.view.append(__HubCollection.view.subscribeNotificationForName("didMoveToView", sender: scene) {
          n in didMoveToView(n.userInfo!)
          })
      }
      
      if let willMoveFromView = b.willMoveFromView {
        self.observerCollection.view.append(__HubCollection.view.subscribeNotificationForName("willMoveFromView", sender: scene) {
          n in willMoveFromView(n.userInfo!)
          })
      }
      
      if let didUpdate = b.didUpdate {
        self.observerCollection.updated = __HubCollection.timeInterval.subscribeNotificationForName("didUpdate", sender: scene) {
          n in didUpdate(n.userInfo!)
        }
      }
      
      if let didEvaluateActions =  b.didEvaluateActions {
        self.observerCollection.empty.append(
          __HubCollection.node.subscribeNotificationForName("didEvaluateActions", sender: scene) {
            n in didEvaluateActions()
          })
      }
      
      if let didSimulatePhysics = b.didSimulatePhysics? {
        self.observerCollection.empty.append(
          __HubCollection.node.subscribeNotificationForName("didSimulatePhysics", sender: scene) {
            n in didSimulatePhysics()
          })
      }
      
      if let didApplyConstraints = b.didApplyConstraints? {
        self.observerCollection.empty.append(
          __HubCollection.node.subscribeNotificationForName("didApplyConstraints", sender: scene) {
            n in didApplyConstraints()
          })
      }
      
      if let didFinishUpdate = b.didFinishUpdate {
        self.observerCollection.empty.append(
          __HubCollection.node.subscribeNotificationForName("didFinishUpdate", sender: scene) {
            n in didFinishUpdate()
          })
      }
      
      if let didBeginContact = b.didBeginContact {
        self.observerCollection.contact.append(
          __HubCollection.contact.subscribeNotificationForName("didBeginContact", sender: scene) {
            n in didBeginContact(n.userInfo!)
          })
      }
      
      if let didEndContact = b.didEndContact {
        self.observerCollection.contact.append(
          __HubCollection.contact.subscribeNotificationForName("didEndContact", sender: scene) {
            n in didEndContact(n.userInfo!)
          })
      }
      
      if let didBeginContactWithNode =  b.didBeginContactWithNode {
        self.observerCollection.nodeContact.append(
          __HubCollection.nodeContact.subscribeNotificationForName("didBeginContactWithNode", sender: self.node) {
            n in didBeginContactWithNode(n.userInfo!)
          })
      }
      
      if let didEndContactWithNode = b.didEndContactWithNode {
        self.observerCollection.nodeContact.append(
          __HubCollection.nodeContact.subscribeNotificationForName("didEndContactWithNode", sender: self.node) {
            n in didEndContactWithNode(n.userInfo!)
          })
      }
//    }
    
    
    
  }
  
  
  final private func _didAddToNode() {
    (self as ComponentBehaviour).didAddToNode?()
    if self.node?.scene != nil { self._didAddNodeToScene() }
    
  }
  final private func _didAddNodeToScene() {
    (self as ComponentBehaviour).didAddNodeToScene?()
    if(self.isEnabled) { self._addObservers() }
    
  }
  
  final private func _didRemoveFromNode() {
    (self as ComponentBehaviour).didRemoveFromNode?()
    self._removeObservers()

  }
  
  final private func _didRemoveNodeFromScene() {
    (self as ComponentBehaviour).didRemoveNodeFromScene?()
    self._removeObservers()
  }
  
  final private func _removeObservers() {
    self.observerCollection.removeAll()
  }
  
  deinit { self._removeObservers() }
  
}



final private class InternalComponentContainer {
  var components = [String:Component]()
  var lastUpdateTimeInterval:NSTimeInterval = 0
}


extension SKNode {
  final var components:[Component] { return self.componentContainer.components.values.array }
  final var childNodes:[SKNode]    { return self.children as [SKNode]                       }
  
  final func componentWithClass(theClass:AnyClass) -> Component? {
    return self.componentContainer.components[NSStringFromClass(theClass)]
  }
  
  final func componentWithKey(key:String) -> Component? {
    return self.componentContainer.components[key]
  }
  
  final func addComponent<T:Component>(component:T, withKey key:String) -> Bool {
    if self.componentContainer.components[key] == nil {
      self.componentContainer.components[key] = component
      component.node = self
      return true
    }
    else { return false }
    
  }
  
  final func addComponent<T:Component>(component:T) -> Bool {
    let key = NSStringFromClass(component.dynamicType)
    return self.addComponent(component, withKey: key)
  }
  
  final func removeComponentWithClass(theClass:AnyClass) -> Bool {
    let key = NSStringFromClass(theClass)
    return self.removeComponentWithKey(key)
  }
  
  final func removeComponentWithKey(key:String) -> Bool {
    if let componentToRemove = self.componentContainer.components.removeValueForKey(key) {
      componentToRemove.node = nil
      return true
    }
    else { return false }
  }
  
  final func removeComponent<T:Component>(component:T) -> Bool {
    var foundKey:String?
    for (key, value) in self.componentContainer.components {
      if value === component {
        foundKey = key
        break
      }
    }
    if let key = foundKey { return self.removeComponentWithKey(key) }
    else { return false }
  }
  
}

extension SKScene : SKPhysicsContactDelegate {
  
  public func didChangeSize(oldSize: CGSize) {
    __HubCollection.size.publishNotificationName("didChangeSceneSizedFrom", sender: self, userInfo:oldSize)
  }
  
  public func didMoveToView(view: SKView) {
    self.physicsWorld.contactDelegate = self
    __HubCollection.view.publishNotificationName("didMoveToView", sender: self, userInfo:view)
  }
  
  public func willMoveFromView(view: SKView) {
    __HubCollection.view.publishNotificationName("willMoveFromView", sender: self, userInfo:view)
  }
  
  public func update(currentTime: NSTimeInterval) {
    let container = self.componentContainer
    var timeSinceLast: CFTimeInterval = currentTime - container.lastUpdateTimeInterval
    container.lastUpdateTimeInterval = currentTime
    if  timeSinceLast > 1  {
      timeSinceLast = 1.0 / 60.0
      container.lastUpdateTimeInterval = currentTime
    }
    __HubCollection.timeInterval.publishNotificationName("didUpdate", sender: self, userInfo: timeSinceLast)
  }
  
  public func didEvaluateActions() {
    __HubCollection.node.publishNotificationName("didEvaluateActions", sender: self)
  }
  
  public func didSimulatePhysics() {
    __HubCollection.node.publishNotificationName("didSimulatePhysics", sender: self)
  }
  
  public func didApplyConstraints() {
    __HubCollection.node.publishNotificationName("didApplyConstraints", sender: self)
  }
  
  public func didFinishUpdate() {
    __HubCollection.node.publishNotificationName("didFinishUpdate", sender: self)
  }
  
  
  public func didBeginContact(contact: SKPhysicsContact) {
    __HubCollection.contact.publishNotificationName("didBeginContact", sender: self, userInfo:contact)
    let nodeA = contact.bodyA.node
    let nodeB = contact.bodyB.node
    
    if let nodeA = nodeA {
      __HubCollection.nodeContact.publishNotificationName("didBeginContactWithNode", sender: nodeB, userInfo:(nodeA,contact:contact))
    }
    
    if let nodeB = nodeB {
      __HubCollection.nodeContact.publishNotificationName("didBeginContactWithNode", sender: nodeA, userInfo:(nodeB,contact:contact))
    }
  }
  
  public func didEndContact(contact: SKPhysicsContact) {
    __HubCollection.contact.publishNotificationName("didEndContact", sender: self, userInfo:contact)
    let nodeA = contact.bodyA.node
    let nodeB = contact.bodyB.node
    
    if let nodeA = nodeA {
      __HubCollection.nodeContact.publishNotificationName("didEndContactWithNode", sender: nodeB, userInfo:(nodeA,contact:contact))
    }
    
    if let nodeB = nodeB {
      __HubCollection.nodeContact.publishNotificationName("didEndContactWithNode", sender: nodeA, userInfo:(nodeB,contact:contact))
    }
    
    
  }
  
  
  
}

extension SKNode {
  
  //
  //
  //  final private func internalTouchesBegan(touches: [UITouch], withEvent event: UIEvent) {
  //    for component in self.components { if component.isEnabled { component.touchesBegan?(touches, withEvent: event) } }
  //    //    for child in self.childNodes     { child.internalTouchesBegan(touches, withEvent: event) }
  //
  //  }
  //
  //  override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
  //    let touchesList:[UITouch] = touches.allObjects as [UITouch]
  //    self.internalTouchesBegan(touchesList, withEvent: event)
  //  }
  
}

extension SKNode {
  
  private func _addedChild(node:SKNode) {
//    if self is SKScene {
//      for component in node.components { component._didAddNodeToScene() }
//      for childNode in node.childNodes { node._addedChild(childNode) }
//    }
   if self.scene != nil {
      for component in node.components { component._didAddNodeToScene() }
      for childNode in node.childNodes { node._addedChild(childNode) }
    }
    
  }
  
  
  
  func _addChild(node:SKNode!) {
    if node.parent != self {
      node.removeFromParent()
      self._addChild(node)
      self._addedChild(node);
      
    }
    
  }
  
  func _insertChild(node: SKNode!, atIndex index: Int) {
    if node.parent != self {
      node.removeFromParent()
      self._insertChild(node, atIndex: index)
      self._addedChild(node);
    }
    
  }
  
  private func _removedChild(node:SKNode) {
//    if self is SKScene {
//      for component in node.components { component._didRemoveNodeFromScene() }
//      for childNode in node.childNodes { node._removedChild(childNode) }
//    }
    if self.scene != nil {
      for component in node.components { component._didRemoveNodeFromScene() }
      for childNode in node.childNodes { node._removedChild(childNode) }
    }
    
  }
  
  
  func _removeChildrenInArray(nodes: [AnyObject]!) {
    var nodesAsSKNodes = nodes as [SKNode]
    var childNodesToRemove = [SKNode]()
    for child in self.childNodes {
      if contains(nodesAsSKNodes, child) {
        childNodesToRemove.append(child)
        self._removedChild(child)
      }
    }
    self._removeChildrenInArray(childNodesToRemove)
  }
  
  func _removeAllChildren() {
    for child in self.childNodes { self._removedChild(child) }
    self._removeAllChildren()
  }
  
  func _removeFromParent() {
    self.parent?._removedChild(self)
    self._removeFromParent()
    
  }
  
  
  
  final private var componentContainer:InternalComponentContainer {
    get {
      //      println(SharedComponentManager.sharedInstance.mapTable)
      var manager = SharedComponentManager.sharedInstance.mapTable.objectForKey(self) as InternalComponentContainer?
      if manager == nil {
        manager = InternalComponentContainer()
        SharedComponentManager.sharedInstance.mapTable.setObject(manager!, forKey: self)
      }
      return manager!
    }
    
    //    get {
    //      var manager = objc_getAssociatedObject(self, &AssociatedKeyComponentManager) as ComponentManager?
    //      if(manager == nil) {
    //          manager = ComponentManager()
    //          objc_setAssociatedObject(self, &AssociatedKeyComponentManager, manager, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    //        }
    //      return manager!
    //    }
  }
  
}

final private class SharedComponentManager {
  let mapTable:NSMapTable = NSMapTable(keyOptions: NSPointerFunctionsOpaquePersonality|NSPointerFunctionsWeakMemory, valueOptions: NSPointerFunctionsStrongMemory)
  class var sharedInstance : SharedComponentManager {
    struct Static {
      static var onceToken : dispatch_once_t = 0
      static var instance : SharedComponentManager? = nil
    }
    dispatch_once(&Static.onceToken) {
      
      func swizzleExchangeMethodsOnClass(cls: AnyClass, replaceSelector fromSelector:String, withSelector toSelector:String) {
        var originalMethod: Method?
        var swizzledMethod: Method?
        
        originalMethod = class_getInstanceMethod(SKNode.classForCoder(), Selector(fromSelector))
        swizzledMethod = class_getInstanceMethod(SKNode.classForCoder(), Selector(toSelector))
        
        if originalMethod != nil && swizzledMethod != nil { method_exchangeImplementations(originalMethod!, swizzledMethod!) }
        
      }
      swizzleExchangeMethodsOnClass(SKNode.self, replaceSelector: "addChild:", withSelector:"_addChild:")
      swizzleExchangeMethodsOnClass(SKNode.self, replaceSelector: "insertChild:atIndex:", withSelector:"_insertChild:atIndex:")
      swizzleExchangeMethodsOnClass(SKNode.self, replaceSelector: "removeChildrenInArray:", withSelector:"_removeChildrenInArray:")
      swizzleExchangeMethodsOnClass(SKNode.self, replaceSelector: "removeAllChildren", withSelector:"_removeAllChildren")
      swizzleExchangeMethodsOnClass(SKNode.self, replaceSelector: "removeFromParent", withSelector:"_removeFromParent")
      
      Static.instance = SharedComponentManager()
      
    }
    return Static.instance!
  }
}


public func ==(lhs: Component, rhs: Component) -> Bool { return lhs === rhs }
public func ==(lhs: SKNode, rhs: SKNode) -> Bool { return lhs === rhs }
extension Component : Equatable {}
extension SKNode : Equatable {}
