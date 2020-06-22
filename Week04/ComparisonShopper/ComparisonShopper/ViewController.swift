//
//  ViewController.swift
//  ComparisonShopper
//
//  Created by Jay Strawn on 6/15/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Left
    @IBOutlet weak var titleLabelLeft: UILabel!
    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var priceLabelLeft: UILabel!
    @IBOutlet weak var roomLabelLeft: UILabel!

    // Right
    @IBOutlet weak var titleLabelRight: UILabel!
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var priceLabelRight: UILabel!
    @IBOutlet weak var roomLabelRight: UILabel!

    var house1: House?
    var house2: House?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRightSideUI()
        self.house1 =  House(address: "Palo Alto", price: "2200", bedrooms: "1")
        setUpLeftSideUI()
    }

    func setUpLeftSideUI() {
      if house1 == nil {
       hideLeft()
      } else {
        titleLabelLeft.text = house1!.address!
        priceLabelLeft.text = house1!.price!
        roomLabelLeft.text = house1!.bedrooms!
        seekLeft()
        }
    }

    func setUpRightSideUI() {
        if house2 == nil {
           hideRight()
        } else {
            titleLabelRight.text! = house2!.address!
            priceLabelRight.text! = house2!.price!
            roomLabelRight.text! = house2!.bedrooms!
            hideNseekRight()
        }
    }
    
    func hideNseekRight(){
        titleLabelRight.alpha = (titleLabelRight.alpha == 1 ) ?  0 : 1
        imageViewRight.alpha = 1
        priceLabelRight.alpha = 1
        roomLabelRight.alpha = 1
    }
    
    func hideRight(){
      titleLabelRight.alpha = 0
      imageViewRight.alpha = 0
      priceLabelRight.alpha = 0
      roomLabelRight.alpha = 0
    }
    
    func seekLeft(){
        titleLabelLeft.alpha = 1
        imageViewLeft.alpha = 1
        priceLabelLeft.alpha = 1
        roomLabelLeft.alpha = 1
    }
    
    func hideLeft(){
      titleLabelLeft.alpha = 0
      imageViewLeft.alpha = 0
      priceLabelLeft.alpha = 0
      roomLabelLeft.alpha = 0
    }
    
    @IBAction func didPressAddRightHouseButton(_ sender: Any) {
        openAlertView()
    }

    func openAlertView() {
        let alert = UIAlertController(title: alertAddNewHouseTitle, message: alertAddNewHouseMessage, preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.placeholder = address
        }

        alert.addTextField { (textField) in
            textField.placeholder = price
        }

        alert.addTextField { (textField) in
            textField.placeholder = bedrooms
            textField.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler:nil))

        alert.addAction(UIAlertAction(title: ok, style: .default, handler:{ (UIAlertAction) in
            self.house2 = House(
                address: alert.textFields?[0].text.noDataIfEmpty,
                price: alert.textFields?[1].text.noDataIfEmpty,
                bedrooms: alert.textFields?[2].text.noDataIfEmpty)
            self.setUpRightSideUI()
        }))

        self.present(alert, animated: true, completion: nil)
    }
}


extension Optional where Wrapped == String {
    var noDataIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? noData : strongSelf
    }
}
