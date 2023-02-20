//
//  Logger.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/2/20.
//

import Foundation

class Logger {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func info(_ messages: Any?..., file: String = #file, function: String = #function, line: Int = #line) {
        printMessage(messages, state: "🟢 INFO", file: file, function: function, line: line)
    }
    
    static func error(_ messages: Any?..., file: String = #file, function: String = #function, line: Int = #line) {
        printMessage(messages, state: "🔴 ERROR", file: file, function: function, line: line)
    }
    
    static func warning(_ messages: Any?..., file: String = #file, function: String = #function, line: Int = #line) {
        printMessage(messages, state: "🟡 WARNING", file: file, function: function, line: line)
    }
    
    static func debug(_ messages: Any?..., file: String = #file, function: String = #function, line: Int = #line) {
        printMessage(messages, state: "🟢 DEBUG", file: file, function: function, line: line)
    }
    
    private static func printMessage(_ messages: Any?..., state: String, file: String, function: String, line: Int) {
        let dateString = dateFormatter.string(from: Date())
        print("\(dateString) - \(state) \(sourceFileName(file)) -> \(function):\(line)\n", messages)
    }
    
    private static func sourceFileName(_ filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : (components.last ?? "")
    }
}
