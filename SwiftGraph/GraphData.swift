//
//  GraphData.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 12/24/14.
//  Copyright (c) 2014 FlexileSoft, LLC. All rights reserved.
//

import Foundation

public protocol BasePoint {
  var x: Double { get }
}

public class GraphData <T> {
  
  /// An optional graphID to use as reference
  public let graphID : String
  
  var dataObservable: MObservable<[T]>
  
  public var data: [T] {
    get { return dataObservable.value }
    set { dataObservable.set(newValue) }
  }
  
  /**
  Designated initializer to initialize the Graph Data with a specific data set
  - parameter data: The graph data
  */
  init(graphID : String, GraphData data: [T] = []) {
    self.graphID = graphID
    self.dataObservable = MObservable(data)
  }
  
}