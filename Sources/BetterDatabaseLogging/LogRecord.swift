//
//  LogRecord.swift
//
//
//  Created by Holly Schilling on 8/12/24.
//

import Foundation
import Blackbird

struct LogRecord: BlackbirdModel {
    
    @BlackbirdColumn
    var id: String
    
    @BlackbirdColumn
    var timestamp: Date
    
    @BlackbirdColumn
    var logLevel: Int
    
    @BlackbirdColumn
    var module: String?
    
    @BlackbirdColumn
    var message: String
    
    @BlackbirdColumn
    var subject: String?
    
}
