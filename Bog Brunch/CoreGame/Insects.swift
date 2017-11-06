//
//  Insect.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-11-05.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import Foundation
import SpriteKit

struct InsectPointValues {
  static let FLY_POINT_VALUE : Int = 25
  static let LADYBUG_POINT_VALUE : Int = 50
  static let WASP_POINT_VALUE : Int = 0
}

let INSECT_MAX_VELOCITY : Int = 200

class Insect : Hashable {
  let name : String
  let sprite : SKSpriteNode
  let pointValue : Int
  let isEnemy : Bool
  var vx : CGFloat = 0.0
  var vy : CGFloat = 0.0
  var hashValue : Int {
    return self.name.hashValue ^
      self.sprite.hashValue ^
      self.pointValue.hashValue ^
      self.vx.hashValue ^
      self.vy.hashValue
  }
  
  init(sprite : SKSpriteNode, name : String, points : Int, isEnemy : Bool) {
    self.sprite = sprite
    self.name = name
    self.pointValue = points
    self.isEnemy = isEnemy
    self.sprite.setScale(0.2)
  }
  
  func moveRandom() {
    self.vx = CGFloat(random(-INSECT_MAX_VELOCITY...INSECT_MAX_VELOCITY))
    self.vy = CGFloat(random(-INSECT_MAX_VELOCITY...INSECT_MAX_VELOCITY))
  }
  
  static func == (lhs: Insect, rhs: Insect) -> Bool {
    return lhs.name == rhs.name &&
      lhs.sprite == rhs.sprite &&
      lhs.pointValue == rhs.pointValue &&
      lhs.isEnemy == rhs.isEnemy &&
      lhs.vx == rhs.vx &&
      lhs.vy == rhs.vy
  }
}

class Fly : Insect {
  init() {
    super.init(sprite: SKSpriteNode(texture: SKTexture(imageNamed: "fly")), name: "Fly", points: InsectPointValues.FLY_POINT_VALUE, isEnemy: false);
  }
}

class Ladybug : Insect {
  init() {
    super.init(sprite: SKSpriteNode(texture: SKTexture(imageNamed: "ladybug")), name: "Ladybug", points: InsectPointValues.LADYBUG_POINT_VALUE, isEnemy: false);
  }
}

class Wasp : Insect {
  init() {
    super.init(sprite: SKSpriteNode(texture: SKTexture(imageNamed: "wasp")), name: "Wasp", points: InsectPointValues.WASP_POINT_VALUE, isEnemy: true);
  }
}
