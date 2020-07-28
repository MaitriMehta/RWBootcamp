//
//  ViewController.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!

    var clues: [Clue] = []
    var correctAnswerClue: Clue?
    var points: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let imageUrl:URL = URL(string: logoImageURL) else { return }
        logoImageView.load(url: imageUrl) // Cache locally
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        getClues()
        self.scoreLabel.text = "\(self.points)"

        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }

        SoundManager.shared.playSound()
    }
    
    //# MARK : - SetupUI

    func setupUI() {
        let randomInt = Int.random(in: 0...3)
        correctAnswerClue = clues[randomInt]
        let categoryLabelText = correctAnswerClue?.category.title ?? "Data Not Availbale"
        setTextWithAnimation(with: categoryLabelText)
        clueLabel.text = correctAnswerClue?.question
        scoreLabel.text = points.description
        tableView.reloadData()
    }
    
    func setTextWithAnimation(with text: String){
          UIView.transition(
            with: categoryLabel,
            duration: 1,
            options: .transitionFlipFromTop,
            animations: { [weak self] in
                self?.categoryLabel.text = "\(text)"
            }, completion: nil
          )
    }
    
    func showFeedback(with clue: Clue) {
         guard let correctClue = correctAnswerClue else { return }
         if clue.answer == correctClue.answer {
             feedbackLabel.text = "Correct Answer! Score updated!"
             points += correctClue.value ?? 1
         } else {
             feedbackLabel.text = "Wrong Answer! The correct answer was \(correctClue.answer). Try Again!"
         }
        //Next Question
         self.getClues()
    }
       
    //# MARK : - Networking

    func getClues() {
        Networking.sharedInstance.getRandomCategory(completion: { (response, error) in
          guard let clue = response else {
              return
          }
          
          Networking.sharedInstance.getClues(clue: clue) { (response, error) in
              self.clues = response
              self.setupUI()
          }
        })
    }
    
    //# MARK : - Volume Setting
    @IBAction func didPressVolumeButton(_ sender: Any) {
        SoundManager.shared.toggleSoundPreference()
        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }
    }
}

//# MARK :  - UITableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clues.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        cell.backgroundColor = .systemGray
        cell.textLabel?.text = clues[indexPath.row].answer.capitalized
        cell.textLabel?.textAlignment = .center
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = clues[indexPath.row]
        showFeedback(with:option )
    }
}




extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }

        self = url
    }
}
