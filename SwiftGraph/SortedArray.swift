//
//  SortedArray.swift
//  oDeskMessenger
//
//  Created by Aaron Hayman on 7/17/15.
//  Copyright (c) 2015 oDesk. All rights reserved.
//

import Foundation

private extension NSIndexSet {
  
  func map<T>(mapper: Int -> T?) -> [T] {
    var array: [T] = []
    self.enumerateIndexesUsingBlock { (index, _) in
      if let mapped = mapper(index) {
        array.append(mapped)
      }
    }
    return array
  }
  
}

/**
A SortedArray maintains a sorted array of comparable items.  It is highly recommended you only store immutable objects as each object's position within the array is determined on insertion and the sorted array assumes internal sorted consistency for insertion.  If you do store mutable objects and an object changes you can call `updateObject` or `updateObjectAtIndex` to update that object's position in the array.  As a last resort, you can choose to `resort` the array, but this will be an expensive operation and it's recommended you avoid it if possible.
*/
public func comparableHandler<T: Comparable>(left: T, right: T) -> Comparison {
  return left == right ? .Equal : left < right ? .Before : .After
}
public func equatableHandler<T: Equatable>(left: T, right: T) -> Bool {
  return left == right
}
public enum Comparison {
  case Equal
  case Before
  case After
}

public struct SortedArray <T> {
  private var internalData: [T] = []
  private let compare: (T, T) -> Comparison
  private let equatable: ((T, T) -> Bool)?
  
  public var distinct = true
  
  private func rangeOfObjectsAtIndex(index: Int) -> Range<Int> {
    let object = internalData[index]
    
    let lower: Int = {
      var lower = index
      
      while lower > 0 {
        if self.compare(self.internalData[lower - 1], object) == .Equal {
          lower--
        } else {
          return lower
        }
      }
    
      return lower
    }()
    
    let upper: Int = {
      var upper = index
      let endIndex = self.internalData.endIndex
      
      while upper < endIndex {
        if self.compare(self.internalData[upper + 1], object) == .Equal {
          upper++
        } else {
          return upper
        }
      }
      
      return upper
    }()
    
    return lower...upper
  }
  
  /** You can retrieve the current data set or set a new dataset.
  
  :warning: Settings the data will *copy* the values you provide into a new, sorted array.  This would be the same as if you iterated over the source array and inserted each individual object into the Sorted Array
  */
  public var data: Array<T> {
    get{
      return internalData
    }
    set(data){
      internalData = []
      for object in data {
        insert(object)
      }
    }
  }
  
  public var count: Int {
    return internalData.count
  }
  
  /**
  Init with a specific data set.  Note that the provided data does not need to be presorted.
  */
  public init(data: [T], comparisonHandler: (T, T) -> Comparison) {
    compare = comparisonHandler
    equatable = nil
    for object in data {
      insert(object)
    }
  }
  
  /**
  Standard init with an empty array.
  */
  public init(comparisonHandler: (T, T) -> Comparison) {
    self.compare = comparisonHandler
    equatable = nil
  }
  
  /**
  Init with a specific data set.  Note that the provided data does not need to be presorted.
  */
  public init(data: [T], comparisonHandler: (T, T) -> Comparison, equatableHandler: (T, T) -> Bool) {
    compare = comparisonHandler
    equatable = equatableHandler
    for object in data {
      insert(object)
    }
  }
  
  /**
  Standard init with an empty array.
  */
  public init(comparisonHandler: (T, T) -> Comparison, equatableHandler: (T, T) -> Bool) {
    self.compare = comparisonHandler
    equatable = equatableHandler
  }
  
  public func insertionIndexOf(object: T) -> Int {
    if internalData.count < 1 {
      return 0
    }
    
    var upper = internalData.endIndex
    var lower = 0
    var center = 0
    
    while true {
      let newCenter = lower + ((upper - lower) / 2)
      
      if lower == upper || newCenter == center {
        if compare(object, internalData[lower]) == .After { lower += 1 }
        return lower
      }
      
      center = newCenter
      
      switch compare(object, internalData[center]) {
      case .Before: upper = center
      case .After: lower = center
      case .Equal:
        return center
      }
    }
  }
  
  /**
  This will insert the object into the array determined by the Comparator.  If the `distinct` propery is set to true, then this method redirects to the `update` function and the index returned could either be the insertion index or the update index, depending on whether an existing object exists. This ensures that all objects in the array are unique to each other.
  
  - parameter object: Object to be inserted
  
  - returns: Index the object was inserted into
  */
  public mutating func insert(object: T) -> Int {
    guard !distinct else {
      return update(object).to
    }
    
    let index = insertionIndexOf(object)
    internalData.insert(object, atIndex: index)
    return index
  }
  
  /**
  Insert an array of objects
  */
  public mutating func insert(objects: [T]) -> [Int] {
    return objects.map{ insert($0) }
  }
  
  /**
  This will return the index of the object in question or nil if the object isn't present
  :warning: If there are multiple instances of the object present, this will return only one of those instance indexes.  Which index it actually returns will be effectively random.
  
  - parameter object: The object you wish to retrieve an index for
  
  - returns: Index of Object or `nil` if not present
  */
  public func index(object: T) -> Int? {
    if let isEqual = equatable {
      return internalData.indexOf{ isEqual($0, object) }
    }
    
    if (internalData.count < 1){
      return nil
    }
    
    var upper = internalData.endIndex
    var lower = 0
    var center = 0
    
    while true {
      
      let newCenter = lower + ((upper - lower) / 2)
      if (newCenter == center){
        return nil
      }
      
      center = newCenter
      
      switch compare(object, internalData[center]) {
      case .Before: upper = center
      case .After: lower = center
      case .Equal: return center
      }
    }
  }
  
