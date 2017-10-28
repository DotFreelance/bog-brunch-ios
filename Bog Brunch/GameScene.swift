//
//  GameScene.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-07-02.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - Vector Math Overrides/Functions
func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}

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
  private var player : Player?
  private var sceneEdge : SKPhysicsBody?
  private var numTouches : UInt = 0
  private var playerSpeed : CGFloat = 0.0
  private var playerDirection : CGPoint?
  private var playerMoveTouch : UITouch?
  private var playerAttacking : Bool = false
  private var stopRadius : CGFloat = 0.0
  
  
  override func didMove(to view: SKView) {
    // Scene loaded here, set up the scene
    player = self.childNode(withName: "player") as? Player
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    let playerWidth = player?.size.width
    let playerHeight = player?.size.height
    stopRadius = sqrt(pow((playerWidth)!, 2) + pow((playerHeight)!, 2)) / 2
    playerDirection = (player?.position)!
    
    physicsWorld.contactDelegate = self
    
    sceneEdge?.categoryBitMask = PhysicsCategory.Wall
    sceneEdge?.contactTestBitMask = PhysicsCategory.Player
    sceneEdge?.usesPreciseCollisionDetection = true
  }
  
  // MARK: - Player Control
  
  func touchDown(atPoint pos : CGPoint, withTouch touch : UITouch) {
    // Touch presses down
    numTouches += 1
    
    if numTouches == 1 {
      playerMoveTouch = touch
      playerMove(toPoint: pos)
    }
  }
  
  func touchMoved(toPoint pos : CGPoint, withTouch touch : UITouch) {
    // Touch is moved while pressed
    if playerMoveTouch == touch {
      playerMove(toPoint: pos)
    } else if playerMoveTouch == nil {
      // We can safely claim this touch to be our new move touch
      playerMoveTouch = touch
      playerMove(toPoint: pos)
    }
  }
  
  func touchUp(atPoint pos : CGPoint, withTouch touch : UITouch) {
    // Touch is lifted
    numTouches -= 1
    
    if playerMoveTouch == touch || numTouches == 0 {
      playerStop()
      playerMoveTouch = nil
    } else if numTouches >= 1 {
      playerAttack()
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
    // Deltas between current position and move to position
    let delta = (playerDirection)! - (player?.position)!
    player?.zRotation = atan2(delta.x, -delta.y) + CGFloat.pi
    
    let hyp = delta.length()
    if hyp > stopRadius && playerSpeed > 0.0 {
      let scaleFactor = hyp / playerSpeed
      player?.position.x += delta.x / scaleFactor
      player?.position.y += delta.y / scaleFactor
    }
  }
  
  // MARK: - Player Action
  private func playerMove(toPoint pos : CGPoint) {
    // Set the move to point if not attacking
    if !playerAttacking {
      playerDirection = pos
      playerSpeed = 3.0;
    }
  }
  
  private func playerStop(){
    playerSpeed = 0.0;
  }
  
  private func playerAttack() {
    // Setup player for attack
    if(!playerAttacking) {
      playerAttacking = true
      playerStop()
      // Setup the tongue geometry
      let tongueTip = SKShapeNode(circleOfRadius: 8.0)
      tongueTip.position = CGPoint(x: -2.0, y: 32.0)
      let tongueBase = SKShapeNode(rectOf: CGSize(width: 8.0, height: 10.0))
      tongueBase.position = CGPoint(x: -2.0, y: 32.0)
      let tongueColor = SKColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
      tongueTip.fillColor = tongueColor
      tongueTip.strokeColor = tongueColor
      tongueBase.fillColor = tongueColor
      tongueBase.strokeColor = tongueColor
      
      player?.addChild(tongueTip)
      player?.addChild(tongueBase)
      
      // Setup and run the attack animation
      let tongueTipAction = SKAction.move(by: CGVector(dx: 0.0, dy: 160.0), duration: 0.3)
      let tongueBaseAction = SKAction.group([SKAction.scaleX(by: 1.0, y: 16.0, duration: 0.3), SKAction.moveBy(x: 0.0, y: 80.0, duration: 0.3)])
      
      let tongueTipDone = SKAction.removeFromParent()
      let tongueBaseDone = SKAction.removeFromParent()
      
      tongueBase.run(SKAction.sequence([tongueBaseAction, tongueBaseDone]))
      tongueTip.run(SKAction.sequence([tongueTipAction, tongueTipDone]), completion: {() -> Void in self.playerAttacking = false})
    }
  }
  
  // MARK: - Physics
  func didBegin(_ contact: SKPhysicsContact) {
    print("Contact detected")
  }
}
