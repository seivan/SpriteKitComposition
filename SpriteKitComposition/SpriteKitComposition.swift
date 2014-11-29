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

private struct hub {
  static let timeInterval = NotificationHub<CFTimeInterval>()
  static let node         = NotificationHub<SKNode>()
  static let size         = NotificationHub<CGSize>()
  static let view         = NotificationHub<SKView>()
  static let contact      = NotificationHub<SKPhysicsContact>()
  static let nodeContact  = NotificationHub<(SKNode, contact:SKPhysicsContact)>()
}

@objc public class Component : ComponentBehaviour  {
  private var observerUpdated:Notification<CFTimeInterval>?
  private var observerSize:Notification<CGSize>?
  private var observersEmpty        = [Notification<SKNode>]()
  private var observersView         = [Notification<SKView>]()
  private var observersContact      = [Notification<SKPhysicsContact>]()
  private var observersNodeContact  = [Notification<(SKNode, contact:SKPhysicsContact)>]()
  
  private var behaviour:ComponentBehaviour { return self as ComponentBehaviour }
  
  var isEnabled:Bool = true
  private(set) weak var node:SKNode? {
    didSet {
      if(self.node != nil) {
        self.isEnabled = true
        self._didAddToNode()
      }
      else {
        self.isEnabled = false
        self._didRemoveFromNode()
      }
    }
  }
  
  init(){}
 
  final func removeFromNode() -> Bool {
    if let node = self.node { return node.removeComponent(self) }
    else { return false }
    
  }
  
  final private func addObservers() {
    self.removeObservers()
    let b = self.behaviour
    let scene = self.node!.scene!
    
    if let didChangeSceneSizedFrom = b.didChangeSceneSizedFrom {
      self.observerSize = hub.size.subscribeNotificationForName("didChangeSceneSizedFrom", sender: scene) { [weak self] notification in
        didChangeSceneSizedFrom(notification.userInfo!)
      }
      
    }
    
    if let didMoveToView = b.didMoveToView {
      self.observersView.append(hub.view.subscribeNotificationForName("didMoveToView", sender: scene) { [weak self] notification in
        didMoveToView(notification.userInfo!)
      })
    }
    
    if let willMoveFromView = b.willMoveFromView {
      self.observersView.append(hub.view.subscribeNotificationForName("willMoveFromView", sender: scene) { [weak self] notification in
        willMoveFromView(notification.userInfo!)
        })
    }
    
    if let didUpdate = b.didUpdate {
      self.observerUpdated = hub.timeInterval.subscribeNotificationForName("didUpdate", sender: scene) { [weak self] notification in
        if let x = self { if x.isEnabled { didUpdate(notification.userInfo!) } }
      }
    }
    
    if let didEvaluateActions =  b.didEvaluateActions {
      self.observersEmpty.append(
        hub.node.subscribeNotificationForName("didEvaluateActions", sender: scene) { [weak self] notification in
          if let x = self { if x.isEnabled { didEvaluateActions() } }
        })
    }
    
    if let didSimulatePhysics = b.didSimulatePhysics? {
      self.observersEmpty.append(
        hub.node.subscribeNotificationForName("didSimulatePhysics", sender: scene) { [weak self] notification in
          if let x = self { if x.isEnabled { didSimulatePhysics() } }
        })
    }
    
    if let didApplyConstraints = b.didApplyConstraints? {
      self.observersEmpty.append(
        hub.node.subscribeNotificationForName("didApplyConstraints", sender: scene) { [weak self] notification in
          if let x = self { if x.isEnabled { didApplyConstraints() } }
        })
    }
    
    if let didFinishUpdate = b.didFinishUpdate {
      self.observersEmpty.append(
        hub.node.subscribeNotificationForName("didFinishUpdate", sender: scene) { [weak self] notification in
          if let x = self { if x.isEnabled { didFinishUpdate() } }
        })
    }
    
    if let didBeginContact = b.didBeginContact {
      self.observersContact.append(
        hub.contact.subscribeNotificationForName("didBeginContact", sender: scene) { [weak self] notification in
          if let x = self { if x.isEnabled { didBeginContact(notification.userInfo!) } }
        })
    }
    
    if let didEndContact = b.didEndContact {
      self.observersContact.append(
        hub.contact.subscribeNotificationForName("didEndContact", sender: scene) { [weak self] notification in
          if let x = self { if x.isEnabled { didEndContact(notification.userInfo!) } }
        })
    }
    
    if let didBeginContactWithNode =  b.didBeginContactWithNode {
      self.observersNodeContact.append(
        hub.nodeContact.subscribeNotificationForName("didBeginContactWithNode", sender: self.node) { [weak self] notification in
          if let x = self { if x.isEnabled == true { didBeginContactWithNode(notification.userInfo!) } }
        })
    }
    
    if let didEndContactWithNode = b.didEndContactWithNode {
      self.observersNodeContact.append(
        hub.nodeContact.subscribeNotificationForName("didEndContactWithNode", sender: self.node) { [weak self] notification in
          if let x = self { if x.isEnabled { didEndContactWithNode(notification.userInfo!) } }
        })
    }
    
    
  }
  
  
  final private func _didAddToNode() {
    self.behaviour.didAddToNode?()
    if(self.node?.scene != nil) { self._didAddNodeToScene() }
    
  }
  final private func _didAddNodeToScene() {
    self.addObservers()
    self.behaviour.didAddNodeToScene?()
  }
  
