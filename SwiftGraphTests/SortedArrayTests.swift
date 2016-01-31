//
//  SortedArrayTests.swift
//  oDeskMessenger
//
//  Created by Aaron Hayman on 1/7/16.
//  Copyright © 2016 oDesk. All rights reserved.
//

import XCTest
import SwiftGraph

func ==(lhs: IntWrapper, rhs: IntWrapper) -> Bool {
  return lhs.value == rhs.value
}
func <(lhs: IntWrapper, rhs: IntWrapper) -> Bool {
  return lhs.value < rhs.value
}
func >(lhs: IntWrapper, rhs: IntWrapper) -> Bool {
  return lhs.value > rhs.value
}
func <=(lhs: IntWrapper, rhs: IntWrapper) -> Bool {
  return lhs.value <= rhs.value
}
func >=(lhs: IntWrapper, rhs: IntWrapper) -> Bool {
  return lhs.value >= rhs.value
}
class IntWrapper : Comparable {
  var value: Int
  
  init(value: Int) {
    self.value = value
  }
  
  var hashValue: Int { return value }
}

class SortedArrayTests: XCTestCase {
  
  func testSerialOrderedInsertion() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert(0)
    XCTAssertEqual(sorted.count, 1)
    XCTAssertEqual(sorted[0], 0)
    
