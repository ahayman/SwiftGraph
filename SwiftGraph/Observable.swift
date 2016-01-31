//
//  Observable.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 1/30/16.
//  Copyright © 2016 FlexileSoft, LLC. All rights reserved.
//

import Foundation

/**
 This is a simple observable that allows you to observe Values on specific type.  It's designed to act as a container that will notify via callbacks whenever it's contents has changed.  This allows for a React style of programming.
 
 There are two types of callbacks, attached callbacks and transient callbacks.  Transient callbacks (set by using `onNext(_)`) are called once on the next change and then removed.  Attached callbacks remain attached to the observable until the callback returns `false`.  This allows the callback to determine how long it should be attached to the observable.  A common use case for this is to use a weak capture list to include the observing object.  If the observing object is `nil`, then return `false` to remove the callback.
 
 Note: You cannot instantiate an `Observable` directly.  You must do so using the `MObservable` subclass.  This separates out readability from writability, enabling you to return `Observable` items that can't be mutated by the observers.  Of course, if you wish to allow the observers to modify, return the `MObservable` subclass instead.
 */

public class Observable <T> {
  
  public typealias AttachedCallback = T -> Bool
  public typealias TransientCallback = T -> Void
  public typealias AllowCallback = (T,T) -> Bool
  
  private var internalValue: T
  private var nexts: [TransientCallback] = []
  private var callbacks: [AttachedCallback] = []
  
  /// Init with a value
  private init(privateValue: T){
    internalValue = privateValue
  }
  
  /// Returns the current value
  public var value: T {
    return internalValue
  }
  
  /// This will add a callback that will be called whenever the contents have changed
  public func on(cb:AttachedCallback) {
    callbacks.append(cb)
  }
  
  /// This will add a callback that will be called the next time the contents have changed, and then it will be removed.
  public func onNext(cb:TransientCallback) {
    nexts.append(cb)
  }
  
  /// Set the value, this will trigger any set callbacks.  This may fail if `allow` is set and it returns false
  private func set_(value: T) {
    internalValue = value
    
    self.callbacks = self.callbacks.filter{ $0(value) }
    
    for cb in nexts {
      cb (internalValue)
    }
    
    nexts = []
  }
  
  /// This clears all callbacks
  public func clear() {
    callbacks = []
    nexts = []
  }
  
}

/**
 The mutable counterpart to Observable.  This subclass can only be instantiated for observables.
 */
final public class MObservable <T> : Observable<T> {
  
  /// You can restrict the values set to this Observable by setting this callback
  public var allow: AllowCallback?
  
  /// Init with a value
  public init(_ value: T) {
    super.init(privateValue: value)
  }
  
  /// Set the value, this will trigger any set callbacks.  This may fail if `allow` is set and it returns false
  public func set(value: T) {
    if let allowCB = allow where !allowCB(internalValue, value) {
      return
    }
    
    self.set_(value)
  }
}