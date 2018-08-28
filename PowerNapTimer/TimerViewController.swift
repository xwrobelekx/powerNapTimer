//
//  TimerViewController.swift
//  PowerNapTimer
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    //after declaring all the functionality of the timer in timer controller, we need to work on presenting or cominicating  with them
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerButtonLabel: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
     
        TimerController.shared.startTimer(time: 20)
    }




    @IBAction func timerButtonTapped(_ sender: Any) {
    }
}