    sorted.insert(1)
    XCTAssertEqual(sorted.count, 2)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    
    sorted.insert(2)
    XCTAssertEqual(sorted.count, 3)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    
    sorted.insert(3)
    XCTAssertEqual(sorted.count, 4)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 3)
  }
  
  func testSerialReverseOrderedInsertion() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert(3)
    XCTAssertEqual(sorted.count, 1)
    XCTAssertEqual(sorted[0], 3)
    
    sorted.insert(2)
    XCTAssertEqual(sorted.count, 2)
    XCTAssertEqual(sorted[0], 2)
    XCTAssertEqual(sorted[1], 3)
    
    sorted.insert(1)
    XCTAssertEqual(sorted.count, 3)
    XCTAssertEqual(sorted[0], 1)
    XCTAssertEqual(sorted[1], 2)
    XCTAssertEqual(sorted[2], 3)
    
    sorted.insert(0)
    XCTAssertEqual(sorted.count, 4)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 3)
  }
  
  func testSerialUnorderedInsertion() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert(2)
    XCTAssertEqual(sorted.count, 1)
    XCTAssertEqual(sorted[0], 2)
    
    sorted.insert(0)
    XCTAssertEqual(sorted.count, 2)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 2)
    
    sorted.insert(3)
    XCTAssertEqual(sorted.count, 3)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 2)
    XCTAssertEqual(sorted[2], 3)
    
    sorted.insert(1)
    XCTAssertEqual(sorted.count, 4)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 3)
  }
  
  func testOrderedBatchInsertion() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert([0, 1, 2, 3, 4])
    XCTAssertEqual(sorted.count, 5)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 3)
    XCTAssertEqual(sorted[4], 4)
  }
  
  func testUnorderedBatchInsertion() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert([3, 0, 1, 4, 2])
    XCTAssertEqual(sorted.count, 5)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 3)
    XCTAssertEqual(sorted[4], 4)
  }
  
  func testUniqueObjectes() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert([3, 0, 1, 4, 2])
    XCTAssertEqual(sorted.count, 5)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 3)
    XCTAssertEqual(sorted[4], 4)
    
    sorted.insert(3)
    sorted.insert(2)
    XCTAssertEqual(sorted.count, 5)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 3)
    XCTAssertEqual(sorted[4], 4)
  }
  
  func testSingleIndexRetrieval() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert([3, 0, 1, 4, 2])
    XCTAssertEqual(sorted.count, 5)
    XCTAssertEqual(sorted.index(0), 0)
    XCTAssertEqual(sorted.index(1), 1)
    XCTAssertEqual(sorted.index(2), 2)
    XCTAssertEqual(sorted.index(3), 3)
    XCTAssertEqual(sorted.index(4), 4)
  }
  
  func testSingleRemoveal() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert([0, 1, 2, 3, 4])
    XCTAssertEqual(sorted.count, 5)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 3)
    XCTAssertEqual(sorted[4], 4)
    
    sorted.removeObject(3)
    XCTAssertEqual(sorted.count, 4)
    XCTAssertEqual(sorted[0], 0)
    XCTAssertEqual(sorted[1], 1)
    XCTAssertEqual(sorted[2], 2)
    XCTAssertEqual(sorted[3], 4)
  }
  
  func testRangeDetection() {
    var sorted: SortedArray<Int> = SortedArray(comparisonHandler: comparableHandler)
    sorted.distinct = false
    XCTAssertEqual(sorted.count, 0)
    
    sorted.insert([0, 1, 2, 3, 4])
    XCTAssertEqual(sorted.count, 5)
    
    sorted.insert(1)
    XCTAssertEqual(sorted.count, 6)
    XCTAssertEqual(1...2, sorted.rangeBounded(from: 1, to: 1))
    
    sorted.insert(1)
    XCTAssertEqual(sorted.count, 7)
    XCTAssertEqual(1...3, sorted.rangeBounded(from: 1, to: 1))
    
    sorted.insert(0)
    XCTAssertEqual(sorted.count, 8)
    XCTAssertEqual(2...4, sorted.rangeBounded(from: 1, to: 1))
    XCTAssertEqual(0...1, sorted.rangeBounded(from: 0, to: 0))
    XCTAssertEqual(0...4, sorted.rangeBounded(from: 0, to: 1))
    
    sorted.insert(1)
    XCTAssertEqual(sorted.count, 9)
    XCTAssertEqual(2...5, sorted.rangeBounded(from: 1, to: 1))
    XCTAssertEqual(0...1, sorted.rangeBounded(from: 0, to: 0))
    XCTAssertEqual(0...5, sorted.rangeBounded(from: 0, to: 1))
    XCTAssertEqual(0...5, sorted.rangeBounded(from: nil, to: 1))
    XCTAssertEqual(6..<sorted.count, sorted.rangeBounded(from: 2, to: nil))
    XCTAssertEqual(0..<sorted.count, sorted.rangeBounded(from: nil, to: nil))
  }
  
  func testUpdate() {
    var sorted: SortedArray<IntWrapper> = SortedArray(comparisonHandler: comparableHandler) { $0 === $1 }
    
    let w1 = IntWrapper(value: 1)
    let w2 = IntWrapper(value: 2)
    let w3 = IntWrapper(value: 3)
    let w4 = IntWrapper(value: 4)
    let w5 = IntWrapper(value: 5)
    
    sorted.insert([w3, w2, w1, w5, w4])
    
    XCTAssertEqual(sorted[0].value, 1)
    XCTAssertEqual(sorted[1].value, 2)
    XCTAssertEqual(sorted[2].value, 3)
    XCTAssertEqual(sorted[3].value, 4)
    XCTAssertEqual(sorted[4].value, 5)
    
    w2.value = 6
    let update = sorted.update(w2)
    XCTAssertEqual(update.from!, 1)
    XCTAssertEqual(update.to, 4)
  }
  
  func testUpdates() {
    var sorted: SortedArray<IntWrapper> = SortedArray(comparisonHandler: comparableHandler) { $0 === $1 }
    
    let w1 = IntWrapper(value: 1)
    let w2 = IntWrapper(value: 2)
    let w3 = IntWrapper(value: 3)
    let w4 = IntWrapper(value: 4)
    let w5 = IntWrapper(value: 5)
    
    sorted.insert([w3, w2, w1, w5, w4])
    
    XCTAssertEqual(sorted[0].value, 1)
    XCTAssertEqual(sorted[1].value, 2)
    XCTAssertEqual(sorted[2].value, 3)
    XCTAssertEqual(sorted[3].value, 4)
    XCTAssertEqual(sorted[4].value, 5)
    
    w2.value = 6
    w5.value = 2
    let updates = sorted.update([w2, w5])
    XCTAssertEqual(updates[0].from!, 1)
    XCTAssertEqual(updates[0].to, 4)
    XCTAssertEqual(updates[1].from!, 4)
    XCTAssertEqual(updates[1].to, 1)
  }
  
}
