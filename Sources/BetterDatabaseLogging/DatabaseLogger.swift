//
//  DatabaseLogger.swift
//  
//
//  Created by Holly Schilling on 8/12/24.
//

import Foundation
import Blackbird
import BetterLogging

public struct DatabaseLogger: Logger {
    
    public var db: Blackbird.Database
    
    public var subjectConverters: [SubjectConverter] = [
        CustomStringConvertableSubjectConverter(),
        EncodableSubjectConverter(),
        DefaultSubjectConverter()
    ]
    
    public var moduleName: String?
    public var squelchLevel: LogLevel = .verbose

    public init(db: Blackbird.Database, moduleName: String? = nil) {
        self.db = db
        self.moduleName = moduleName
    }
    
    public func log(level: BetterLogging.LogLevel, _ message: @autoclosure () -> String, subject: Any?) {
        guard level <= squelchLevel else {
            return
        }

        var convertedSubject: String? = nil
        
        if let subject {
            for converter in subjectConverters {
                if let converted = converter.convert(subject) {
                    convertedSubject = converted
                    break
                }
            }
        }

        let record = LogRecord(
            id: UUID().uuidString,
            timestamp: Date(),
            logLevel: level.rawValue,
            module: moduleName,
            message: message(),
            subject: convertedSubject)
        
        Task {
            try await record.write(to: db)
        }
    }
}
