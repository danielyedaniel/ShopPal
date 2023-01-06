//
//  Chart.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-05.
//

import Foundation
import SwiftUI


//Graph
struct ChartView: View {
    let slices  = [1,2,3,4,5,6,7]
    let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .cyan, .purple]

    var body: some View {
        VStack {
            Pie(slices: slices.enumerated().map { (index, slice) in
                return (Double(slice), Color(colors[index]))
            })
            
            List(slices, id: \.self) { slice in
                Text("\(slice)")
            }
        }
    }
}
