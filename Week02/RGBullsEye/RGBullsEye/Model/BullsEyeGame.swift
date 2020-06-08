/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation

struct Score {
  var title : String
  var points : Int
    
  public init(title: String, points: Int) {
    self.title = title
    self.points = points
  }
}

struct BullsEyeGame {
  
  var currentValue = RGB()
  var targetValue = RGB()
  var score: Int
  var round: Int
    
  
  mutating func startNewRound() {
      round += 1
      targetValue = RGB(r: Int.random(in: 1...255), g: Int.random(in: 1...255), b: Int.random(in: 1...255))
  }
    
  mutating func calculateScore() -> Score {
    let title: String
    let difference = Int(targetValue.difference(target: currentValue) * 100)
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

