//
//  Logger.swift
//  BullsAndCows
//
//  Created by Vitaliy on 2020-11-30.
//  Source: https://github.com/sauvikdolui/swiftlogger
 
import Foundation
 
/// Wrapping Swift.debugPrint() within DEBUG flag
public func debugPrint(_ object: Any) {
    #if DEBUG
    Swift.debugPrint(object)
    #endif
}
 
/// Wrapping Swift.debugPrint() within DEBUG flag
public func debugPrint(_ object: Any...) {
    #if DEBUG
    for item in object{
        Swift.debugPrint(item)
    }
    #endif
}
 
enum LogEvent: String {
   case error = "[‼️]"
   case info = "[ℹ️]"
   case debug = "[💬]"
   case verbose = "[🔬]"
   case warning = "[⚠️]"
   case severe = "[🔥]"
}
 
/// String Message Logging
/// Logger.debug("This is a DEBUG message") // DEBUG log
/// Logger.error("This is an ERROR message") // ERROR log
/// Logger.info("This is a INFO message") // INFO log
/// Logger.verbose("This is a VERBOSE message") // VERBOSE log
/// Logger.warning("This is a WARNING message") // WARNING log
/// Logger.severe("This is a SEVERE message") // SEVERE Error log
class Logger {
   // The date formatter
   static var dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
   static var dateFormatter: DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = dateFormat
      formatter.locale = Locale.current
      formatter.timeZone = TimeZone.current
      return formatter
    }
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
 
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
     
    class func error( _ object: Any,             // debug object which is to be printed
                  filename: String = #file,      // file name from where the log will appear
                  line: Int = #line,             // line number of the log message
                  funcName: String = #function)  // the signature of the function from where the log function is getting called
    {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
     
    class func info( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
     
    class func debug( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
     
    class func verbose( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.verbose.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
     
    class func warning( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.warning.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
     
    class func severe( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.severe.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
}
 
/// The Date to String extension
extension Date {
    func toString() -> String {
      return Logger.dateFormatter.string(from: self as Date)
    }
}
