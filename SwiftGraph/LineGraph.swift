//
//  LineGraph.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 1/2/15.
//  Copyright (c) 2015 FlexileSoft, LLC. All rights reserved.
//

import Foundation

protocol LineDataPoint : BasePoint {
  var y: Double { get }
}

class LineGraph <T: LineDataPoint> : Graph<T> {
  
  override init(space: GraphSpace, data: GraphData<T>){
    super.init(space: space, data: data)
    self.lineWidth = 1.0
    self.strokeColor = UIColor.blackColor().CGColor
    self.fillColor = nil
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Overrides
  
  /**
  Generates the a line graph path
  
  - returns: line graph path
  */
  override func newGraphPath() -> CGPathRef? {
    guard graphData.data.count > 0 else { return nil }
    
    var xRange = self.graphSpace.xRange
    var yRange = self.graphSpace.yRange
    
    let range = self.xData.data.rangeBounded(from: xRange.lowerBounds, to: xRange.upperBounds)
    var xData = self.xData.data[range.startIndex...range.endIndex]
    if xData.count < 1 { return nil }
    let upperIdx = yData.endIndex
    
    let xSpan = Double(self.bounds.size.width)
    let ySpan = Double(self.bounds.size.height)
    
    let xLower = xRange.lowerBounds
    let xUpper = xRange.upperBounds
    let yLower = yRange.lowerBounds
    let yUpper = yRange.upperBounds
    
    let xFactor = xSpan / ((xUpper - xLower > 0) ? xUpper - xLower : 1)
    let yFactor = ySpan / ((yUpper - yLower > 0) ? yUpper - yLower : 1)
    
    let pathRef = CGPathCreateMutable()
    var x = 0.0, y = 0.0
    let resolution = Double(1.0 / UIScreen.mainScreen().scale)
    var resStart = 0.0, resEnd = 0.0 + resolution
    
    let fill = (self.fillColor != nil) ? true : false
    var idx = 0
    
    if (fill){
      x = (xData[idx] - xLower) * xFactor
      y = (yUpper - self.graphSpace.xBase) * yFactor
    } else {
      x = (xData[idx] - xLower) * xFactor
      y = (yUpper - yData[idx]) * yFactor
      idx++
    }
    
    CGPathMoveToPoint(pathRef, nil, CGFloat(x), CGFloat(y))
    
    resStart = floor(x / resolution) * resolution
    resEnd = resStart + resolution
    
    var cY = (yUpper - yData[idx]) * yFactor
    x = (xData[idx] - xLower) * xFactor
    var findMin = false
    
    if (xData.count > Int(Double(self.bounds.size.width) / resolution)){
      while (idx <= upperIdx){
        findMin = (cY > y) ? false : true
        while (x < resEnd && idx <= upperIdx){
          cY = (yUpper - yData[idx]) * yFactor
          y = findMin ? fmin(cY, y) : fmax(cY, y)
          idx++
          x = (xData[idx] - xLower) * xFactor
        }
        CGPathAddLineToPoint(pathRef, nil, CGFloat(resStart), CGFloat(y))
        
        resStart = floor(x / resolution) * resolution
        resEnd = resStart + resolution
        cY = (yUpper - yData[idx]) * yFactor
      }
    } else {
      for (; idx <= upperIdx; idx++){
        CGPathAddLineToPoint(pathRef, nil, CGFloat((xData[idx] - xLower) * xFactor), CGFloat((yUpper - yData[idx]) * yFactor))
      }
    }
    
    if (fill){
      //Last point and path close if we're filling
      y = (yUpper - self.graphSpace.xBase) * yFactor
      x = (xData[upperIdx] - xLower) * xFactor
      CGPathAddLineToPoint(pathRef, nil, CGFloat(x), CGFloat(y))
      
      CGPathCloseSubpath(pathRef)
    }
    return pathRef
  }
  
}