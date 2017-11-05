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

class Insect {
  let name : String
  let sprite : SKSpriteNode
  let pointValue : Int
  let isEnemy : Bool
  
  init(sprite : SKSpriteNode, name : String, points : Int, isEnemy : Bool) {
    self.sprite = sprite
    self.name = name
    self.pointValue = points
    self.isEnemy = isEnemy
    self.sprite.setScale(0.2)
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
