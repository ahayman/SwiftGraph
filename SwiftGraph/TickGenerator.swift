//
//  TickGenerator.swift
//  SwiftGraph
//
//  Created by Aaron Hayman on 3/14/16.
//  Copyright © 2016 FlexileSoft, LLC. All rights reserved.
//

import Foundation

private func niceNumber(num: Double, round: Bool = true) -> Double {
  let exp = floor(log10(num))
  let fraction = num / pow(10, exp)
  let nice: Double
  
  if (round) {
    if (fraction < 1.5) {
      nice = 1
    } else if (fraction < 3) {
      nice = 2
    } else if (fraction < 7) {
      nice = 5
    } else {
      nice = 10
    }
  } else {
    if (fraction <= 1) {
      nice = 1
    } else if (fraction <= 2) {
      nice = 2
    } else if (fraction <= 5) {
      nice = 5
    } else {
      nice = 10
    }
  }
  
  return nice * pow(10, exp);
}