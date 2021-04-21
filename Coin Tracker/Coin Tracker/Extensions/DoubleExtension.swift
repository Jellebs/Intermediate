//
//  DoubleExtension.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//

import Foundation

extension Double {
    func converting(from input: ClosedRange<Self>, to output: ClosedRange<Self> ) -> Self {
        let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
        let y = (input.upperBound - input.lowerBound)
        return x / y + output.lowerBound
    }
}
