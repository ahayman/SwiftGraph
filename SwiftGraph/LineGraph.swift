//
//  LineGraph.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 1/2/15.
//  Copyright (c) 2015 FlexileSoft, LLC. All rights reserved.
//

import Foundation


public protocol LineData : BaseData {
  func yAtIndex(index: Int) -> FloatingType
}

class LineGraph <T: LineData> : Graph<T> {
  
  private typealias FT = T.FloatingType
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override init(space: GraphSpace<T.FloatingType>, data: GraphData<T>){
    super.init(space: space, data: data)
  }
  
  /**
  Generates the a line graph path
  
  - returns: line graph path
  */
  override func newGraphPath() -> CGPathRef? {
    let data = graphData.data
    guard data.count > 0 else { return nil }
    
    var xRange = graphSpace.xRange
    var yRange = graphSpace.yRange
    
    let range = graphData.rangeBounded(from: xRange.lowerBounds, to: xRange.upperBounds)
    
    guard range.endIndex > range.startIndex else { return nil }
    
    let upperIdx = range.endIndex
    
    let xSpan = FT(bounds.size.width)
    let ySpan = FT(bounds.size.height)
    
    let xLower = xRange.lowerBounds
    let xUpper = xRange.upperBounds
    let yLower = yRange.lowerBounds
    let yUpper = yRange.upperBounds
    
    let xFactor = xSpan / ((xUpper - xLower > 0.0) ? xUpper - xLower : 1.0)
    let yFactor = ySpan / ((yUpper - yLower > 0.0) ? yUpper - yLower : 1.0)
    
    let pathRef = CGPathCreateMutable()
    var x = FT(0.0), y = FT(0.0)
    let resolution = FT(1.0 / screenScale)
    var resStart = FT(0.0), resEnd = FT(0.0) + resolution
    
    let fill = (self.fillColor != nil) ? true : false
    var idx = 0
    
    if (fill){
      x = (data[idx] - xLower) * xFactor
      y = (yUpper - self.graphSpace.xBase) * yFactor
    } else {
      x = (data[idx] - xLower) * xFactor
      y = (yUpper - data.yAtIndex(idx)) * yFactor
      idx++
    }
    
    CGPathMoveToPoint(pathRef, nil, x.cgfloat, y.cgfloat)
    
    resStart = (x / resolution).floor * resolution
    resEnd = resStart + resolution
    
    var cY = (yUpper - data.yAtIndex(idx)) * yFactor
    x = (data.xAtIndex(idx) - xLower) * xFactor
    var findMin = false
    
    if data.count > (FT(self.bounds.size.width) / resolution).int {
      while (idx <= upperIdx){
        findMin = (cY > y) ? false : true
        while (x < resEnd && idx <= upperIdx){
          cY = (yUpper - data.yAtIndex(idx)) * yFactor
          y = findMin ? min(cY, y) : max(cY, y)
          idx++
          x = (data.xAtIndex(idx) - xLower) * xFactor
        }
        CGPathAddLineToPoint(pathRef, nil, resStart.cgfloat, y.cgfloat)
        
        resStart = (x / resolution).floor * resolution
        resEnd = resStart + resolution
        cY = (yUpper - data.yAtIndex(idx)) * yFactor
      }
    } else {
      for (; idx <= upperIdx; idx++){
        CGPathAddLineToPoint(pathRef, nil, ((data.xAtIndex(idx) - xLower) * xFactor).cgfloat, ((yUpper - data.yAtIndex(idx)) * yFactor).cgfloat)
      }
    }
    
    if (fill){
      //Last point and path close if we're filling
      y = (yUpper - graphSpace.xBase) * yFactor
      x = (data.xAtIndex(upperIdx) - xLower) * xFactor
      CGPathAddLineToPoint(pathRef, nil, x.cgfloat, y.cgfloat)
      
      CGPathCloseSubpath(pathRef)
    }
    return pathRef
  }
  
}