  final private func _didRemoveFromNode() {
    self.removeObservers()
    self.behaviour.didRemoveFromNode?()
  }
  
  final private func _didRemoveNodeFromScene() {
    self.removeObservers()
    self.behaviour.didRemoveNodeFromScene?()
  }
  
  final private func removeObservers() {
    self.observerUpdated?.remove()
    self.observerSize?.remove()
    
    for observer in self.observersEmpty       { observer.remove() }
    for observer in self.observersContact     { observer.remove() }
    for observer in self.observersNodeContact { observer.remove() }
    for observer in self.observersView        { observer.remove() }
  }
  
  deinit {
    self.removeObservers()
  }
  
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
    hub.size.publishNotificationName("didChangeSceneSizedFrom", sender: self, userInfo:oldSize)
  }
  
  public func didMoveToView(view: SKView) {
    self.physicsWorld.contactDelegate = self
    hub.view.publishNotificationName("didMoveToView", sender: self, userInfo:view)
  }
  
  public func willMoveFromView(view: SKView) {
    hub.view.publishNotificationName("willMoveFromView", sender: self, userInfo:view)
  }
  
  public func update(currentTime: NSTimeInterval) {
    let container = self.componentContainer
    var timeSinceLast: CFTimeInterval = currentTime - container.lastUpdateTimeInterval
    container.lastUpdateTimeInterval = currentTime
    if  timeSinceLast > 1  {
      timeSinceLast = 1.0 / 60.0
      container.lastUpdateTimeInterval = currentTime
    }
    hub.timeInterval.publishNotificationName("didUpdate", sender: self, userInfo: timeSinceLast)
  }
  
  public func didEvaluateActions() {
    hub.node.publishNotificationName("didEvaluateActions", sender: self)
  }
  
  public func didSimulatePhysics() {
    hub.node.publishNotificationName("didSimulatePhysics", sender: self)
  }
  
  public func didApplyConstraints() {
    hub.node.publishNotificationName("didApplyConstraints", sender: self)
  }
  
  public func didFinishUpdate() {
    hub.node.publishNotificationName("didFinishUpdate", sender: self)
  }
  
  
  public func didBeginContact(contact: SKPhysicsContact) {
    hub.contact.publishNotificationName("didBeginContact", sender: self, userInfo:contact)
    let nodeA = contact.bodyA.node
    let nodeB = contact.bodyB.node
    
    if let nodeA = nodeA {
      hub.nodeContact.publishNotificationName("didBeginContactWithNode", sender: nodeB, userInfo:(nodeA,contact:contact))
    }

    if let nodeB = nodeB {
      hub.nodeContact.publishNotificationName("didBeginContactWithNode", sender: nodeA, userInfo:(nodeB,contact:contact))
    }
  }
  
  public func didEndContact(contact: SKPhysicsContact) {
    hub.contact.publishNotificationName("didEndContact", sender: self, userInfo:contact)
    let nodeA = contact.bodyA.node
    let nodeB = contact.bodyB.node
    
    if let nodeA = nodeA {
      hub.nodeContact.publishNotificationName("didEndContactWithNode", sender: nodeB, userInfo:(nodeA,contact:contact))
    }
    
    if let nodeB = nodeB {
      hub.nodeContact.publishNotificationName("didEndContactWithNode", sender: nodeA, userInfo:(nodeB,contact:contact))
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
    if self is SKScene {
      for component in node.components { component._didAddNodeToScene() }
      for childNode in node.childNodes { node._addedChild(childNode) }
    }
    else if self.parent != nil {
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
    if self is SKScene {
      for component in node.components { component._didRemoveNodeFromScene() }
      for childNode in node.childNodes { node._removedChild(childNode) }
    }
    else if self.parent != nil {
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
