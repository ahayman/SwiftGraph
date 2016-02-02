//
//  Arithmatic.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 1/31/16.
//  Copyright © 2016 FlexileSoft, LLC. All rights reserved.
//

import Foundation

/// This defines the allowable datatypes and the operations we will be performing on these datatypes.
public protocol FloatingArithmatic : FloatingPointType, FloatLiteralConvertible {
  func +(lhs: Self, rhs: Self) -> Self
  func -(lhs: Self, rhs: Self) -> Self
  func /(lhs: Self, rhs: Self) -> Self
  func *(lhs: Self, rhs: Self) -> Self
  
  init(_ value: Double)
  init(_ value: CGFloat)
  init(_ value: Float)
  
  var cgfloat: CGFloat { get }
  var int: Int { get }
  var floor: Self { get }
}

extension Double : FloatingArithmatic {
  public var cgfloat: CGFloat { return CGFloat(self) }
  public var int: Int { return Int(self) }
  public var floor: Double { return Double(Int(self)) }
}

extension Float : FloatingArithmatic {
  public var cgfloat: CGFloat { return CGFloat(self) }
  public var int: Int { return Int(self) }
  public var floor: Float { return Float(Int(self)) }
}

extension CGFloat : FloatingArithmatic {
  public init(_ value: CGFloat) {
    self = value
  }
  
  public var cgfloat: CGFloat { return CGFloat(self) }
  public var int: Int { return Int(self) }
  public var floor: CGFloat { return CGFloat(Int(self)) }
}