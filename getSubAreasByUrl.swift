#!/usr/bin/swift

//通过post url 收集几个街区的信息 写入plist

import Foundation

var areas:Dictionary<String,String> = ["黄浦区":"310101000000","卢湾区":"310103000000","徐汇区":"310104000000","长宁区":"310105000000","静安区":"310106000000","普陀区":"310107000000","闸北区":"310108000000","虹口区":"310109000000","杨浦区":"310110000000","闵行区":"310112000000","宝山区":"310113000000","嘉定区":"310114000000","浦东新区":"310115000000","金山区":"310116000000","松江区":"310117000000","青浦区":"310118000000","奉贤区":"310120000000","崇明县":"310230000000"]


var plistDic:Dictionary<String,String> = ["黄浦区":"南京东路街道"]

println("Get all street")

for (key, departid) in areas {
    println("\(key)s have \(departid) ")
    
    var streetUrl = "http://210.14.76.253:8080/shroms/jiaoyimingxi/restaurantsell_getStreet.action"
    var request = NSMutableURLRequest(URL: NSURL(string: streetUrl)!)
    var session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    //departid:310103000000
    //var params = ["departid":"310103000000"] as Dictionary<String, String>
    //var departid = "310103000000"
    var err: NSError?
    

    
    var bodyData = "departid=\(departid)"
    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
    
    //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
    //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //request.addValue("application/json", forHTTPHeaderField: "Accept")

    
    var sem:dispatch_semaphore_t = dispatch_semaphore_create(0)
    
//    println("request: \(request.HTTPBody) ")
    var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//        println("Response: \(response)")
        
        var dataStr = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        println("------get dataStr")
        if let tmpDataStr = dataStr{
            var dataAry =  tmpDataStr.componentsSeparatedByString(",")
            for street in dataAry{
                println("street is \(street)->\(key)")
                let dicKey:String = street as String
                let dicValue:String = key
                if let testValue = plistDic[dicKey] {
                    
                }else{
                    plistDic[dicKey] = dicValue
                }
            }
        }
        
        //println("Body: \(dataStr)")
        var err: NSError?
        //    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
        
        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
        if(err != nil) {
            println(err!.localizedDescription)
//            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("Error could not parse JSON: '\(jsonStr)'")
        }
        else {
            //
            // The JSONObjectWithData constructor didn't return an error. But, we should still
            // check and make sure that json has a value using optional binding.
            //        if let parseJSON = json {
            //            // Okay, the parsedJSON is here, let's get the value for 'success' out of it
            //            var success = parseJSON["success"] as? Int
            //            println("Succes: \(success)")
            //        }
            //        else {
            //            // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
            //            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            //            println("Error could not parse JSON: \(jsonStr)")
            //        }
        }
        dispatch_semaphore_signal(sem)
        
    })
    
    task.resume()
    dispatch_semaphore_wait(sem,DISPATCH_TIME_FOREVER)
}

(plistDic as NSDictionary).writeToFile("area_data.plist", atomically:true)



