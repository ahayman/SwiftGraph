//
//  RangeGraph.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 1/2/15.
//  Copyright (c) 2015 FlexileSoft, LLC. All rights reserved.
//

import Foundation

protocol RangeData : BaseData {
  func upperAtIndex(index: Int) -> FloatingType
  func lowerAtIndex(index: Int) -> FloatingType
}

class RangeGraph <T: RangeData> : Graph<T> {
  
  private typealias FT = T.FloatingType
  
  override init(space: GraphSpace<T.FloatingType>, data: GraphData<T>){
    super.init(space: space, data: data)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented because the developer has never actually used NSCoder before and is too lazy to figure it out.")
  }
  
  override func newGraphPath() -> CGPathRef? {
    guard graphData.count > 0 else { return nil }
    var xRange = self.graphSpace.xRange
    var yRange = self.graphSpace.yRange
    
    let range = graphData.rangeBounded(from: xRange.lowerBounds, to: xRange.upperBounds)
    let data = graphData.data
    guard range.startIndex < range.endIndex else { return nil }
    
    let xSpan = FT(self.bounds.size.width)
    let ySpan = FT(self.bounds.size.height)
    
    let xLower = xRange.lowerBounds
    let xUpper = xRange.upperBounds
    let yLower = yRange.lowerBounds
    let yUpper = yRange.upperBounds
    
    let xFactor = xSpan / ((xUpper - xLower > 0.0) ? xUpper - xLower : 1.0)
    let yFactor = ySpan / ((yUpper - yLower > 0.0) ? yUpper - yLower : 1.0)
    
    let pathRef = CGPathCreateMutable()
    var x: FT = 0.0, y: FT = 0.0
    let resolution = FT(1.0 / UIScreen.mainScreen().scale)
    var resStart: FT = 0.0, resEnd: FT = 0.0 + resolution
    
    var idx = range.startIndex
    
    x = (data[idx] - xLower) * xFactor
    y = (yUpper - data.lowerAtIndex(idx)) * yFactor
    idx++
    
    CGPathMoveToPoint(pathRef, nil, x.cgfloat, y.cgfloat)
    
    resStart = (x / resolution).floor * resolution
    resEnd = resStart + resolution
    
    var cY = (yUpper - data.lowerAtIndex(idx)) * yFactor
    x = (data.xAtIndex(idx) - xLower) * xFactor
    var findMin = false
    
    //Lower path draw
    if range.count > Int((self.bounds.size.width) / resolution.cgfloat) {
      while idx <= range.endIndex {
        findMin = (cY > y) ? false : true
        while x < resEnd && idx <= range.endIndex {
          cY = (yUpper - data.lowerAtIndex(idx)) * yFactor
          y = findMin ? min(cY, y) : max(cY, y)
          idx++
          x = (data.xAtIndex(idx) - xLower) * xFactor
        }
        CGPathAddLineToPoint(pathRef, nil, resStart.cgfloat, y.cgfloat)
        
        resStart = (x / resolution).floor * resolution
        resEnd = resStart + resolution
        cY = (yUpper - data.lowerAtIndex(idx)) * yFactor
      }
    } else {
      for (; idx <= range.endIndex; idx++){
        CGPathAddLineToPoint(pathRef, nil, ((data.xAtIndex(idx) - xLower) * xFactor).cgfloat, ((yUpper - data.lowerAtIndex(idx)) * yFactor).cgfloat)
      }
    }
    
    //Upper path draw
    if range.count > Int((self.bounds.size.width) / resolution.cgfloat) {
      while idx >= range.startIndex {
        findMin = (cY > y) ? false : true
        while x < resEnd && idx <= range.endIndex {
          cY = (yUpper - data.upperAtIndex(idx)) * yFactor
          y = findMin ? min(cY, y) : max(cY, y)
          idx--
          x = (data.xAtIndex(idx) - xLower) * xFactor
        }
        CGPathAddLineToPoint(pathRef, nil, resStart.cgfloat, y.cgfloat)
        
        resStart = (x / resolution).floor * resolution
        resEnd = resStart + resolution
        cY = (yUpper - data.upperAtIndex(idx)) * yFactor
      }
    } else {
      for (; idx >= range.startIndex; idx--){
        CGPathAddLineToPoint(pathRef, nil, ((data.xAtIndex(idx) - xLower) * xFactor).cgfloat, ((yUpper - data.upperAtIndex(idx)) * yFactor).cgfloat)
      }
    }
    
    CGPathCloseSubpath(pathRef)
    
    return pathRef
  }
}