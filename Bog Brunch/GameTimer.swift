//
//  GameTimer.swift
//  Bog Brunch
//
//  Created by Paul Jarrow on 2017-11-05.
//  Copyright © 2017 Paul Jarrow. All rights reserved.
//

import Foundation

class GameTimer {
  private let TIME_INTERVAL : Double = 0.1
  private var time : Double = 0.0
  private var timer : Timer = Timer()
  private var events : [Event] = []
  
  func start() {
    self.stop()
    self.timer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL, repeats: true, block: {(timer : Timer) -> Void in self.update(timer: timer) })
  }
  
  func update(timer : Timer) {
    self.time += TIME_INTERVAL
    self.executeEvents()
  }
  
  func stop() {
    self.timer.invalidate()
  }
  
  func reset() {
    self.stop()
    self.time = 0.0
  }
  
  func addEvent(toHappenInSeconds seconds : Double, toExecute: @autoclosure @escaping () -> Void) {
    self.events.append(GameTimer.Event(seconds: seconds, toExecute: toExecute))
  }
  
  func executeEvents() {
    for (index, event) in self.events.enumerated() {
      if(event.execute(currentTime: self.time)) {
        self.events.remove(at: index)
      }
    }
  }
  
  private class Event {
    private let seconds : Double
    private let toExecute : () -> Void
    
    init(seconds : Double, toExecute: @autoclosure @escaping () -> Void) {
      self.seconds = seconds
      self.toExecute = toExecute
    }
    
    func execute(currentTime : Double) -> Bool {
      if(self.seconds <= currentTime) {
        self.toExecute();
        return true
      }
      return false
    }
  }
}


