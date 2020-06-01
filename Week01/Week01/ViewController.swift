//
//  ViewController.swift
//  Week01
//
//  Created by Maitri Mehta on 5/31/20.
//  Copyright © 2020 Maitri. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    @IBOutlet weak var lblColorName: UILabel!
    @IBOutlet weak var lblRed: UILabel!
    @IBOutlet weak var lblGreen: UILabel!
    @IBOutlet weak var lblBlue: UILabel!
    
    var red = 0, green = 0, blue = 0
    var color = "Purple"

    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        
    }
    
    @IBAction func setColor(){
        var txtColor: UITextField?
        let alertController = UIAlertController(title: "Pick a color", message: "Pick a color and press Enter", preferredStyle: .alert)
        alertController.addTextField { (usernameTextField) in
            txtColor = usernameTextField
            txtColor?.placeholder = "Enter your color"
        }
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] (_) in
            _ = alertController?.textFields![0]
            self.color = txtColor!.text ?? "No color selected"
            self.lblColorName.text = self.color.uppercased()
            self.updateColor(red:self.red, green: self.green, blue: self.blue)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func reset(){
      lblColorName.text = "Pick the Color from slider"
        sliderRed.value = 0
        sliderBlue.value = 0
        sliderGreen.value = 0
        lblBlue.text = "0"
        lblGreen.text = "0"
        lblRed.text = "0"
        red = 0
        blue = 0
        green = 0
        
    }
  @IBAction func redSliderMoved(_ slider: UISlider){
      red = Int(slider.value.rounded())
      lblRed.text = String(red)
    updateSliderColor(red: red, green: green, blue: blue)
    
  }
  @IBAction func greenSliderMoved(_ slider: UISlider){
      green = Int(slider.value.rounded())
      lblGreen.text = String(green)
      updateSliderColor(red: red, green: green, blue: blue)
  }
    @IBAction func blueSliderMoved(_ slider: UISlider){
        blue = Int(slider.value.rounded())
        lblBlue.text = String(blue)
        updateSliderColor(red: red, green: green, blue: blue)
    }
 
    
    func updateSliderColor(red:Int,green:Int,blue:Int){
        lblColorName.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
        print("\(red) , \(green) , \(blue)")
    }
    
    func updateColor(red:Int,green:Int,blue:Int){
        view.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }

    @IBAction func modeChanged(_ sender: Any){
        
    }

}

