//
//  ViewController.swift
//  simpleLogger
//
//  Created by Angel Kukushev on 2/19/15.
//  Copyright (c) 2015 Angel Kukushev. All rights reserved.
//

import UIKit

extension NSDate {
    var formatted: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.stringFromDate(self)
    }
}



class ViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.text = log(2, message: "Hello World")
      
    }
    
    func log(var level: Int, message: String) -> String{
        

        var levelMsg: String
        if(level == 1){
            levelMsg = "INFO"
        }
        else if(level == 2){
            levelMsg = "WARNING"
        }
        else if(level == 3){
            levelMsg = "PLSCHECKFFS"
        }
        else{
            levelMsg = "WRONG LEVEL INPUT"
        }
        
        
        var timestamp: String = NSDate().formatted
        
        var logMessage = NSString(format:"{%@}::{%@}::{%@}", levelMsg , timestamp , message) as String
       
        
        return logMessage
    }
    
}

