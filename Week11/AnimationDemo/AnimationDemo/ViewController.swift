//
//  ViewController.swift
//  AnimationDemo
//
//  Created by Maitri Mehta on 8/5/20.
//  Copyright © 2020 Maitri Mehta. All rights reserved.
//

import UIKit
import Lottie
import UserNotifications

class ViewController: UIViewController {
      //MARK:- IB Outlets
     private var animationView: AnimationView?
    
     @IBOutlet weak var animateImage: UIImageView!
     @IBOutlet weak var menuButton: UIButton!
     @IBOutlet weak var leftButton: UIButton!
     @IBOutlet weak var upButton: UIButton!
     @IBOutlet weak var rightButton: UIButton!
     @IBOutlet private weak var bannerView: UIView!
     @IBOutlet private weak var bannerLabel: UILabel!

      //MARK:- Constraints
      @IBOutlet weak var upButtonToMenuConstraint: NSLayoutConstraint!
      @IBOutlet weak var rightButtonToMenuConstraint: NSLayoutConstraint!
      @IBOutlet weak var leftButtonToMenuConstraint: NSLayoutConstraint!
      @IBOutlet private weak var bannerTopConstraint: NSLayoutConstraint!

      //MARK:- Variables
      private var menuIsOpen = false
      var animator = UIViewPropertyAnimator()
      private var isBannerOpen = false
      
      override func viewDidLoad() {
          super.viewDidLoad()
          setConstraints()
          addAnimatedObject()
        self.bannerLabel.text = ""
    }
    
    func addAnimatedObject(){
        animationView = .init(name: "cat")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
        view.sendSubviewToBack(animationView!)
    }
    
      func setConstraints() {
          upButtonToMenuConstraint.constant = menuIsOpen ? 30 : -80
          rightButtonToMenuConstraint.constant = menuIsOpen ? 30 : -80
          leftButtonToMenuConstraint.constant = menuIsOpen ? 30 : -80
          self.bannerTopConstraint.constant = isBannerOpen ? 20 : -140

        menuButton.backgroundColor = menuIsOpen ? .clear : .orange

      }
    
      //MARK:- IBAction
      @IBAction func toggleMenu(_ sender: UIButton) {
          menuIsOpen.toggle()
          setConstraints()
          UIView.animate(withDuration: 1,
                                delay: 0,
               usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.7,
                              options: .allowUserInteraction,
                           animations: { self.view.layoutIfNeeded() }
          )
          
          if menuIsOpen == false {
              animator.startAnimation()
          }
      }
    
    @IBAction func btnLeftTapped(){
        animator.addAnimations {
                UIView.animate(
                  withDuration: 1,
                    animations: { self.animationView!.frame.origin.x -= 80}){_ in
                      UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: { self.animationView!.frame.origin.x += 80
                    })
         }
        }
        displayBanner(message: "Horizontal animation added successfully!")

    }
        
    @IBAction func btnUpTapped(){
        animator.addAnimations {
          UIView.animate(withDuration: 1) {
            self.animationView!.alpha = 0.6
            self.animationView?.logHierarchyKeypaths()
            self.animationView?.setValueProvider(ColorValueProvider(UIColor.random().lottieColorValue),
                                                 keypath: AnimationKeypath(keypath: "face.**.Fill 1.Color"))
            let isDarkUI = self.traitCollection.userInterfaceStyle == .dark
            let color: UIColor = isDarkUI ? .yellow : .gray

            self.animationView?.setValueProvider(ColorValueProvider(color.lottieColorValue),
                                            keypath: AnimationKeypath(keypath: "body 2.**.Fill 1.Color"))
          }
        }
        displayBanner(message: "Alpha and face color animation added successfully!")
    }
    
    @IBAction func btnRightTapped(){
      animator.addAnimations {
        UIView.animate(
          withDuration: 1,
          animations: { self.animationView!.frame.origin.y -= 80}){_ in
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: { self.animationView!.frame.origin.y += 80
          })
          }
        }
        displayBanner(message: "Jump animation added successfully!")
    }
    
    func reset(){
        //Remove animation from animator
        
    }
    
   private func displayBanner(message: String) {
     if isBannerOpen { return }
     isBannerOpen = true
     bannerLabel.text = message

     view.bringSubviewToFront(bannerView)
     bannerTopConstraint?.constant = 0
     UIView.animate(withDuration: 0.4, animations: {
       self.view.layoutIfNeeded()
     }) { _ in
       self.bannerTopConstraint.constant = -140
       UIView.animate(withDuration: 0.3, delay: 1, animations:  {
         self.view.layoutIfNeeded()
       }) { _ in
         self.bannerLabel.text = ""
         self.isBannerOpen = false
       }
     }

   }

}

extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
}

extension UIColor {
  static func random() -> UIColor {
    return UIColor(
      red:   .random(),
      green: .random(),
      blue:  .random(),
      alpha: 1.0
   )}
}
