//
//  Timer Controller.swift
//  PowerNapTimer
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation


class TimerController {
    var timeRemaining: TimeInterval?
    var timer: Timer?
    
    
    var isOn : Bool {
        
        // timer is on, it still have remaining time on it
        if timeRemaining != nil {
            return true
        } else {
           // timer is not on
            return false
        }
    }
    
    
    //presents time in a readable to human manner
    func timeAsString() -> String{
        
        //first round it off to int value since time interval is double
        let timeRemaining = Int(self.timeRemaining ?? 20 * 60)
        //pull minutes form time remaining
        let minutes = timeRemaining / 60
        //pull the remaining seconds
        let seconds = timeRemaining - (minutes / 60)
        
        
         
        return "\(minutes) : \(seconds)"
    }
    
    //what to do as the timer takes on
    func secondTick() {
        //checks if we have time remaining
        guard let timeRemaining = timeRemaining else {return}
        
        //make sure that the time remiining is positive, so it doesnt tun into negatives
        if timeRemaining > 0 {
            
            self.timeRemaining = timeRemaining - 1
            print(timeRemaining)
            
            //if time runs out (gets to 0)
        } else {
            //need to stop the timer
            timer?.invalidate()
            //set the time remaining to 0
            self.timeRemaining = nil
            
        }
        
        
        
    }
    
    
    //start timer, feed in the amout of seconds we want it for
    func startTimer(time: TimeInterval){
        //first check if the timer is on
        if !isOn {
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
            //then we can stop the timer
            timer?.invalidate()
            
            //reset the remaining time
            timeRemaining = nil
        }
        
        
        
        
    }
    
    
    
}
