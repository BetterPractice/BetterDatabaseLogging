import XCTest
import BetterLogging
import Blackbird

@testable import BetterDatabaseLogging

final class BetterDatabaseLoggingTests: XCTestCase {
    
    let db: Blackbird.Database = try! .inMemoryDatabase()
        
    func testSimpleLogging() async throws {
        let logger = DatabaseLogger(db: db)
        let uuid = UUID().uuidString
        logger.log(uuid)
        
        let records = try await LogRecord.read(from: db, matching: \.$message == uuid)
        XCTAssert(records.count == 1)
        let record = records[0]
        XCTAssertNil(record.module)
    }
    
    func testSquelchRemoved() async throws {
        var logger = DatabaseLogger(db: db)
        logger.squelchLevel = .fatal
        let uuid = UUID().uuidString
        logger.log(level: .critical, uuid)
        
        let records = try await LogRecord.read(from: db, matching: \.$message == uuid)
        XCTAssert(records.count == 0)
    }

    func testStringSubject() async throws {
        let logger = DatabaseLogger(db: db)
        let uuid = UUID().uuidString
        let subject = "My String Subject"
        logger.log(uuid, subject: subject)
        
        let records = try await LogRecord.read(from: db, matching: \.$message == uuid)
        XCTAssert(records.count == 1)
        let record = records[0]
        XCTAssertEqual(subject, record.subject)
        XCTAssertNil(record.module)
    }

    func testModuleSet() async throws {
        let moduleName = "TestModule"
        let logger = DatabaseLogger(db: db, moduleName: moduleName)
        let uuid = UUID().uuidString
        logger.log(uuid)
        
        let records = try await LogRecord.read(from: db, matching: \.$message == uuid)
        XCTAssert(records.count == 1)
        let record = records[0]
        XCTAssertEqual(moduleName, record.module)
    }

}
