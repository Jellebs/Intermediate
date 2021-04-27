//
//  LineGraph.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//

import SwiftUI

struct lineGraph: Shape {
    var dataPoints: [Double]
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            guard dataPoints.count > 1 else { return }
            
            let start = dataPoints[0]
            let a = CGPoint(x: 0, y: start) //1 - start * Double(rect.height))
            path.move(to: a)
            
            
            for idx in dataPoints.indices {
                path.addLine(to: point(at: idx, in: rect))
            }
        }
        
    }
    private func point(at: Int, in rect: CGRect) -> CGPoint {
        let point = dataPoints[at]
        let x = Double(rect.width) * Double(at) / Double(dataPoints.count - 1)
        var y = 0.0
        y = (1-point) * Double(rect.height)

        
       
        return CGPoint(x: x, y: y)
    }
}
