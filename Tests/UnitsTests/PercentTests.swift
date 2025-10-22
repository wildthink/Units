//
//  Test.swift
//  Units
//
//  Created by Jason Jobe on 9/13/25.
//

@testable import Units
import XCTest

final class PercentTests: XCTestCase {
    
    func testParse() throws {
        XCTAssertEqual(
            try Expression("10m + 25%"),
            Expression(node: .init(.measurement(10.measured(in: .meter))))
                .append(op: .add, node: .init(.measurement(25.measured(in: .percent))))
        )
    }
    
    func testSolutions() throws {
 
        XCTAssertEqual(
            try Expression("10m + 25%").solve(),
            12.5.measured(in: .meter)
        )
        
        XCTAssertEqual(
            try Expression("10m - 25%").solve(),
            7.5.measured(in: .meter)
        )

        XCTAssertEqual(
            try Expression("10m * 25%").solve(),
            2.5.measured(in: .meter)
        )

        XCTAssertEqual(
            try Expression("10m / 25%").solve(),
            40.measured(in: .meter)
        )
    }
    
    func testPercentCalculation() {
        XCTAssertEqual(50% * 50%, 25%)
        XCTAssertEqual(50% + 5.8%, 55.8%)
        XCTAssertEqual(50% - 50%, 0%)
        XCTAssertEqual(50% - 5.8%, 44.2%)
    }
    
    func testPercentFormat() {
        XCTAssertEqual(30%.formatted(), "30%")
        XCTAssertEqual(28.5%.formatted(), "28.5%")
        XCTAssertEqual(28.33%.formatted(), "28.33%")
        XCTAssertEqual(28.33%.formatted(fractionDigits: 1), "28.3%")
        XCTAssertEqual(28.33%.formatted(fractionDigits: 0), "28%")
    }
}