  /**
  Removes one instance of the object and returns the index of the instance removed
  
  - parameter object: The object you want the index of
  
  - returns: Index of the object removed or `nil` if not found
  */
  public mutating func removeObject(object: T) -> Int? {
    if let index = index(object) {
      internalData.removeAtIndex(index)
      return index
    } else {
      return nil
    }
  }
  
  /**
   Removes and returns an object at the provided index
   
   - parameter index: the index of the object you want to remove
   
   - returns: The object that's being removed
  */
  public mutating func removeAt(index: Int) -> T {
    return internalData.removeAtIndex(index)
  }
  
  /**
  This does exactly what it says, it removes all objects from the array.
  */
  public mutating func removeAll() {
    internalData = []
  }
  
  /**
  This will remove the items in the specified range and return the objects
  */
  public mutating func removeRange(range: Range<Int>) -> [T] {
    let objects = internalData[range]
    internalData.removeRange(range)
    return Array(objects)
  }
  
  /**
  This will update the sort position of the object (if present) and return the new index for that object.  If an existing object doesn't exist, this will insert the provided object as new.
  
  - parameter object: The object to update
  
  - returns: The new index of the object or `nil` if not present
  */
  public typealias Update = (from: Int?, to: Int)
  public mutating func update(object: T) -> Update {
    if let index = index(object) {
      internalData.removeAtIndex(index)
      let newIndex = insertionIndexOf(object)
      internalData.insert(object, atIndex: index)
      return (from: index, newIndex)
    } else {
      let index = insertionIndexOf(object)
      internalData.insert(object, atIndex: index)
      return (from: nil, to: index)
    }
  }
  
  /**
  This will update or inserts the provided objects.
  */
  public mutating func update(objects: [T]) -> [Update]{
    var from: [Int?] = []
    for object in objects {
      from.append(self.index(object))
    }
    
    let to: [Int] = insert(objects)
    
    var updates: [Update] = []
    for (index, from) in from.enumerate() {
      let update = (from: from, to: to[index])
      updates.append(update)
    }
    return updates
  }
  
  /**
  This will remove the objects from the cache and return the indexes
  */
  public mutating func remove(objects: [T]) -> [Int] {
    var indexes: [Int] = []
    for object in objects {
      if let index = index(object) {
        indexes.append(index)
      }
    }
   
    indexes
      .sort{ $1 < $0 }
      .forEach{ internalData.removeAtIndex($0) }
    
    return indexes
  }
  
  /**
  This will update the sort position object at the index provided and returns the object and the new index for that object.
  
  - parameter index: The index of the object you want to update
  
  - returns: A Tuple containing the object updated and the new index of that object
  */
  public mutating func updateObjectAtIndex(index: Int) -> (object: T, newIndex: Int) {
    let object = internalData[index]
    internalData.removeAtIndex(index)
    return (object, insert(object))
  }
  
  /**
  This will resort the entire array.
  */
  public mutating func resort() {
    let objects = internalData
    internalData = []
    for object in objects {
      insert(object)
    }
  }
  
  /**
  This will return an array slice of the objects that are bounded by the provided objects.
  
  - parameter lower: The lower bounds or 0 if nil
  - parameter upper: The upper bounds or lastIndex if nil
  
  - returns: Returns an array slice of the bounded objects
  */
  public func objectsFrom(from : T?, to: T?) -> [T] {
    return Array(internalData[rangeBounded(from: from, to: to)])
  }
  
  /**
  This will return the index range of the objects bounded by the provided bounding objects
  
  - parameter lower: The lower bounds or 0 if nil
  - parameter upper: The upper bounds or lastIndex if nil
  
  - returns: An index range
  */
  public func rangeBounded(from from : T?, to: T?) -> Range<Int> {
    
    let lower:T?, upper:T?
    
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
        return 0..<rangeOfObjectsAtIndex(insertionIndexOf(ub)).endIndex
      case let (.Some(lb), .None):
        return rangeOfObjectsAtIndex(insertionIndexOf(lb)).startIndex..<internalData.count
      case let (.Some(lb), .Some(ub)) where compare(lb, ub) == .Equal:
        return rangeOfObjectsAtIndex(insertionIndexOf(lb))
      case let (.Some(lb), .Some(ub)):
        return rangeOfObjectsAtIndex(insertionIndexOf(lb)).startIndex..<rangeOfObjectsAtIndex(insertionIndexOf(ub)).endIndex
      case (.None, .None):
        return 0..<internalData.count
    }
  }
  
  /**
  Returns the objects in the specified index range
  */
  public subscript(subRange: Range<Int>) -> [T] {
    return Array(internalData[subRange])
  }
  
}

extension SortedArray : Indexable {
  
  public var startIndex: Int {
    return 0
  }
  
  public var endIndex: Int {
    return internalData.count
  }
  
  public subscript (position: Int) -> T {
    return internalData[position]
  }
}

extension SortedArray : CollectionType { }
