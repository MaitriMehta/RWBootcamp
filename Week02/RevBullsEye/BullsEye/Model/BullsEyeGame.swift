//
//  BullsEyeGame.swift
//  BullsEye
//
//  Created by Mehta on 6/6/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation

//:BullsEyeGame

struct Score {
  var title : String
  var points : Int
    
  public init(title: String, points: Int) {
    self.title = title
    self.points = points
  }
}

struct BullsEyeGame {
  var currentValue = 0
  var targetValue = 0
  var score = 0
  var round = 0
  
  mutating func startNewRound() {
    round += 1
    targetValue = Int.random(in: 1...100)
//    currentValue = 50
  }
  
  mutating func getDifference(a: Int, b: Int) -> Int {
    return abs(a - b)
  }
    
  mutating func calculateScore(guessValue : Int) -> Score {
    let title: String
    let difference = getDifference(a:targetValue, b: currentValue)
    var points = 100 - difference
    if difference == 0 {
      title = AlertScoreTitle.first
      points += 100
    }
    else if difference < 5 {
      title = AlertScoreTitle.second
      if difference == 1 {
        points += 50
      }
     } else if difference < 10 {
        title = AlertScoreTitle.third
     } else {
        title = AlertScoreTitle.forth
     }
     score += points
     return Score(title: title, points: points)
   }
       
   mutating func resetGame() {
     round = 0
     score = 0
   }
}
