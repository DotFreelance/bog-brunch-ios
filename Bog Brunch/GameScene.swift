//
//  GameScene.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-07-02.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import SpriteKit

// MARK: - Constants
struct PhysicsCategory {
  static let None       : UInt32 = 0
  static let All        : UInt32 = UInt32.max
  static let Player     : UInt32 = 1
  static let Wall       : UInt32 = 2
  static let TongueTip  : UInt32 = 3
  static let Wasp       : UInt32 = 4
  static let Food       : UInt32 = 5
}

// MARK: - GameScene Class
class GameScene: SKScene, SKPhysicsContactDelegate {
  // MARK: - Properties
  private var player : Player = Player()
  private var sceneEdge : SKPhysicsBody?
  private var numTouches : UInt = 0
  private var prevTime : Double = 0.0
  
  // MARK: - Scene Activity
  override func didMove(to view: SKView) {
    // Scene loaded here, set up the scene
    self.backgroundColor = UIColor(red:0.81, green:0.92, blue:0.91, alpha:1.0)
    player = Player(node:self.childNode(withName: "player") as! SKSpriteNode)
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    
    physicsWorld.contactDelegate = self
    
    sceneEdge?.categoryBitMask = PhysicsCategory.Wall
    sceneEdge?.contactTestBitMask = PhysicsCategory.Player
    sceneEdge?.usesPreciseCollisionDetection = true
  }
  
  // MARK: - Touch Activity
  func touchDown(atPoint pos : CGPoint, withTouch touch : UITouch) {
    // Touch presses down
    numTouches += 1
    
    if numTouches == 1 {
      player.moveTouch = touch
      player.move(toPoint: pos)
    }
  }
  
  func touchMoved(toPoint pos : CGPoint, withTouch touch : UITouch) {
    // Touch is moved while pressed
    if player.moveTouch == touch {
      player.move(toPoint: pos)
    } else if player.moveTouch == nil {
      // We can safely claim this touch to be our new move touch
      player.moveTouch = touch
      player.move(toPoint: pos)
    }
  }
  
  func touchUp(atPoint pos : CGPoint, withTouch touch : UITouch) {
    // Touch is lifted
    numTouches -= 1
    
    if player.moveTouch == touch || numTouches == 0 {
      player.stop()
      player.moveTouch = nil
    } else if numTouches >= 1 {
      player.attack()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self), withTouch: t) }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: self), withTouch: t) }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self), withTouch: t) }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self), withTouch: t) }
  }
  
  // MARK: - Frame Update
  override func update(_ currentTime: TimeInterval) {
    let frameTime = currentTime - prevTime
    // Deltas between current position and move to position
    let delta = (player.moveToPoint)! - player.spriteNode.position
    player.spriteNode.zRotation = atan2(delta.x, -delta.y) + CGFloat.pi
    
    let hyp = delta.length()
    if hyp > player.stopRadius && player.speed > 0.0 {
      let scaleFactor = hyp / (player.speed * CGFloat(frameTime))
      player.spriteNode.position.x += delta.x / scaleFactor
      player.spriteNode.position.y += delta.y / scaleFactor
    }
    self.prevTime = currentTime
  }
  
  // MARK: - Physics
  func didBegin(_ contact: SKPhysicsContact) {
    print("Contact detected")
  }
}
