//
//  RangeGraph.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 1/2/15.
//  Copyright (c) 2015 FlexileSoft, LLC. All rights reserved.
//

import Foundation

protocol RangeDataPoint : BasePoint {
  var upper: Double { get }
  var lower: Double { get }
}

class RangeGraph <T: RangeDataPoint> : Graph<T> {
  
  override init(space: GraphSpace, data: GraphData<T>){
    super.init(space: space, data: data)
    self.lineWidth = 1.0
    self.strokeColor = UIColor.blackColor().CGColor
    self.fillColor = nil
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
//  override func newGraphPath() -> CGPathRef? {
//    var xRange = self.graphSpace.xRange
//    var yRange = self.graphSpace.yRange
//    
//    if (self.xData.data.count > 0 && self.yUpperData.data.count <= self.xData.data.count && self.yLowerData.data.count <= self.xData.data.count){
//      let range = self.xData.data.rangeBounded(from: xRange.lowerBounds, to: xRange.upperBounds)
//      var xData = self.xData.data[range.startIndex...range.endIndex]
//      if xData.count < 1 { return nil }
//      
//      var upperData = self.yUpperData.data[range.startIndex...range.endIndex]
//      var lowerData = self.yLowerData.data[range.startIndex...range.endIndex]
//      let upperIdx = xData.endIndex;
//      
//      let xSpan = Double(self.bounds.size.width)
//      let ySpan = Double(self.bounds.size.height)
//      
//      let xLower = xRange.lowerBounds
//      let xUpper = xRange.upperBounds
//      let yLower = yRange.lowerBounds
//      let yUpper = yRange.upperBounds
//      
//      let xFactor = xSpan / ((xUpper - xLower > 0) ? xUpper - xLower : 1)
//      let yFactor = ySpan / ((yUpper - yLower > 0) ? yUpper - yLower : 1)
//      
//      let pathRef = CGPathCreateMutable()
//      var x = 0.0, y = 0.0
//      let resolution = Double(1.0 / UIScreen.mainScreen().scale)
//      var resStart = 0.0, resEnd = 0.0 + resolution
//      
//      var idx = 0
//      
//      x = (xData[idx] - xLower) * xFactor
//      y = (yUpper - lowerData[idx]) * yFactor
//      idx++
//      
//      CGPathMoveToPoint(pathRef, nil, CGFloat(x), CGFloat(y))
//      
//      resStart = floor(x / resolution) * resolution
//      resEnd = resStart + resolution
//      
//      var cY = (yUpper - lowerData[idx]) * yFactor
//      x = (xData[idx] - xLower) * xFactor
//      var findMin = false
//      
//      //Lower path draw
//      if (xData.count > Int(Double(self.bounds.size.width) / resolution)){
//        while (idx <= upperIdx){
//          findMin = (cY > y) ? false : true
//          while (x < resEnd && idx <= upperIdx){
//            cY = (yUpper - lowerData[idx]) * yFactor
//            y = findMin ? fmin(cY, y) : fmax(cY, y)
//            idx++
//            x = (xData[idx] - xLower) * xFactor
//          }
//          CGPathAddLineToPoint(pathRef, nil, CGFloat(resStart), CGFloat(y))
//          
//          resStart = floor(x / resolution) * resolution
//          resEnd = resStart + resolution
//          cY = (yUpper - lowerData[idx]) * yFactor
//        }
//      } else {
//        for (; idx <= upperIdx; idx++){
//          CGPathAddLineToPoint(pathRef, nil, CGFloat((xData[idx] - xLower) * xFactor), CGFloat((yUpper - lowerData[idx]) * yFactor))
//        }
//      }
//      
//      //Upper path draw
//      if (xData.count > Int(Double(self.bounds.size.width) / resolution)){
//        while (idx >= 0){
//          findMin = (cY > y) ? false : true
//          while (x < resEnd && idx <= upperIdx){
//            cY = (yUpper - upperData[idx]) * yFactor
//            y = findMin ? fmin(cY, y) : fmax(cY, y)
//            idx--
//            x = (xData[idx] - xLower) * xFactor
//          }
//          CGPathAddLineToPoint(pathRef, nil, CGFloat(resStart), CGFloat(y))
//          
//          resStart = floor(x / resolution) * resolution
//          resEnd = resStart + resolution
//          cY = (yUpper - upperData[idx]) * yFactor
//        }
//      } else {
//        for (; idx >= 0; idx--){
//          CGPathAddLineToPoint(pathRef, nil, CGFloat((xData[idx] - xLower) * xFactor), CGFloat((yUpper - upperData[idx]) * yFactor))
//        }
//      }
//      
//      CGPathCloseSubpath(pathRef)
//      
//      return pathRef
//    } else {
//      return nil
//    }
//  }
}