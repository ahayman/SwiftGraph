//
//  GraphData.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 12/24/14.
//  Copyright (c) 2014 FlexileSoft, LLC. All rights reserved.
//

import Foundation

public protocol BaseData : CollectionType {
  typealias FloatingType: FloatingArithmatic
  var count: Int { get }
  func xAtIndex(index: Int) -> FloatingType
}

extension BaseData {
  
  public var startIndex: Int {
    return 0
  }
  
  public var endIndex: Int {
    return count
  }
  
  public subscript (position: Int) -> FloatingType {
    return xAtIndex(position)
  }
  
}

public class GraphData <T: BaseData> {
  
  /// An optional graphID to use as reference
  public let graphID : String
  
  var dataObservable: MObservable<T>
  
  public var data: T {
    get { return dataObservable.value }
    set { dataObservable.set(newValue) }
  }
  
  /**
  Designated initializer to initialize the Graph Data with a specific data set
  - parameter data: The graph data
  */
  init(graphID : String, GraphData data: T) {
    self.graphID = graphID
    self.dataObservable = MObservable(data)
  }
  
}

extension GraphData : CollectionType {
  
  public var startIndex: Int {
    return data.startIndex
  }
  
  public var endIndex: Int {
    return data.endIndex
  }
  
  public subscript (position: Int) -> T.FloatingType {
    return data.xAtIndex(position)
  }
  
}