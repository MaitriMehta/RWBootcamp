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
        self.house1 =  House(address: "d", price: "444", bedrooms: "4")
        setUpLeftSideUI()
    }

    func setUpLeftSideUI() {
      if house1 == nil {
        titleLabelLeft.alpha = 0
        imageViewLeft.alpha = 0
        priceLabelLeft.alpha = 0
        roomLabelLeft.alpha = 0
      } else {
        titleLabelLeft.text = house1!.address!
        priceLabelLeft.text = house1!.price!
        roomLabelLeft.text = house1!.bedrooms!
        titleLabelLeft.alpha = 1
        imageViewLeft.alpha = 1
        priceLabelLeft.alpha = 1
        roomLabelLeft.alpha = 1
        }
    }

    func setUpRightSideUI() {
        if house2 == nil {
            titleLabelRight.alpha = 0
            imageViewRight.alpha = 0
            priceLabelRight.alpha = 0
            roomLabelRight.alpha = 0
        } else {
            titleLabelRight.text! = house2!.address!
            priceLabelRight.text! = house2!.price!
            roomLabelRight.text! = house2!.bedrooms!
            titleLabelRight.alpha = 1
            imageViewRight.alpha = 1
            priceLabelRight.alpha = 1
            roomLabelRight.alpha = 1
        }
    }

    @IBAction func didPressAddRightHouseButton(_ sender: Any) {
        openAlertView()
    }

    func openAlertView() {
        let alert = UIAlertController(title: "New House", message: "Add Details", preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Address"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Price"
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Bedrooms"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            self.house2 = House(
                address: (alert.textFields?[0].text)!,
                price: alert.textFields?[1].text ?? "0",
                bedrooms: alert.textFields?[2].text ?? "0 Bedrooms")
            self.setUpRightSideUI()
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
