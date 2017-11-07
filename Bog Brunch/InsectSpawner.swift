//
//  InsectSpawner.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-11-05.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import Foundation
import SpriteKit

struct InitialInsects {
  static let FLIES_MAX : Int = 3
  static let LADYBUGS_MAX : Int = 2
  static let WASPS_MAX : Int = 2
}

class InsectSpawner {
  private let insectLayer : SKNode = SKNode()
  private let gameTimer : GameTimer
  private let gameScene : SKScene
  private var insects : Set<Insect> = []
  private var flies : Int = 0
  private var ladybugs : Int = 0
  private var wasps : Int = 0
  private var maxFlies : Int = InitialInsects.FLIES_MAX
  private var maxLadybugs : Int = InitialInsects.LADYBUGS_MAX
  private var maxWasps : Int = InitialInsects.WASPS_MAX
  
  init(withGameTimerService gameTimer : GameTimer,
       withGameScene scene : SKScene) {
    self.gameTimer = gameTimer
    self.gameScene = scene
    scene.addChild(self.insectLayer)
  }
  
  func setLayerZHeight(zHeight : CGFloat) {
    self.insectLayer.zPosition = zHeight
  }
  
  func initSpawn() {
    for _ in 1...self.maxFlies {
      self.spawn(aNewInsect: Fly())
    }
    for _ in 1...self.maxLadybugs {
      self.spawn(aNewInsect: Ladybug())
    }
    for _ in 1...self.maxWasps {
      self.spawn(aNewInsect: Wasp())
    }
    
    // TODO: Initiate spawn monitor
    
    // TODO: Add all level of difficulty events
  }
  
  func spawn(aNewInsect insect : Insect) {
    switch insect.name {
    case "Fly":
      self.flies += 1
    case "Ladybug":
      self.ladybugs += 1
    case "Wasp":
      self.wasps += 1
    default:
      break
    }
    
    insect.sprite.position = randomSpawn(inGameSize: gameScene.size)
    insectLayer.addChild(insect.sprite)
    insects.insert(insect);
    insect.moveRandom()
  }
  
  func remove(insect : Insect) {
    if self.insects.contains(insect) {
      switch insect.name {
      case "Fly":
        self.flies -= 1
      case "Ladybug":
        self.ladybugs -= 1
      case "Wasp":
        self.wasps -= 1
      default:
        break
      }
      self.insectLayer.removeChildren(in: [insect.sprite])
      self.insects.remove(insect)
    }
  }
  
  func moveInsects(frameTime : Double) {
    for insect in self.insects {
      let insectCollision = containInsect(sprite: insect.sprite, container: self.gameScene);
      if insectCollision == "top" || insectCollision == "bottom" {
        insect.vy = -insect.vy
      } else if insectCollision == "left" || insectCollision == "right" {
        insect.vx = -insect.vx
      } else {
        // Move insect
        insect.sprite.position.x += (insect.vx * CGFloat(frameTime))
        insect.sprite.position.y += (insect.vy * CGFloat(frameTime))
      }
      insect.sprite.zRotation = atan2(insect.vx, -insect.vy) + CGFloat.pi
    }
  }
}
