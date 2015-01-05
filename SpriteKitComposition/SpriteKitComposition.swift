import SpriteKit


private let ComponentStateStarted   = ComponentState(0)
private let ComponentStateChanged   = ComponentState(1)
private let ComponentStateCompleted = ComponentState(2)
private let ComponentStateCancelled = ComponentState(3)

@objc public class ComponentState : DebugPrintable, Printable, Equatable {
  let value: Int
  private init(_ val: Int) { value = val }
  class var Started:ComponentState   {  return ComponentStateStarted }
  class var Changed:ComponentState   {  return ComponentStateChanged }
  class var Completed:ComponentState {  return ComponentStateCompleted }
  class var Cancelled:ComponentState {  return ComponentStateCancelled }
  
  public var description:String {
    switch self.value {
    case 0:  return "ComponentStateStarted"
    case 1:  return "ComponentStateChanged"
    case 2:  return "ComponentStateCompleted"
    case 3:  return "ComponentStateCancelled"
    default: return "No State"
    }
  }
  public var debugDescription:String { return self.description + ", value: \(self.value)" }
}
public func ==(lhs:ComponentState, rhs:ComponentState) -> Bool { return lhs.value == rhs.value }



@objc private protocol __IComponent {
  
  optional func didAddToNode(node:SKNode)
  optional func didAddNodeToScene(scene:SKScene)
  
  optional func didRemoveFromNode(node:SKNode)
  optional func didRemoveNodeFromScene(scene:SKScene)
  
  optional func didChangeSceneSizedFrom(previousSize:CGSize)
  optional func didMoveToView(view: SKView)
  optional func willMoveFromView(view: SKView)
  
  
  //if isEnabled
  optional func didUpdate(time:NSTimeInterval)
  optional func didEvaluateActions()
  optional func didSimulatePhysics()
  optional func didApplyConstraints()
  optional func didFinishUpdate()

  optional func didContactScene(contact:SKPhysicsContact, state:ComponentState)
  optional func didContactNode(node:SKNode, contact:SKPhysicsContact, state:ComponentState)

  optional func didTouchScene(touches:[UITouch], state:ComponentState)
  optional func didTouchNode(touches:[UITouch], state:ComponentState)
  
  optional func didEnable(isEnabled:Bool)

}

private struct __Hubs {
  static let timeInterval = NotificationHub<CFTimeInterval>()
  static let node         = NotificationHub<SKNode>()
  static let size         = NotificationHub<CGSize>()
  static let view         = NotificationHub<SKView>()
  static let contact      = NotificationHub<(SKPhysicsContact, state:ComponentState)>()
  static let contactNode  = NotificationHub<(SKNode, contact:SKPhysicsContact, state:ComponentState)>()
  static let touch        = NotificationHub<([UITouch], state:ComponentState)>()
}

@objc public class Component : __IComponent  {
  private struct ObserverCollection {
    var updated:Notification<CFTimeInterval>?
    var size:Notification<CGSize>?
    var empty        = [Notification<SKNode>]()
    var view         = [Notification<SKView>]()
    var contact      = [Notification<(SKPhysicsContact,state:ComponentState)>]()
    var contactNode  = [Notification<(SKNode, contact:SKPhysicsContact, state:ComponentState)>]()
    var touch        = [Notification<([UITouch], state:ComponentState)>]()
    
    init(){}
    func removeAll() {
      self.updated?.remove()
      self.size?.remove()
      for observer in self.empty       { observer.remove() }
      for observer in self.view        { observer.remove() }
      for observer in self.contact     { observer.remove() }
      for observer in self.contactNode { observer.remove() }
      for observer in self.touch       { observer.remove() }
    }
    
  }
  
  private var observerCollection = ObserverCollection()


  var isEnabled:Bool = true {
    willSet {
      self._removeObservers()
      if newValue == true && self.node?.scene != nil { self._addObservers() }
    }
    didSet { if oldValue != self.isEnabled { (self as __IComponent).didEnable?(self.isEnabled) } }
  }
  private(set) weak var node:SKNode? {
    willSet { if newValue  == nil { self._didRemoveFromNode() } }
    didSet  { if self.node != nil { self._didAddToNode() } }
  }
  
  init(){ }
  
  final func removeFromNode() -> Component? {
    if let n = self.node { return n.removeComponent(self) }
    else { return nil }
    
  }
  
