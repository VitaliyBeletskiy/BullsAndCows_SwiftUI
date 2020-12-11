//
//  GameController.swift
//  BullsAndCows
//
//  Created by Vitaliy on 2020-11-19.
//

import Foundation

typealias Result = [BullsAndCows]

class GameController: ObservableObject {
    private let source = Array(0...9)
    private var secretNumber: [Int] = []
    @Published var isGameOver = false
    @Published var attemptLog: [Attempt] = []
    
    /// re-creates secretNumber, clears log, etc.
    func newGame() {
        // reset secretNumber
        secretNumber = []
        // generate and assign new secret number
        secretNumber.append(contentsOf: source.shuffled()[0...3])
        // clear log of attempts
        attemptLog.removeAll()
        // game is not over
        isGameOver = false
    }
    
    /// checks if current Attempt doesn't have repeating numbers
    func isAttemptValid(attemptValues: [Int]) -> Bool {
        if attemptValues.count != 4 {
            Logger.error("attemptValues.count != 4 !!!")
            fatalError()
        }
        let valuesSorted = attemptValues.sorted()
        for i in 0...(valuesSorted.count - 2) {
            if valuesSorted[i] == valuesSorted[i + 1] { return false }
        }
        return true
    }
    
    /// receives valid 'attemptValues', calculate 'result', adds a new recort to 'attemptLog'
    func processNewAttempt(attemptValues: [Int]) {
        let result = evaluateAttempt(attemptValues: attemptValues)
        attemptLog.append(Attempt(attemptValues: attemptValues, result: result))
    }
    
    /// compares 'attemptValues' against 'secretNumber'
    /// and returns result as array of BullAndCows
    private func evaluateAttempt(attemptValues: [Int]) -> Result {
        var result: Result = []
        
        if attemptValues.count != 4 {
            Logger.error("attemptValues.count != 4 !!!")
            fatalError()
        }
        
        for idx in 0..<attemptValues.count {
            if attemptValues[idx] == secretNumber[idx] {
                result.append(BullsAndCows.Bull)
            } else if secretNumber.contains(attemptValues[idx]) {
                result.append(BullsAndCows.Cow)
            } else {
                result.append(BullsAndCows.Nothing)
            }
        }
        result.sort { $0.rawValue >= $1.rawValue }
        isFourBulls(result)
        
        return result
    }
    
    /// checks if result contains 4 Bulls
    private func isFourBulls(_ result: Result) {
        let bullsCount = result.reduce(into: 0) {
            $0 += ($1 == BullsAndCows.Bull ? 1 : 0)
        }
        if bullsCount == 4 {
            isGameOver = true
        }
    }

}

struct Attempt: Hashable {
    var attemptValues: [Int]
    var result: Result
    
    init(attemptValues: [Int], result: Result) {
        self.attemptValues = attemptValues
        self.result = result
    }
}

enum BullsAndCows: Int {
    case Nothing = 0
    case Cow = 1
    case Bull = 2
}
