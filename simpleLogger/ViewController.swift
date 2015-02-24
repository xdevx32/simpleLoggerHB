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
        
        //prints level and message to the console
        let consoleLogger = ConsoleLogger(level: 1, message: "Hello Console")
        
        consoleLogger.consoleLog(consoleLogger.level, message: consoleLogger.message)
        
        //prints level and message to the app user interface using the superclass
        let myDefaultLogger = MyLogger(level: 2, message: "Hello World")
        
        messageLabel.text = myDefaultLogger.log(myDefaultLogger.level, message: myDefaultLogger.message)
        
        let fileLogger = FileLogger(level: 3, message: "Hello File")
        
        fileLogger.log(fileLogger.level, message1: fileLogger.message)
        
        //HTTPLogger test
        let htLogger = HTTPLogger(level: 1,message: "Hello World")
        htLogger.log(htLogger.level, message: htLogger.message)
    }
}


//  superclass

class MyLogger{
    
    var level: Int = 0
    var message: String
    
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

// subclasses : ConsoleLogger, FileLogger, HTTPLogger

class ConsoleLogger: MyLogger {
    
   func consoleLog(var level: Int, message: String){
        println(log(level, message: message))
    }
}

class FileLogger: MyLogger {
    
    func log(level1: Int, message1: String){
        var logger = MyLogger(level: level1, message: message1)
        
        var stamp: String = logger.log(level1, message: message1)
        
        //let folder = NSSearchPathDomainMask(.DocumentDirectory)
        //let path = folder.stringByAppendingPathComponent("writeFileTest")
        //the poject folder
        let path = "/Users/xdevx/Documents/Development/HackBulgaria/simpleLoggerHB/simpleLogger/writeFileTest.txt"

        //desktop
        //let path = "/Users/xdevx/Desktop/writeFileTest.txt"
        
        if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            outputStream.write(stamp)
            outputStream.close()
        } else {
            println("Unable to open file")
        }
        
    }
 
}

class HTTPLogger: MyLogger {
   
    override func log(var level: Int, message: String) -> String{
        
        var tempObj = MyLogger(level: level, message: message)
        
        var stamp: String = tempObj.log(level, message: message)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.thisismylink.com/postName.php")!)
        request.HTTPMethod = "POST"
        let postString = stamp
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

// timestamp done with extension

extension NSDate {
    var formatted: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.stringFromDate(self)
    }
}



extension NSOutputStream {
    
    /// Write String to outputStream
    ///
    /// :param: string                The string to write.
    /// :param: encoding              The NSStringEncoding to use when writing the string. This will default to UTF8.
    /// :param: allowLossyConversion  Whether to permit lossy conversion when writing the string.
    ///
    /// :returns:                     Return total number of bytes written upon success. Return -1 upon failure.
    
    func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding, allowLossyConversion: Bool = true) -> Int {
        if let data = string.dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion) {
            var bytes = UnsafePointer<UInt8>(data.bytes)
            var bytesRemaining = data.length
            var totalBytesWritten = 0
            
            while bytesRemaining > 0 {
                let bytesWritten = self.write(bytes, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    return -1
                }
                
                bytesRemaining -= bytesWritten
                bytes += bytesWritten
                totalBytesWritten += bytesWritten
            }
            
            return totalBytesWritten
        }
        
        return -1
    }
    
}

