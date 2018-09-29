//
//  TriviaViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 11/12/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class TriviaViewController: UIViewController{

    @IBOutlet weak var questionOutlet: UILabel!
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    @IBOutlet weak var answerD: UIButton!
    
    @objc var correct: Int = 0
    @objc var gameView: GameViewController? = nil
    // Number of points you get for answering a question correct.
    @objc var pointsCorrect = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // random number for firebase question
        let randomNum:Int = Int(arc4random_uniform(5)) + 1
        // random number to choose which one should be the correct answer
        self.correct = Int(arc4random_uniform(4)) + 1
        let ref = FIRDatabase.database().reference(withPath: "trivia")
        ref.child("question\(randomNum)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            // A is the correct answer
            if self.correct == 1
            {
                self.questionOutlet.text = value?["question"] as? String
                self.answerA.setTitle(value?["answertrue"] as? String, for: .normal)
                self.answerB.setTitle(value?["answer1"] as? String, for: .normal)
                self.answerC.setTitle(value?["answer2"] as? String, for: .normal)
                self.answerD.setTitle(value?["answer3"] as? String, for: .normal)
            }
            // B is the correct answer
            else if self.correct == 2
            {
                self.questionOutlet.text = value?["question"] as? String
                self.answerB.setTitle(value?["answertrue"] as? String, for: .normal)
                self.answerA.setTitle(value?["answer1"] as? String, for: .normal)
                self.answerC.setTitle(value?["answer2"] as? String, for: .normal)
                self.answerD.setTitle(value?["answer3"] as? String, for: .normal)
            }
            // C is the correct answer
            else if self.correct == 3
            {
                self.questionOutlet.text = value?["question"] as? String
                self.answerC.setTitle(value?["answertrue"] as? String, for: .normal)
                self.answerB.setTitle(value?["answer1"] as? String, for: .normal)
                self.answerA.setTitle(value?["answer2"] as? String, for: .normal)
                self.answerD.setTitle(value?["answer3"] as? String, for: .normal)
            }
            // D is the correct answer
            else
            {
                self.questionOutlet.text = value?["question"] as? String
                self.answerD.setTitle(value?["answertrue"] as? String, for: .normal)
                self.answerB.setTitle(value?["answer1"] as? String, for: .normal)
                self.answerA.setTitle(value?["answer2"] as? String, for: .normal)
                self.answerC.setTitle(value?["answer3"] as? String, for: .normal)
                
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func answerAPicked(_ sender: Any) {
        if self.correct == 1
        {
            self.gameView!.scene?.gameScore += pointsCorrect
            self.gameView!.scene?.scoreLabel.text = "Score: \((self.gameView!.scene?.gameScore)!)"
        }
        self.gameView!.scene?.pauseUnpauseGame()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func answerBPicked(_ sender: Any) {
        if self.correct == 2
        {
            self.gameView!.scene?.gameScore += pointsCorrect
            self.gameView!.scene?.scoreLabel.text = "Score: \((self.gameView!.scene?.gameScore)!)"
        }
        self.gameView!.scene?.pauseUnpauseGame()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func answerCPicked(_ sender: Any) {
        if self.correct == 3
        {
            self.gameView!.scene?.gameScore += pointsCorrect
            self.gameView!.scene?.scoreLabel.text = "Score: \((self.gameView!.scene?.gameScore)!)"
        }
        self.gameView!.scene?.pauseUnpauseGame()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func answerDPicked(_ sender: Any) {
        if self.correct == 4
        {
            self.gameView!.scene?.gameScore += pointsCorrect
            self.gameView!.scene?.scoreLabel.text = "Score: \((self.gameView!.scene?.gameScore)!)"
        }
        self.gameView!.scene?.pauseUnpauseGame()
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
