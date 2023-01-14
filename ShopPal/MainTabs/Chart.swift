//
//  Chart.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-05.
//

import Foundation
import SwiftUI

struct ChartView: View {
    var body: some View {
        
        VStack{
            
        }
        
    }
}

struct BarGraph: View {
    var data: [(String, Double)]

    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 16) {
                ForEach(data.indices) { index in
                    BarView(value: self.data[index].1)
                        .frame(width: 50, height: 200)
                        .animation(.default)
                }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

struct BarView: View {
    var value: Double

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Capsule().frame(width: 40, height: 200)
                    .foregroundColor(Color.white.opacity(0.2))
                Capsule().frame(width: 30, height: CGFloat(value) * 2)
                    .foregroundColor(Color.green)
            }
        }
    }
}
