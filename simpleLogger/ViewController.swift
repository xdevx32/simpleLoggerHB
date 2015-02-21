//
//  ViewController.swift
//  simpleLogger
//
//  Created by Angel Kukushev on 2/19/15.
//  Copyright (c) 2015 Angel Kukushev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //base case test
        //let logger = HTTPLogger(level: 1, message: "HelloHTTP")
        let consoleLogger = ConsoleLogger(level: 1, message: "Hello Console")
        consoleLogger.consoleLog(consoleLogger.level, message: consoleLogger.message)
        
        let myDefaultLogger = MyLogger(level: 2, message: "Hello World")
        messageLabel.text = myDefaultLogger.log(myDefaultLogger.level, message: myDefaultLogger.message)

        
        // console logger test
       // let consoleLogger = ConsoleLogger()
       // consoleLogger.consoleLog(1, message: "ConsoleLogger")
        
        //HTTPLogger test
      ///  let htLogger = HTTPLogger(level: 1,message: "Hello World"
       // htLogger.log(1, message: "HTTPPPPP")
    }
}


extension NSDate {
    var formatted: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.stringFromDate(self)
    }
}

class MyLogger{
    
    var level: Int = 0
    var message: String = ""
    
    init (level: Int, message: String){
    self.level = level
    self.message = message
    }
    
    func log(level: Int, message: String) -> String{
        
        var levelMsg: String
    
        switch level {
        case 1:
            levelMsg = "INFO"
        case 2:
            levelMsg = "WARNING"
        case 3:
            levelMsg = "PLSCHECKFFS"
        default:
            levelMsg = "WRONG LEVEL INPUT"
        }
        
        
        var timestamp: String = NSDate().formatted
        
        var logMessage = NSString(format:"{%@}::{%@}::{%@}", levelMsg , timestamp , message) as String
        
        
        return logMessage
    }

}

class ConsoleLogger: MyLogger {
    
   func consoleLog(var level: Int, message: String){
        println(log(level, message: message))
    }
}

class FileLogger: MyLogger {
  func fileLog(var level: Int, message: String) -> String{
        return "FileLoggerTest"
    }
    
}

class HTTPLogger: MyLogger {
    override func log(var level: Int, message: String) -> String{
        println("Hey, I am here in the HTTPLogger log function")
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.thisismylink.com/postName.php")!)
        request.HTTPMethod = "POST"
        let postString = "id=13&name=Jack"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
        return "HTTPLoggerTest"
    }
    
    
}
