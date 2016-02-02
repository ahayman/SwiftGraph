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
struct GraphRange <T: FloatingArithmatic> {
  
  // MARK: Private
  
  //Private variables
  private var _upperBounds : T
  private var _lowerBounds : T
  
  // MARK: Properties
  
  /// The maximum value of the range
  var rangeMax : T {
    didSet {
      if (rangeMax < rangeMin) { rangeMin = rangeMax }
      if (_upperBounds > rangeMax) { _upperBounds = rangeMax }
      if (_lowerBounds > rangeMax) { _lowerBounds = rangeMax }
    }
  }
  
  /// The minimum value of the range
  var rangeMin : T {
    didSet {
      if (rangeMax < rangeMin) { rangeMax = rangeMin }
      if (_lowerBounds < rangeMin) { _lowerBounds = rangeMin }
      if (_upperBounds < rangeMin) { _upperBounds = rangeMin }
    }
  }
  
  /// The span of the range (max - min)
  var rangeSpan : T {
    get { return rangeMax - rangeMin }
  }
  
  /// The upper bounds.  Cannot Set below the lowerBounds.  Also, if minBoundScale or maxBoundScale is set to anything other than 0, this setting this value will fail if the resulting rangeSpan exceed the scale bounds
  var upperBounds : T {
    set(upperBounds) {
      if upperBounds < _lowerBounds {
        return;
      }
      if minBoundScale?.isNormal ?? false || maxBoundScale?.isNormal ?? false {
        let newScale = self.rangeSpan / (upperBounds - _lowerBounds);
        if (minBoundScale?.isNormal ?? false  || newScale >= minBoundScale) && (maxBoundScale?.isNormal ?? false || newScale <= maxBoundScale) {
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
  var lowerBounds : T {
    set(lowerBounds) {
      if (lowerBounds > _upperBounds){
        return;
      }
      if (minBoundScale?.isNormal ?? false || maxBoundScale?.isNormal ?? false){
        let newScale = self.rangeSpan / (_upperBounds - lowerBounds);
        if (minBoundScale?.isNormal ?? false || newScale >= minBoundScale) && (maxBoundScale?.isNormal ?? false || newScale <= maxBoundScale) {
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
  var maxBoundScale : T?
  
  /// Default: 0, 0 = No max min scale.  This will limit the minimum scale to the value or no minimum if value is 0
  var minBoundScale : T?
  
  /// The bound span is the current span on the bounds (upper - lower bounds)
  var boundSpan : T {
      return upperBounds - lowerBounds
  }
  
  /// The tick min represents the minimum value neccessary to display a tick within the graph range.  It will return either the rangeMin or the lowerBounds
  var tickMin : T {
      return max(rangeMin, lowerBounds)
  }
  
  /// The tick max represents the maximum value neccessary to display a tick withing the graph range.  It will return either the rangeMax or the upperBounds
  var tickMax : T {
      return min(rangeMax, upperBounds)
  }
  
  /// The tick span represents the total span range to display: tickMax - tickMin
  var tickSpan : T {
      return self.tickMax - self.tickMin
  }
  
  // MARK: Methods
  
  /**
  Expands the range by the factor, essentially taking the range span, multiply by the provided factor and spancing the rangeMin/Max by the difference
  
  - parameter factor: The factor you want to expand by.  For instance, 1 does nothing, .5 halves the range, 2 doubles the range
  */
  mutating func expandRangeByFactor(factor : T) {
    let span = self.rangeSpan
    let newSpan = span * factor
    let diff = (newSpan - span) / T(2.0)
    rangeMin = rangeMin - diff
    rangeMax = rangeMax + diff
  }
  
  /**
  Expands the bounds by the factor, essentially taking the bounds span, multiply by the provided factor and spancing the boundsMin/Max by the difference
  
  - parameter factor: The factor you want to expand by.  For instance, 1 does nothing, .5 halves the bounds, 2 doubles the bounds
  */
  mutating func expandBoundsByFactor(factor : T) {
    let span = self.boundSpan
    let newSpan = span * factor
    let diff = (newSpan - span) / T(2.0)
    lowerBounds = lowerBounds - diff
    upperBounds = upperBounds + diff
  }
  
}

/**
*  The GraphSpace represents a base, and two ranges: the X & Y range
*/
struct GraphSpace <T: FloatingArithmatic> {
  var xBase : T
  let xRange: GraphRange<T>
  let yRange: GraphRange<T>
  
  init (xRange : GraphRange<T>, yRange : GraphRange<T>, base : T) {
    self.xRange = xRange;
    self.yRange = yRange;
    self.xBase = base;
  }
}