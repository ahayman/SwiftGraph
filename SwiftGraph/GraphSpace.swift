//
//  GraphSpace.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 12/24/14.
//  Copyright (c) 2014 FlexileSoft, LLC. All rights reserved.
//

import Foundation

/**
*  The GraphRange describes a range of values and bounds.  This helps to define the range of values for a graph and the current "view window" into that range.  The bounds describes this "view window".  You can also
*/
struct GraphRange {
  
  // MARK: Private
  
  //Private variables
  private var _rangeMax : Double = 0
  private var _rangeMin : Double = 0
  private var _upperBounds : Double = 0
  private var _lowerBounds : Double = 0
  
  // MARK: Properties
  
  /// The maximum value of the range
  var rangeMax : Double {
    get {
      return _rangeMax;
    }
    set(rangeMax) {
      _rangeMax = rangeMax;
      if (_rangeMax < _rangeMin) { _rangeMin = _rangeMax }
      if (_upperBounds > _rangeMax) { _upperBounds = _rangeMax }
      if (_lowerBounds > _rangeMax) { _lowerBounds = _rangeMax }
    }
  }
  
  /// The minimum value of the range
  var rangeMin : Double {
    get {
      return _rangeMin;
    }
    set(rangeMin) {
      _rangeMin = rangeMin;
      if (_rangeMax < _rangeMin) { _rangeMax = _rangeMin }
      if (_lowerBounds < _rangeMin) { _lowerBounds = _rangeMin }
      if (_upperBounds < _rangeMin) { _upperBounds = _rangeMin }
    }
  }
  
  /// The span of the range (max - min)
  var rangeSpan : Double {
    get {
      return self.rangeMax - self.rangeMin
    }
  }
  
  /// The upper bounds.  Cannot Set below the lowerBounds.  Also, if minBoundScale or maxBoundScale is set to anything other than 0, this setting this value will fail if the resulting rangeSpan exceed the scale bounds
  var upperBounds : Double {
    set(upperBounds) {
      if (upperBounds < _lowerBounds){
        return;
      }
      if (minBoundScale != 0 || maxBoundScale != 0){
        let newScale = self.rangeSpan / (upperBounds - _lowerBounds);
        if ((minBoundScale == 0 || newScale >= minBoundScale) && (maxBoundScale == 0 || newScale <= maxBoundScale)){
          _upperBounds = upperBounds;
        }
      } else {
        _upperBounds = upperBounds;
      }
    }
    get {
      return _upperBounds;
    }
  }
  
  /// The lower bounds.  Cannot set above the upperBounds. Also, if minBoundScale or maxBoundScale is set to anything other than 0, this setting this value will fail if the resulting rangeSpan exceed the scale bounds
  var lowerBounds : Double {
    set(lowerBounds) {
      if (lowerBounds > _upperBounds){
        return;
      }
      if (minBoundScale != 0 || maxBoundScale != 0){
        let newScale = self.rangeSpan / (_upperBounds - lowerBounds);
        if ((minBoundScale == 0 || newScale >= minBoundScale) && (maxBoundScale == 0 || newScale <= maxBoundScale)){
          _lowerBounds = lowerBounds;
        }
      } else {
        _lowerBounds = lowerBounds;
      }
    }
    get {
      return _lowerBounds;
    }
  }
  
  /// Default: 0, 0 = No max bound scale.  This will limit the maximum scale to the value or no max if value is 0
  var maxBoundScale : Double = 0
  
  /// Default: 0, 0 = No max min scale.  This will limit the minimum scale to the value or no minimum if value is 0
  var minBoundScale : Double = 0
  
  /// The bound span is the current span on the bounds (upper - lower bounds)
  var boundSpan : Double {
      return upperBounds - lowerBounds
  }
  
  /// The tick min represents the minimum value neccessary to display a tick within the graph range.  It will return either the rangeMin or the lowerBounds
  var tickMin : Double {
      return max(rangeMin, lowerBounds)
  }
  
  /// The tick max represents the maximum value neccessary to display a tick withing the graph range.  It will return either the rangeMax or the upperBounds
  var tickMax : Double {
      return min(rangeMax, upperBounds)
  }
  
  /// The tick span represents the total span range to display: tickMax - tickMin
  var tickSpan : Double {
      return self.tickMax - self.tickMin
  }
  
  // MARK: Methods
  
  /**
  Expands the range by the factor, essentially taking the range span, multiply by the provided factor and spancing the rangeMin/Max by the difference
  
  - parameter factor: The factor you want to expand by.  For instance, 1 does nothing, .5 halves the range, 2 doubles the range
  */
  mutating func expandRangeByFactor(factor : Double) {
    let span = self.rangeSpan
    let newSpan = span * factor
    let diff : Double = (newSpan - span) / 2
    self.rangeMin -= diff
    self.rangeMax += diff
  }
  
  /**
  Expands the bounds by the factor, essentially taking the bounds span, multiply by the provided factor and spancing the boundsMin/Max by the difference
  
  - parameter factor: The factor you want to expand by.  For instance, 1 does nothing, .5 halves the bounds, 2 doubles the bounds
  */
  mutating func expandBoundsByFactor(factor : Double) {
    let span = self.boundSpan
    let newSpan = span * factor
    let diff = (newSpan - span) / 2
    self.lowerBounds -= diff
    self.upperBounds += diff
  }
  
}

/**
*  The GraphSpace represents a base, and two ranges: the X & Y range
*/
struct GraphSpace {
  var xBase : Double
  let xRange: GraphRange
  let yRange: GraphRange
  
  init (xRange : GraphRange, yRange : GraphRange, base : Double) {
    self.xRange = xRange;
    self.yRange = yRange;
    self.xBase = base;
  }
}