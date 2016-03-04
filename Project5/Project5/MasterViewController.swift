//
//  MasterViewController.swift
//  Project5
//
//  Created by Nicolas Audren on 16/02/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit
import GameplayKit

class MasterViewController: UITableViewController {

    var objects = [String]()
    
    var allWords = [String]()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        if let startPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startPath, usedEncoding: nil ) {
                allWords = startWords.componentsSeparatedByString("\n")
            }
            else {
                loadDefaultWord()
            }
        }
        else {
            loadDefaultWord()
        }
        
        startGame()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Game functions
    
    func loadDefaultWord() {
        allWords = ["silkworm"]
    }
    
    func startGame() {
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
        title = allWords[0]
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { [unowned self, ac] _ in
            let answer = ac.textFields![0]
            self.submitAnswer(answer.text!)
        }
        
        ac.addAction(submitAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func submitAnswer(answer: String) {
        let lowerAnswer = answer.lowercaseString
        
        if lowerAnswer != title!.lowercaseString {
            if wordIsPossible(lowerAnswer) {
                if wordIsOriginal(lowerAnswer) {
                    if wordIsReal(lowerAnswer) {
                        objects.insert(answer, atIndex: 0)
                        
                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                    else {
                        showErrorMessage("Word not recognised", message: "You can't just make them up, you know!")
                    }
                }
                else {
                    showErrorMessage("Word used already", message: "Be more original!")
                }
            }
            else {
                showErrorMessage("Word not possible", message: "You can't spell that word from '\(title!.lowercaseString)'!")
            }
        }
        else {
            showErrorMessage("Same word", message: "Nice try!")
        }
        
    }
    
    func wordIsPossible(word: String) -> Bool {
        var tempWord = title!.lowercaseString
        
        for letter in word.characters {
            if let pos = tempWord.rangeOfString(String(letter)) {
                tempWord.removeAtIndex(pos.startIndex)
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    func wordIsOriginal(word: String) -> Bool {
        return !objects.contains(word)
    }
    
    func wordIsReal(word: String) -> Bool {
        // Disallow words with less than 3 characters
        if word.characters.count < 3 {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }
}

