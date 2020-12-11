//
//  BullsAndCowsTests.swift
//  BullsAndCowsTests
//
//  Created by Vitaliy on 2020-11-19.
//

import XCTest
@testable import BullsAndCows

class BullsAndCowsTests: XCTestCase {

    var sut: GameController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GameController()
        sut.newGame()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    // чтобы тестировать, нужно убрать private
//    func testSecretNumberIsOk() {
//        if sut.secretNumber.count != 4 {
//            XCTFail("secretNumber length is not 4.")
//        }
//        sut.secretNumber.forEach { number in
//            XCTAssert(number >= 0 && number <= 9,
//                      "secretNumber contains a number which in not in 0...9.")
//        }
//    }
    
    func testIsAttemptValid() {
        XCTAssert(sut.isAttemptValid(attemptValues: [0, 1, 2, 4]) == true,
                  "isTryValid() returns wrong result on [0, 1, 2, 4]")
        
        XCTAssert(sut.isAttemptValid(attemptValues: [0, 1, 2, 0]) == false,
                  "isTryValid() returns wrong result on [0, 1, 2, 0]")
    }
    
    // чтобы тестировать, нужно убрать private и переписать тест :-)
//    func testIsFourBulls() {
//        var result = [BullsAndCows.Bull, BullsAndCows.Cow, BullsAndCows.Nothing, BullsAndCows.Bull]
//        XCTAssert(sut.isFourBulls(result: result),
//                  "isFourBulls returns wrong result")
//        result = [BullsAndCows.Bull, BullsAndCows.Bull, BullsAndCows.Bull, BullsAndCows.Bull]
//        XCTAssert(sut.isFourBulls(result: result) == true,
//                  "isFourBulls returns wrong result")
//    }
    
}
