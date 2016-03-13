//
//  ViewController.swift
//  Project8
//
//  Created by Nicolas Audren on 09/03/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score: Int = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1
    
    var answersFound = 0
    
    var totalAnswers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: "letterTapped:", forControlEvents: .TouchUpInside)
        }
        
        loadLevel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func submitTapped(sender: UIButton) {
        if let index = solutions.indexOf(currentAnswer.text!) {
            
            var answers = answersLabel.text!.componentsSeparatedByString("\n")
            
            answers[index] = currentAnswer.text!
            
            answersLabel.text = answers.joinWithSeparator("\n")
            
            activatedButtons.removeAll()
            
            currentAnswer.text = ""
            
            score++
            
            answersFound++
            
            if answersFound == totalAnswers {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
                presentViewController(ac, animated: true, completion: nil)
            }
        }
        else {
            score--
        }
    }
    
    func levelUp(action: UIAlertAction!) {
        level += 1
        solutions.removeAll(keepCapacity: true)
        answersFound = 0
        
        loadLevel()
        
        for btn in letterButtons {
            btn.hidden = false
        }
    }
    
    @IBAction func clearTapped(sender: UIButton) {
        for button in activatedButtons {
            button.hidden = false
        }
        
        activatedButtons.removeAll()
        currentAnswer.text = ""
    }
    
    func letterTapped(sender: UIButton) {
        currentAnswer.text = currentAnswer.text! + sender.titleLabel!.text!
        activatedButtons.append(sender)
        sender.hidden = true
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        totalAnswers = 0
        
        if let levelFilePath = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelFilePath, usedEncoding: nil) {
                var lines = levelContents.componentsSeparatedByString("\n")
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(lines) as! [String]
                
                for (index, line) in lines.enumerate() {
                    let parts = line.componentsSeparatedByString(": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "")
                    solutionString += "\(solutionWord.characters.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.componentsSeparatedByString("|")
                    letterBits += bits
                    
                    totalAnswers++
                }
            }
        }
        
        // Now configure the buttons and labels
        cluesLabel.text = clueString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        
        answersLabel.text = solutionString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterBits) as! [String]
        letterButtons = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterButtons) as! [UIButton]

        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], forState: .Normal)
            }
        }
        
    }

}

