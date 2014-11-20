#!/usr/bin/swift

import Foundation
import Cocoa


//so sad looks notification can't work
//var notification:NSUserNotification = NSUserNotification()
//notification.title = "TEST"
//notification.subtitle = "TTTT"
//var notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
//
// notificationCenter.scheduleNotification(notification)
// notificationCenter.deliverNotification(notification)


    //NSFileHandle(forWritingAtPath:)NSFileHandle.fileHandleForWritingAtPath("scanIphone.log")
var fileLogPath = "scanIphone.log"
 var fileM = NSFileManager.defaultManager()
//if let fileManager = fileM  {

if !(fileM.fileExistsAtPath(fileLogPath)) {
    if let dataStr = " ".dataUsingEncoding(NSUTF8StringEncoding) {
        fileM.createFileAtPath(fileLogPath,contents:dataStr,attributes:[:])
    }
    
}
//}


func findIphoneSix(){
    
    
    
    var fileHandle:NSFileHandle = NSFileHandle(forWritingAtPath:fileLogPath)!
    fileHandle.seekToEndOfFile()
    var iphone6Url = "http://store.apple.com/hk-zh/buy-iphone/iphone6/5.5-%E5%90%8B%E8%9E%A2%E5%B9%95-64gb-%E9%8A%80%E8%89%B2-%E5%B7%B2%E8%A7%A3%E9%8E%96"
    var request = NSMutableURLRequest(URL: NSURL(string: iphone6Url)!)
    var session = NSURLSession.sharedSession()
    request.HTTPMethod = "GET"
    var err: NSError?
    
    var sem:dispatch_semaphore_t = dispatch_semaphore_create(0)
    
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        
        var err: NSError?
        
        if(err != nil) {
            println(err!.localizedDescription)
        }
        else {
            
            if let dataStr = NSString(data: data, encoding: NSUTF8StringEncoding){
                var dataArray =  dataStr.componentsSeparatedByString("<span class=\"customer_commit_display\">") as [NSString]
                var currentDate = NSDate().descriptionWithLocale(NSLocale.currentLocale())
                
                var i = 0
                var j = 0
                for  entryStr  in dataArray{
                    if i == 0{
                        i++
                        continue
                    }
                    
                    let tmpStr:NSString = entryStr as NSString
                    var result = tmpStr.substringToIndex(6)
                    if result == "暫時無法提供" {

                    }else{
                        j++
                        var logStr = "!!!ip6+ found \(i) go \(iphone6Url) \n"
                        if let dataStr = logStr.dataUsingEncoding(NSUTF8StringEncoding) {
                            fileHandle.writeData(dataStr)
                        }

                        println("\(logStr)")
                    }
                    i++
                }
                if j == 0{
                    var logStr = "no ip6+ found \n"
                    if let dataStr = logStr.dataUsingEncoding(NSUTF8StringEncoding) {
                        fileHandle.writeData(dataStr)
                    }
                    println("\(logStr)")
                    
                }
                if let currentDateStr = currentDate {
                    var logStr = "time at \(currentDateStr) \n"
                    if let dataStr = logStr.dataUsingEncoding(NSUTF8StringEncoding) {
                        fileHandle.writeData(dataStr)
                    }
                    println("\(logStr)")
                }
            }
            
        }
        dispatch_semaphore_signal(sem)
        
    })
    
    task.resume()
    dispatch_semaphore_wait(sem,DISPATCH_TIME_FOREVER)
    fileHandle.closeFile()
}

while true{
    findIphoneSix()
    NSThread.sleepForTimeInterval(30)
    
}

