//
//  GameScene.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-07-02.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
      // Scene loaded here, set up the scene
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
      // Touch presses down
    }
    
    func touchMoved(toPoint pos : CGPoint) {
      // Touch is moved while pressed
    }
    
    func touchUp(atPoint pos : CGPoint) {
      // Touch is lifted
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