  final private func _addObservers() {
    let b = (self as __IComponent)
    let scene = self.node!.scene!
    let node = self.node!
    
    if let didChangeSceneSizedFrom = b.didChangeSceneSizedFrom {
      self.observerCollection.size = __Hubs.size.subscribeNotificationForName("didChangeSceneSizedFrom", sender: scene) {
        n in didChangeSceneSizedFrom(n.userInfo!)
      }
      
    }
    
    if let didMoveToView = b.didMoveToView {
      self.observerCollection.view.append(
        __Hubs.view.subscribeNotificationForName("didMoveToView", sender: scene) {
        n in didMoveToView(n.userInfo!)
        })
    }
    
    if let willMoveFromView = b.willMoveFromView {
      self.observerCollection.view.append(
        __Hubs.view.subscribeNotificationForName("willMoveFromView", sender: scene) {
        n in willMoveFromView(n.userInfo!)
        })
    }
    
    if let didUpdate = b.didUpdate {
      self.observerCollection.updated = __Hubs.timeInterval.subscribeNotificationForName("didUpdate", sender: scene) {
        n in didUpdate(n.userInfo!)
      }
    }
    
    if let didEvaluateActions =  b.didEvaluateActions {
      self.observerCollection.empty.append(
        __Hubs.node.subscribeNotificationForName("didEvaluateActions", sender: scene) {
          n in didEvaluateActions()
        })
    }
    
    if let didSimulatePhysics = b.didSimulatePhysics? {
      self.observerCollection.empty.append(
        __Hubs.node.subscribeNotificationForName("didSimulatePhysics", sender: scene) {
          n in didSimulatePhysics()
        })
    }
    
    if let didApplyConstraints = b.didApplyConstraints? {
      self.observerCollection.empty.append(
        __Hubs.node.subscribeNotificationForName("didApplyConstraints", sender: scene) {
          n in didApplyConstraints()
        })
    }
    
    if let didFinishUpdate = b.didFinishUpdate {
      self.observerCollection.empty.append(
        __Hubs.node.subscribeNotificationForName("didFinishUpdate", sender: scene) {
          n in didFinishUpdate()
        })
    }

    if let didContactScene = b.didContactScene {
      self.observerCollection.contact.append(
        __Hubs.contact.subscribeNotificationForName("didContactScene", sender: scene) {
          n in didContactScene(n.userInfo!)
        })
    }
    
    if let didContactNode = b.didContactNode {
      self.observerCollection.contactNode.append(
        __Hubs.contactNode.subscribeNotificationForName("didContactNode", sender: node) {
          n in didContactNode(n.userInfo!)
        })
    }

    if let didTouchScene = b.didTouchScene {
      self.observerCollection.touch.append(
        __Hubs.touch.subscribeNotificationForName("didTouchScene", sender: scene) {
          n in didTouchScene(n.userInfo!)
        })
    }
    
    if let didTouchNode = b.didTouchNode {
      node.userInteractionEnabled = true
      self.observerCollection.touch.append(
        __Hubs.touch.subscribeNotificationForName("didTouchNode", sender: node) {
          n in didTouchNode(n.userInfo!)
        })
    }
    
  }
  
  
  final private func _didAddToNode() {
    (self as __IComponent).didAddToNode?(self.node!)
    if self.node?.scene != nil { self._didAddNodeToScene() }
    
  }
  final private func _didAddNodeToScene() {
    let component = self as __IComponent
    component.didAddNodeToScene?(self.node!.scene!)
    if let view = self.node!.scene!.view { component.didMoveToView?(view) }
    if(self.isEnabled) { self._addObservers() }
    
  }
  
  final private func _didRemoveFromNode() {
    (self as __IComponent).didRemoveFromNode?(self.node!)
    self._removeObservers()

  }
  
  final private func _didRemoveNodeFromScene() {
    let component = self as __IComponent
    component.didRemoveNodeFromScene?(self.node!.scene!)
    if let view = self.node!.scene!.view { component.willMoveFromView?(view) }
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
  
  final func addComponent<T:Component>(component:T, withKey key:String) -> T? {
    if self.componentContainer.components[key] == nil {
      self.componentContainer.components[key] = component
      component.node = self
      return component
    }
    else { return nil }
    
  }
  
  final func addComponent<T:Component>(component:T) -> T? {
    let key = NSStringFromClass(component.dynamicType)
    return self.addComponent(component, withKey: key)
  }
  
  final func removeComponentWithClass(theClass:AnyClass) -> Component? {
    let key = NSStringFromClass(theClass)
    return self.removeComponentWithKey(key)
  }
  
  final func removeComponentWithKey(key:String) -> Component? {
    if let componentToRemove = self.componentContainer.components.removeValueForKey(key) {
      componentToRemove.node = nil
      return componentToRemove
    }
    else { return nil }
  }
  
  final func removeComponent<T:Component>(component:T) -> Component? {
    var foundKey:String?
    for (key, value) in self.componentContainer.components {
      if value === component {
        foundKey = key
        break
      }
    }
    if let key = foundKey { return self.removeComponentWithKey(key) }
    else { return nil }
  }
  
}

extension SKScene : SKPhysicsContactDelegate {
  
