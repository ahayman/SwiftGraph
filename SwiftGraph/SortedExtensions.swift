//
//  SortedExtensions.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 1/30/16.
//  Copyright © 2016 FlexileSoft, LLC. All rights reserved.
//

import Foundation


/// These are functions that work off a Sorted collection
extension CollectionType where Index == Int {
  
  typealias ComparisonHandler = (Generator.Element, Generator.Element) -> Comparison
  
  func rangeOfObjectsAtIndex(index: Int, compare: ComparisonHandler) -> Range<Int> {
    let object = self[index]
    
    let lower: Int = {
      var lower = index
      
      while lower > 0 {
        if compare(self[lower - 1], object) == .Equal {
          lower--
        } else {
          return lower
        }
      }
    
      return lower
    }()
    
    let upper: Int = {
      var upper = index
      let endIndex = self.endIndex
      
      while upper < endIndex {
        if compare(self[upper + 1], object) == .Equal {
          upper++
        } else {
          return upper
        }
      }
      
      return upper
    }()
    
    return lower...upper
  }
  
  /**
  This will return the index range of the objects bounded by the provided bounding objects
  
  - parameter lower: The lower bounds or 0 if nil
  - parameter upper: The upper bounds or lastIndex if nil
  
  - returns: An index range
  */
  func rangeBounded(from from: Generator.Element?, to: Generator.Element?, compare: ComparisonHandler) -> Range<Int> {
    
    let lower: Generator.Element?, upper: Generator.Element?
    
    // If we have both from and to and the from is greater than the to, then we need to swap them
    if let
      u = from, l = to
      where compare(u, l) == .After
    {
      lower = l
      upper = u
    } else {
      lower = from
      upper = to
    }
    
    switch (lower, upper) {
      case let (.None, .Some(ub)):
        let insertionIndex = insertionIndexOf(ub, compare: compare)
        return 0..<rangeOfObjectsAtIndex(insertionIndex, compare: compare).endIndex
      case let (.Some(lb), .None):
        return rangeOfObjectsAtIndex(insertionIndexOf(lb, compare: compare), compare: compare).startIndex..<self.count
      case let (.Some(lb), .Some(ub)) where compare(lb, ub) == .Equal:
        return rangeOfObjectsAtIndex(insertionIndexOf(lb, compare: compare), compare: compare)
      case let (.Some(lb), .Some(ub)):
        let lowerRange = rangeOfObjectsAtIndex(insertionIndexOf(lb, compare: compare), compare: compare)
        let upperRange = rangeOfObjectsAtIndex(insertionIndexOf(ub, compare: compare), compare: compare)
        return lowerRange.startIndex..<upperRange.endIndex
      case (.None, .None):
        return 0..<self.count
    }
  }
  
  func insertionIndexOf(object: Generator.Element, compare: ComparisonHandler) -> Int {
    if count < 1 {
      return 0
    }
    
    var upper = self.endIndex
    var lower = 0
    var center = 0
    
    while true {
      let newCenter = lower + ((upper - lower) / 2)
      
      if lower == upper || newCenter == center {
        if compare(object, self[lower]) == .After { lower += 1 }
        return lower
      }
      
      center = newCenter
      
      switch compare(object, self[center]) {
      case .Before: upper = center
      case .After: lower = center
      case .Equal:
        return center
      }
    }
  }
}

private func compareComparables<T: Comparable>(left: T, _ right: T) -> Comparison {
  if left < right {
    return .Before
  } else if left > right {
    return .After
  }
  return .Equal
}

extension CollectionType where Generator.Element: Comparable, Index == Int {
  
  func rangeOfObjectsAtIndex(index: Int) -> Range<Int> {
    return rangeOfObjectsAtIndex(index, compare: compareComparables)
  }
  
  func rangeBounded(from from: Generator.Element?, to: Generator.Element?) -> Range<Int> {
    return rangeBounded(from: from, to: to, compare: compareComparables)
  }
  
  func insertionIndexOf(object: Generator.Element) -> Int {
    return insertionIndexOf(object, compare: compareComparables)
  }
  
}