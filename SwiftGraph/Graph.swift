//
//  Graph.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 1/2/15.
//  Copyright (c) 2015 FlexileSoft, LLC. All rights reserved.
//

import Foundation

/**
A simple function to easily delay the execution of code

- parameter delay:   How long to delay in seconds
- parameter closure: a closure that contains the code you want to delay
*/
func delay(delay:Double, closure:()->()) {
  dispatch_after(
    dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delay * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(), closure)
}

/**
*  Abstract Class that contains some defaults and functionality.  Use one of the concrete subsclasses to display actual graph data
*/
class Graph <T: BasePoint> : CAShapeLayer {
  var _graphNeedsLayout = false
  var graphData: GraphData<T>
  
  // MARK: Init
  /**
  Designated Init
  
  - parameter space:   The space the graph is in
  - parameter graphID: A unique ID
  */
  init(space: GraphSpace, data: GraphData<T>){
    self.graphData = data
    self.graphSpace = space
    super.init()
    self.actions = ["onOrderOut" : NSNull(), "sublayers" : NSNull(), "contents" : NSNull(), "bounds" : NSNull(), "position" : NSNull()]
    data.dataObservable.on { [weak self] _ in
      guard let me = self else { return false }
      me.setGraphNeedsLayout()
      return true
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Private
  
  // MARK: Properties
  
  /// The ID of the graph
  var graphID : String?
  
  /// The graph space, which represents the space in which the graph is displayed
  var graphSpace : GraphSpace {
    willSet{
      self.setGraphNeedsLayout()
    }
  }
  
  /// Convenience property that sets the line (stroke) color
  var lineColor : UIColor? {
    get {
      if let color = self.strokeColor { return UIColor(CGColor: color) }
      else { return nil }
    }
    set(lineColor) {
      self.strokeColor = lineColor?.CGColor
    }
  }
  
  /// Convenience property that sets the fill color
  var graphColor: UIColor? {
    get {
      if let color = self.fillColor { return UIColor(CGColor: color) }
      else { return nil }
    }
    set(color) {
      self.fillColor = color?.CGColor
    }
  }
  
  // MARK: Interface
  
  /**
  This will immediately layout the graph.  It's best to use `setGraphNeedslayout` instead
  */
  func layoutGraph() {
    _graphNeedsLayout = false
    self.path = self.newGraphPath()
  }
  
  /**
  This will layout the graph once after a delay
  */
  func setGraphNeedsLayout() {
    if !_graphNeedsLayout {
      _graphNeedsLayout = true
      delay(0.01) {
        if self._graphNeedsLayout { self.layoutGraph() }
      }
    }
  }
  
  /**
  Empty function. Subclasses should override this in order to provide a path for the graph to display
  
  - returns: CGPathRef
  */
  func newGraphPath() -> CGPathRef? {
    return nil
  }
}