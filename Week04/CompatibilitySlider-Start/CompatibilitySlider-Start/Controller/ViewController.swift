//
//  ViewController.swift
//  CompatibilitySlider-Start
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var compatibilityItemLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var ChangeUserBreedButton: UIButton!
    var compatibilityItems = ["Bulldog", "Maltese", "Boxer", "Poodle"] // Add more!

    var person1 = Person(id: 1, items: [:])
    var person2 = Person(id: 2, items: [:])
    var currentPerson: Person?
    var currentItemIndex = 0

    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var imgView4: UIImageView!
    @IBOutlet weak var imgView5: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPerson = person1
        setupInitialUI()
    }
    
    func setupInitialUI(){
      //Documentation says User1 but used Person1 as per screenshot
      questionLabel.text = "\(person) \(currentPerson!.id) \(questionLableText2)"
      compatibilityItemLabel.text = "\(compatibilityItems[currentItemIndex])"
    }
    
    private func showResult() {
//      ChangeUserBreedButton.titleLabel?.text = "Next User"
      let score = calculateCompatibility()
      let alert = UIAlertController(title: Results, message: "You two are \(score) compatible!", preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
        self.setupInitialUI()
      })
      alert.addAction(action)
      present(alert, animated: true)
    }
    
    func reset(person: Person) {
         slider.setValue(3, animated: true)//Default meh
         currentPerson = person
         currentItemIndex = 0
         setupInitialUI()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print("\(person) \(currentPerson!.id) :: \(compatibilityItems[currentItemIndex]) -> \(rate(sliderValue: Int(sender.value))) ")
        slider.setValue(Float(Int(sender.value)), animated: false)
    }
    
    @IBAction func didPressNextItemButton(_ sender: Any) {
        print("\(person) \(currentPerson!.id) :: \(compatibilityItems[currentItemIndex]) -> \(rate(sliderValue: Int(slider.value))) ")

        let currentItem = compatibilityItems[currentItemIndex]
        currentPerson?.items.updateValue(slider.value, forKey: currentItem)
        if currentItemIndex != compatibilityItems.count - 1 {
            currentItemIndex += 1
            setTextWithAnimation()
        }else{//All rated
            changeUser()
        }
    }
    
    private func changeUser() {
//      setQuestionLabel()
      if currentPerson?.id == 1 {
        reset(person: person2)
        currentItemIndex = 0
        setTextWithAnimation()
      } else {
        showResult()
        reset(person: person1)
      }
    }
    
    func setTextWithAnimation(){
        questionLabel.text = "\(person) \(currentPerson!.id) \(questionLableText2)"
        UIView.transition(
          with: compatibilityItemLabel,
          duration: 1,
          options: .transitionFlipFromTop,
          animations: { [weak self] in
              self?.compatibilityItemLabel.text = "\(  self?.compatibilityItems[self!.currentItemIndex] ?? "No Data")"
          }, completion: nil
        )
    }
    
    func calculateCompatibility() -> String {
        // 20% is yhe minimum match
        // If diff 0.0 is 100% and 5.0 is 0%, calculate match percentage
        var percentagesForAllItems: [Double] = []

        for (key, person1Rating) in person1.items {
            let person2Rating = person2.items[key] ?? 0
            let difference = abs(person1Rating - person2Rating)/5.0
            percentagesForAllItems.append(Double(difference))
        }
//        print(percentagesForAllItems)
        let sumOfAllPercentages = percentagesForAllItems.reduce(0, +)
        let matchPercentage = sumOfAllPercentages/Double(compatibilityItems.count)
//        print(matchPercentage, "%")
        let matchString = 100 - (matchPercentage * 100).rounded()
        return "\(matchString)%"
    }
    
    func rate(sliderValue : Int) -> String{
        var rate : String
          switch sliderValue {
          case 1:
              rate = "terrible"
          case 2:
              rate = "bad"
          case 3:
              rate = "meh"
          case 4:
              rate = "good"
          case 5:
              rate = "great"
          default:
              rate = "meh"
          }
        return rate
    }
    
    final class SnappingSlider: UISlider {
        override var value: Float {
            set { super.value = newValue }
            get {
                return round(super.value * 1.0) / 1.0
            }
        }
    }
        
    func addGesture(imageView: UIImageView){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {

        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print(tappedImage.tag)
    }
    
    func setQuestionLabel(){
        UIView.transition(
          with: questionLabel,
          duration: 1,
          options: .transitionCurlDown,
          animations: { [weak self] in
            self?.questionLabel.text = "\(person) \((self!.currentPerson!.id))\(questionLableText2)"
          }, completion: nil
        )
    }
}
