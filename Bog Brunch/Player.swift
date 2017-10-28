//
//  Player.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-10-22.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }
  
  required init?(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)
  }
}
