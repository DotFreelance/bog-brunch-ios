//
//  GameUtilities.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-11-05.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import Foundation
import SpriteKit

// Closed range integer generation courtesy of https://learnappmaking.com/random-numbers-swift/
func random(_ range: CountableClosedRange<Int>) -> Int
{
  return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
}

func randomSpawn(inGameSize size : CGSize) -> CGPoint {
  return CGPoint(x: size.width * CGFloat(Double(random(2...9)) / 10) - (size.width / 2),
                 y: size.height * CGFloat(Double(random(2...9)) / 10) - (size.height / 2))
}

/*
 * Functionality for containing a sprite within bounds
 * Code taken from: https://github.com/kittykatattack/learningPixi#sprites
 */
func containPlayer(sprite : SKSpriteNode, container : SKScene) {
  //Left
  if (sprite.position.x - sprite.size.width * sprite.anchorPoint.x < container.position.x - container.size.width / 2.0) {
    sprite.position.x = (container.position.x - container.size.width / 2.0) + sprite.size.width * sprite.anchorPoint.x;
  }
  
  //Bottom
  if (sprite.position.y - sprite.size.height * sprite.anchorPoint.y < container.position.y - container.size.height / 2.0) {
    sprite.position.y = (container.position.y - container.size.height / 2.0) + sprite.size.height * sprite.anchorPoint.y;
  }
  
  //Right
  if (sprite.position.x + sprite.size.width * sprite.anchorPoint.x > container.size.width / 2.0) {
    sprite.position.x = (container.size.width / 2.0) - sprite.size.width * sprite.anchorPoint.x;
  }
  
  //Top
  if (sprite.position.y + sprite.size.height * sprite.anchorPoint.y > container.size.height / 2.0) {
    sprite.position.y = (container.size.height / 2.0) - sprite.size.height * sprite.anchorPoint.y;
  }
}

func containInsect(sprite : SKSpriteNode, container : SKScene) -> String {
  
  var collision = "";
  
  //Left
  if (sprite.position.x - sprite.size.width * sprite.anchorPoint.x < container.position.x - container.size.width / 2.0) {
    sprite.position.x = (container.position.x - container.size.width / 2.0) + sprite.size.width * sprite.anchorPoint.x;
    collision = "left";
  }
  
  //Bottom
  if (sprite.position.y - sprite.size.height * sprite.anchorPoint.y < container.position.y - container.size.height / 2.0) {
    sprite.position.y = (container.position.y - container.size.height / 2.0) + sprite.size.height * sprite.anchorPoint.y;
    collision = "bottom";
  }
  
  //Right
  if (sprite.position.x + sprite.size.width * sprite.anchorPoint.x > container.size.width / 2.0) {
    sprite.position.x = (container.size.width / 2.0) - sprite.size.width * sprite.anchorPoint.x;
    collision = "right";
  }
  
  //Top
  if (sprite.position.y + sprite.size.height * sprite.anchorPoint.y > container.size.height / 2.0) {
    sprite.position.y = (container.size.height / 2.0) - sprite.size.height * sprite.anchorPoint.y;
    collision = "top";
  }
  
  return collision;
}
