//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  //MARK: - IBOutlets
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
    
  //MARK: - Initializer
  var bullsEyeGame = BullsEyeGame()
  var quickDiff: Int {
     return abs(bullsEyeGame.targetValue - bullsEyeGame.currentValue)
   }
  //MARK: - UIViewController Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    bullsEyeGame.startNewRound()
    updateViews()
    updateSliderView()
  }

  //MARK:- IBAction Events
  @IBAction func showAlert() {
    
    let score = bullsEyeGame.calculateScore()
    let message = "You scored \(score.points) points"//needs to be generalized ?
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: alertOkButtonText, style: .default, handler: {
      action in
        self.bullsEyeGame.startNewRound()
        self.updateViews()
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
    
  func updateSliderView(){
    let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
     slider.setThumbImage(thumbImageNormal, for: .normal)
     
     let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
     slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
     
     let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
     
     let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
     let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
     slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
     
     let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
     let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
     slider.setMaximumTrackImage(trackRightResizable, for: .normal)
     slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)

  }
  @IBAction func sliderMoved(_ slider: UISlider) {
      let roundedValue = slider.value.rounded()
      bullsEyeGame.currentValue = Int(roundedValue)
  }
    
  @IBAction func startNewGame() {
    bullsEyeGame.resetGame()
    bullsEyeGame.startNewRound()
    updateViews()

  }
    
  func updateViews() {
    slider.value = Float(bullsEyeGame.currentValue)
    targetLabel.text = String(bullsEyeGame.targetValue)
    scoreLabel.text = String(bullsEyeGame.score)
    roundLabel.text = String(bullsEyeGame.round)
    slider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(CGFloat(quickDiff)/100.0)
  }
}
