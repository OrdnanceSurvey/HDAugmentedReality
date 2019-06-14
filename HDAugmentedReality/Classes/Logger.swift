//
//  Created on 14/06/2019.
//  Copyright © 2019 Ordnance Survey. All rights reserved.
//

import Foundation

@objc public enum LogLevel: UInt {
    case verbose = 0, debug, info, warning, error
}

public protocol LogFormater {
    func format(_ message: String, type: LogLevel, file: String, function: String, line: Int) -> String
}

public class SimpleLogFormater: LogFormater {
    let symbols: [LogLevel: String]
    public init(symbols: [LogLevel: String] = [.warning: "⚠️", .error: "‼️"]) {
        self.symbols = symbols
    }

    public func format(_ message: String, type: LogLevel, file: String, function: String, line: Int) -> String {
        return symbols[type].flatMap { $0 + " " + message } ?? message
    }
}

public class PrintLogger: Logger {
    public let formater: LogFormater

    public init(formater: LogFormater = SimpleLogFormater()) {
        self.formater = formater
    }

    public func log(_ message: String, type: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        print(formater.format(message, type: type, file: file, function: function, line: line)) //swiftlint:disable:this avoid_print
    }
}

public struct Log {
    public static var logger: Logger?
}

public protocol Logger {
    func log(_ message: String, type: LogLevel, file: String, function: String, line: Int)
}

extension Logger {
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, type: .warning, file: file, function: function, line: line)
    }

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, type: .error, file: file, function: function, line: line)
    }

    func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, type: .verbose, file: file, function: function, line: line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, type: .info, file: file, function: function, line: line)
    }

    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, type: .debug, file: file, function: function, line: line)
    }
}