  public func didChangeSize(oldSize: CGSize) {
    __Hubs.size.publishNotificationName("didChangeSceneSizedFrom", sender: self, userInfo:oldSize)
  }
  
  public func didMoveToView(view: SKView) {
    self.physicsWorld.contactDelegate = self
    __Hubs.view.publishNotificationName("didMoveToView", sender: self, userInfo:view)
  }
  
  public func willMoveFromView(view: SKView) {
    __Hubs.view.publishNotificationName("willMoveFromView", sender: self, userInfo:view)
  }
  
  public func update(currentTime: NSTimeInterval) {
    let container = self.componentContainer
    var timeSinceLast: CFTimeInterval = currentTime - container.lastUpdateTimeInterval
    container.lastUpdateTimeInterval = currentTime
    if  timeSinceLast > 1  {
      timeSinceLast = 1.0 / 60.0
      container.lastUpdateTimeInterval = currentTime
    }
    __Hubs.timeInterval.publishNotificationName("didUpdate", sender: self, userInfo: timeSinceLast)
  }
  
  public func didEvaluateActions() {
    __Hubs.node.publishNotificationName("didEvaluateActions", sender: self)
  }
  
  public func didSimulatePhysics() {
    __Hubs.node.publishNotificationName("didSimulatePhysics", sender: self)
  }
  
  public func didApplyConstraints() {
    __Hubs.node.publishNotificationName("didApplyConstraints", sender: self)
  }
  
  public func didFinishUpdate() {
    __Hubs.node.publishNotificationName("didFinishUpdate", sender: self)
  }
  
  
  public func didBeginContact(contact: SKPhysicsContact) {
    __Hubs.contact.publishNotificationName("didContactScene",
      sender: self, userInfo:(contact,state:ComponentState.Started))
    let nodeA = contact.bodyA.node
    let nodeB = contact.bodyB.node
    
    if let nodeA = nodeA {
      __Hubs.contactNode.publishNotificationName("didContactNode",
        sender: nodeB, userInfo:(nodeA, contact:contact, state:ComponentState.Started))
    }
    
    if let nodeB = nodeB {
      __Hubs.contactNode.publishNotificationName("didContactNode",
        sender: nodeA, userInfo:(nodeB,contact:contact, state:ComponentState.Started))
    }
  }
  
  public func didEndContact(contact: SKPhysicsContact) {
    __Hubs.contact.publishNotificationName("didContactScene",
      sender: self, userInfo:(contact, state:ComponentState.Completed))
    let nodeA = contact.bodyA.node
    let nodeB = contact.bodyB.node
    
    if let nodeA = nodeA {
      __Hubs.contactNode.publishNotificationName("didContactNode",
        sender: nodeB, userInfo:(nodeA,contact:contact, state:ComponentState.Completed))
    }
    
    if let nodeB = nodeB {
      __Hubs.contactNode.publishNotificationName("didContactNode",
        sender: nodeA, userInfo:(nodeB,contact:contact, state:ComponentState.Completed))
    }
    
    
  }
  
  
  
}

extension SKNode {
  
  
  private func publishTouches(touchSet: NSSet, state:ComponentState) {
    let touches:[UITouch] = touchSet.allObjects as [UITouch]
    __Hubs.touch.publishNotificationName("didTouchNode", sender: self, userInfo:(touches, state:state))
    __Hubs.touch.publishNotificationName("didTouchScene", sender: self.scene, userInfo:(touches, state:state))
    
  }

  override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    self.publishTouches(touches, state: ComponentState.Started)
   }
  
  override public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    self.publishTouches(touches, state: ComponentState.Changed)
  }

  override public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    self.publishTouches(touches, state: ComponentState.Completed)
  }

  override public func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
    self.publishTouches(touches, state: ComponentState.Cancelled)
  }

  
  
}

extension SKNode {
  
  private func _addedChild(node:SKNode) {
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
      var manager = SharedComponentManager.sharedInstance.mapTable.objectForKey(self) as InternalComponentContainer?
      if manager == nil {
        manager = InternalComponentContainer()
        SharedComponentManager.sharedInstance.mapTable.setObject(manager!, forKey: self)
      }
      return manager!
    }
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
