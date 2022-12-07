//
//  ConsoleLogger.swift
//  MacSystemConsoleLogger
//

import Foundation
import os.log

internal class MacSystemConsoleLogger: GenericLogger {
    private let log = OSLog(subsystem: "qwe", category: String(describing: MacSystemConsoleLogger.self))
    func log(_ value: Any) -> Void {
        printToConsole(value)
    }
    
    func logDebug(_ value: Any) -> Void {
        printToConsole(value)
    }
    
    func logInfo(_ value: Any) -> Void {
        printToConsole(value)
    }
    
    func logWarning(_ value: Any) -> Void {
        printToConsole(value)
    }
    
    func logError(_ value: Any) -> Void {
        printToConsole(value)
    }
    
    func logFatal(_ value: Any) -> Void {
        printToConsole(value)
    }
    
    private func printToConsole(_ value: Any) -> Void {
        if let val = value as? CVarArg {
            os_log(.info, log: log, "%{public}@", val)
        }
    }
}
