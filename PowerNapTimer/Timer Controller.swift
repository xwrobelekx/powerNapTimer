//
//  Timer Controller.swift
//  PowerNapTimer
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation
import UserNotifications

//#1 step one declare protocol
protocol TimerControllerDelegate: class{
    //#4
    var identifier : String {get}
    var timeRemaining: TimeInterval? {get set}
    
    func timerSecondTick()
    func timerCompleted()
    func timerStopped()
    
    
}


extension TimerControllerDelegate {
    
    //default inplemetation of a function
    func scheduleLocalNotification(){
        
        //#9 content for notification request
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Wake UP"
        notificationContent.body = "No... Seriously Wake up"
        
        guard let timeRemaining = TimerController.shared.timeRemaining else {return}
        
        //#8 date "since" return the date of when the code runs
        let date = Date(timeInterval: timeRemaining, since: Date())
        
        //#7
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: date)
        
        //#6
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //#2.1 every notification need unique identifier uuid set it in protocol and confrom to it in VC
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        
        
        //#1
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add Notification Request. \(error), \(error.localizedDescription)")
            }
        }
        //#2 lookup UNNotificationrequest
        
    }
    
}










class TimerController {
    //#3
    var identifier = "PowerNapTimerIdentyfier"
    var timeRemaining: TimeInterval?
    var timer: Timer?
    
    static let shared = TimerController()
    
    
    var isOn : Bool {
        
        // timer is on, it still have remaining time on it
        if timeRemaining != nil {
            return true
        } else {
           // timer is not on
            return false
        }
    }
    
    //#2 the hook?
    weak var delegate : TimerControllerDelegate?
    
    
    //presents time in a readable to human manner as a string
    func timeAsString() -> String{
        
        //first round it off to int value since time interval is double
        let timeRemaining = Int(self.timeRemaining ?? 20 * 60)
        //pull minutes form time remaining
        let minutes = timeRemaining / 60
        //pull the remaining seconds
        let seconds = timeRemaining - (minutes * 60)
        
        //this is an initializer for string, which return better formated string
        // the 2 stands for how many digits, and d replaces the value with the one from array
        //and array holds the minutes and seconds
        return String(format: "%02d : %02d", arguments: [minutes, seconds])
    }
    
    //what to do as the timer takes on
    func secondTick() {
        //checks if we have time remaining
        guard let timeRemaining = timeRemaining else {return}
        print("time remaining \(timeRemaining)")
        
        //make sure that the time remiining is positive, so it doesnt tun into negatives
        if timeRemaining > 0 {
            
            print("time is running....")
            self.timeRemaining = timeRemaining - 1
            //#3 notifies the parent that the second goes by
            delegate?.timerSecondTick()
            
            print(timeRemaining)
            
            
            //if time runs out (gets to 0)
        } else {
            //need to stop the timer
            print("runned out of seconds, - stopping timer")
            timer?.invalidate()
            
            
            //set the time remaining to nil not 0
            self.timeRemaining = nil
            //#3.2 notifie the paternt that the timer completed
            delegate?.timerCompleted()
            
        }
        
        
        
    }
    
    
    //start timer, feed in the amout of seconds we want it for
    func startTimer(time: TimeInterval){
        //first check if the timer is on
        if !isOn {
            print("timer is on")
            //if timer is not set then set the time to the remaining time (how long is this timer run for)
            timeRemaining = time
            
            //this means to put this on the main thread, the fast line
            DispatchQueue.main.async {
                //
                self.secondTick()
                //schedule timer to repeat everysecond
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    //repeats this code every second
                    self.secondTick()
                })
            }
        }
        
    }
    
    // stops timer
    func stopTimer() {
        //first we need to chack if the timer is on
        if isOn {
            print("timer is running, now were stopping it manually.")
            //then we can stop the timer
            timer?.invalidate()
            
            //reset the remaining time
            timeRemaining = nil
            //#3.3 notifie the parent that the timer stopped
            delegate?.timerStopped()
        }
        
        
        
        
    }
    
    
    
}
