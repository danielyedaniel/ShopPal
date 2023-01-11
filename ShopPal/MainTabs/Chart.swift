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
            Spacer()
            Text("Monthly Spending")
                .foregroundColor(.green)
                .font(.system(size: 40, weight: .heavy, design: .default))
            Text("Report")
                .foregroundColor(.green)
                .font(.system(size: 40, weight: .heavy, design: .default))
            Spacer()
            BarGraph(data: [("A", 40.0), ("B", 30.0), ("C", 20.0), ("D", 10.0)])
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
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
