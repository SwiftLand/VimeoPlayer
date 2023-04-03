//
//  StringResource.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation

enum StringResource:String {
    case done = "Done"
    case delete = "Delete"
    case cancel = "Cancel"
    case save =  "Save"
    case okay =  "Okay"
    case init_massage = "search something"
    case error_message = "Error occurred,code:"
    case press_to_retry = "Press to retry"
    case unkown = "Unkown"
    case retry = "Retry"
    case error = "Error"
    
   static func `get` (_ item:StringResource)->String{
        //will be localized here
        return item.rawValue
    }
    
    static func getMessage(for error:Error)->String{
        var message = StringResource.get(.error_message)
        message.append(String((error as NSError).code))
        return message
    }
}
