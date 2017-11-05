//
//  Player.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-10-22.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
  // MARK: - Constants
  let TONGUE_COLOR = SKColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
  let MAX_SPEED : Int
  let spriteNode : SKSpriteNode
  // MARK: - Properties
  var speed : CGFloat = 0.0
  var moveToPoint : CGPoint?
  var moveTouch : UITouch?
  var attacking : Bool = false
  var stopRadius : CGFloat = 0.0
  
  // MARK: - Initializers
  convenience init() {
    self.init(node: SKSpriteNode())
  }
  
  init(node : SKSpriteNode) {
    self.spriteNode = node
    self.moveToPoint = node.position
    self.stopRadius = sqrt(pow(node.size.width, 2) + pow(node.size.height, 2)) / 2
    self.MAX_SPEED = node.userData?.value(forKey: "moveSpeed") as? Int ?? 0
  }
  
  // MARK: - Actions
  func attack() {
    // Setup player for attack
    if(!self.attacking) {
      self.attacking = true
      self.stop()
      // Setup the tongue geometry
      let tongueTip = SKShapeNode(circleOfRadius: 8.0)
      tongueTip.position = CGPoint(x: -2.0, y: 32.0)
      let tongueBase = SKShapeNode(rectOf: CGSize(width: 8.0, height: 10.0))
      tongueBase.position = CGPoint(x: -2.0, y: 32.0)
      tongueTip.fillColor = TONGUE_COLOR
      tongueTip.strokeColor = TONGUE_COLOR
      tongueBase.fillColor = TONGUE_COLOR
      tongueBase.strokeColor = TONGUE_COLOR
      
      self.spriteNode.addChild(tongueTip)
      self.spriteNode.addChild(tongueBase)
      
      // Setup and run the attack animation
      let tongueTipAction = SKAction.move(by: CGVector(dx: 0.0, dy: 160.0), duration: 0.3)
      let tongueBaseAction = SKAction.group([SKAction.scaleX(by: 1.0, y: 16.0, duration: 0.3), SKAction.moveBy(x: 0.0, y: 80.0, duration: 0.3)])
      
      let tongueTipDone = SKAction.removeFromParent()
      let tongueBaseDone = SKAction.removeFromParent()
      
      tongueBase.run(SKAction.sequence([tongueBaseAction, tongueBaseDone]))
      tongueTip.run(SKAction.sequence([tongueTipAction, tongueTipDone]), completion: {() -> Void in self.attacking = false})
    }
  }
  
  func stop(){
    self.speed = 0.0;
  }
  
  func move(toPoint pos : CGPoint) {
    // Set the move to point if not attacking
    if !self.attacking {
      self.moveToPoint = pos
      self.speed = CGFloat(self.MAX_SPEED)
    }
  }
}
