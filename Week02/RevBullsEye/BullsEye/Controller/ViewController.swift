//
//  ViewController.swift
//  BullsEye
//
//  Created by Ray Wenderlich on 6/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

  //MARK: - IBOutlets
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet var textField: UITextField!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var hitMeButton : UIButton!
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
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeypad))
    view.addGestureRecognizer(tap)
    
    RevBullsEyeView()
  }
  
  func RevBullsEyeView (){
        textField.isHidden = false
        targetLabel.isHidden = true
        slider.isUserInteractionEnabled = false
  }
    
  //MARK:- IBAction Events
  @IBAction func showAlert() {   
    guard let userGuess = textField.text else{ return }
    let input = Int(userGuess)
    bullsEyeGame.currentValue = input!
    let score = bullsEyeGame.calculateScore(guessValue: input ?? 0)
    let message = "You scored \(score.points) points"//needs to be generalized ?
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: alertOkButtonText, style: .default, handler: {
      action in
        self.bullsEyeGame.startNewRound()
        self.updateViews()
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    updateViews()
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
      bullsEyeGame.currentValue = Int(slider.value.rounded())
  }
    
  @IBAction func startNewGame() {
    bullsEyeGame.resetGame()
    bullsEyeGame.startNewRound()
    updateViews()
  }
    
  func updateViews() {
    textField.text = ""
    hitMeButton.isEnabled = false
    slider.value = Float(bullsEyeGame.targetValue)
    roundLabel.text = "\(bullsEyeGame.round)"
    scoreLabel.text = "\(bullsEyeGame.score)"
  }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 2
    }
    
    @objc func dismissKeypad(){
        textField.endEditing(true)
        hitMeButton.isEnabled = true
    }

    @IBAction func toggleButtonTapped(){
        
    }
}
