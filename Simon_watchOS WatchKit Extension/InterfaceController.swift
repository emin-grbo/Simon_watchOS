//
//  InterfaceController.swift
//  Simon_watchOS WatchKit Extension
//
//  Created by Emin Roblack on 12/13/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  
  @IBOutlet weak var red: WKInterfaceButton!
  @IBOutlet weak var yellow: WKInterfaceButton!
  @IBOutlet weak var green: WKInterfaceButton!
  @IBOutlet weak var blue: WKInterfaceButton!
  
  var isWatching: Bool = true {
    didSet {
      if isWatching {
        setTitle("WATCH!")
      } else {
        setTitle("REPEAT!")
      }
    }
  }
  
  var sequence = [WKInterfaceButton]()
  var sequenceIndex = 0
  
  
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        startNewGame()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
  
  func startNewGame() {
    sequence.removeAll()
    addToSequence()
  }
  
  
  
  func addToSequence() {
    // add a random button to our sequence
    let colors: [WKInterfaceButton] = [red, yellow, green, blue]
    sequence.append(colors.randomElement()!)
    
    // start the flashing at the beginning
    sequenceIndex = 0
    
    // update player instructions
    isWatching = true
    
    // give some time to the player and then start flashing
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
      self.playNextSequenceItem()
    }
  }
  
  
  
  func playNextSequenceItem() {
    // stop flashing if sequence is done
    guard sequenceIndex < sequence.count else {
      isWatching = false
      sequenceIndex = 0
      return
    }
    
    // otherwise move sequence forward
    let button = sequence[sequenceIndex]
    sequenceIndex += 1
    
    // wait fraction of a second before flashing
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      button.setTitle("•")
    }
    // wait again
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      button.setTitle("")
      self.playNextSequenceItem()
    }
  }
  
  
  
  func makeMove(_ color: WKInterfaceButton) {
    // don't let the player touch stuff while in watch mode
    guard isWatching == false else { return }
    
    if sequence[sequenceIndex] == color {
      // they were correct! Increment the sequence index.
      sequenceIndex += 1
      
      if sequenceIndex == sequence.count {
        // they made it to the end; add another button to the sequence
        addToSequence()
      }
    } else {
      // they were wrong! End the game.
      let playAgain = WKAlertAction(title: "Play Again", style: .default) {
        self.startNewGame()
      }
      
      presentAlert(withTitle: "Game over!", message: "You scored \(sequence.count - 1).", preferredStyle: .alert, actions: [playAgain])
    }
  }
  
  
  
  @IBAction func redTapped() {
    makeMove(red)
  }
  @IBAction func yellowTapped() {
    makeMove(yellow)
  }
  @IBAction func greenTapped() {
    makeMove(green)
  }
  @IBAction func blueTapped() {
    makeMove(blue)
  }
  

}
