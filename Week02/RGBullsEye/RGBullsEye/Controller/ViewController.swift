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

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var targetTextLabel: UILabel!
  @IBOutlet weak var guessLabel: UILabel!
  
  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  var game = BullsEyeGame(score: 0, round: 0)
  var rgb = RGB()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    game.startNewRound()
    updateViews()
  }
    
  @IBAction func aSliderMoved(sender: UISlider) {
    let redValue = Int(redSlider.value.rounded())
    let blueValue = Int(blueSlider.value.rounded())
    let greenValue = Int(greenSlider.value.rounded())
    game.currentValue = RGB(r: redValue, g: greenValue, b: blueValue)
    updateViews()
  }
  
  @IBAction func showAlert(sender: AnyObject) {
    let score = game.calculateScore()
    let message = "You scored \(score.points) points"//?
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: alertOkButtonText, style: .default, handler: {
        action in
          self.game.startNewRound()
          self.updateViews()
      })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func startOver(sender: AnyObject) {
    game.resetGame()
    game.startNewRound()
    updateViews()
  }
  
  func updateViews() {
    redSlider.value = Float(game.currentValue.r)
    greenSlider.value = Float(game.currentValue.g)
    blueSlider.value = Float(game.currentValue.b)
    redLabel.text = String(Int(redSlider.value))
    greenLabel.text = String(Int(greenSlider.value))
    blueLabel.text = String(Int(blueSlider.value))
    roundLabel.text = "Round: \(Int(game.round))"
    scoreLabel.text = "Score: \(Int(game.score))"
//    targetTextLabel.text = message
    targetLabel.backgroundColor = UIColor(rgbStruct: game.targetValue)
    guessLabel.backgroundColor = UIColor(rgbStruct: game.currentValue)
    print(game.targetValue.r)
  }
}
