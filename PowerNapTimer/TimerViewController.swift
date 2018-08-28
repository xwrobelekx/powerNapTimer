//
//  TimerViewController.swift
//  PowerNapTimer
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit
//#4 adopt the protocol
class TimerViewController: UIViewController, TimerControllerDelegate {
    
    
    
    //#5 
    var identifier = "PowerNapTimerIdentyfier"
    var timeRemaining: TimeInterval? = TimerController.shared.timeRemaining
    
    //after declaring all the functionality of the timer in timer controller, we need to work on presenting or comunicating  with them
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerButtonLabel: UIButton!
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this is saying that i will be your delegate, i will be your boss
        TimerController.shared.delegate = self
        
    }
//helper function to update labels
    func updateView() {
        updateButton()
        updateTimerLabel()
    }
    
    //updates the button based on if the timer is running or not
    func updateButton(){
        if TimerController.shared.isOn {
            //in order to change button text u need to use this, wont work on text proerty
            timerButtonLabel.setTitle("Stop Timer", for: .normal)
        } else {
            timerButtonLabel.setTitle("Start Timer", for: .normal)
        }
        
    }
    
    
    
    
    func updateTimerLabel(){
        // we can use the func that we had in timer controller that returnet time as sting
        timeLabel.text = TimerController.shared.timeAsString()
        
    }

    // we want to start and top the timer in the middle of running
    @IBAction func timerButtonTapped(_ sender: Any) {
        let timerIsOn = TimerController.shared.isOn
        
        //if timer is running we cans stop it
        if timerIsOn {
            TimerController.shared.stopTimer()
            
        } else {
        
        TimerController.shared.startTimer(time: 5)
            //call the notification
            scheduleLocalNotification()
        }
        
        updateView()
    }
    
    //MARK: - Delegate Functions
    //#5 conform to the protocol
    func timerSecondTick() {
        // we just have to update the timer label, no need to update the entire view
        updateTimerLabel()
    }
    
    func timerCompleted() {
        // when timer completes we want to pop up an alert, and update view
        updateView()
        presentAlertController()
       
    }
    
    func timerStopped() {
        updateView()
    }
    
    
    // MARK: - notifications?
    
    func presentAlertController(){
        // we need a textfield that is accesible in this whole function
        var snoozeTextField: UITextField?
        
        let alertController = UIAlertController(title: "Wake Up", message: "Time to Wake up", preferredStyle: .alert)
        //add text field for alert
        alertController.addTextField { (textField) in
            //add placeholder text
            textField.placeholder = "pass in more minutes"
            //specifie keybord type
            textField.keyboardType = .numberPad
            //we need to assign it t the global text field bc this one is locekd in the closure
            snoozeTextField = textField
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let snoozeAction = UIAlertAction(title: "Snooze", style: .default) { (_) in
            // we need the text field to get the amout of minutes the usr want to snooze for
           guard let snoozeTime =  snoozeTextField?.text,
            let time = TimeInterval(snoozeTime) else {return}
            //start the timer again annded 1 so it would update the view faster
            TimerController.shared.startTimer(time: time + 1)
            //update view
            self.updateView()
        }
        // add the actions to the alert
        alertController.addAction(dismissAction)
        alertController.addAction(snoozeAction)
        
        present(alertController, animated: true)
        
    }
    
}











