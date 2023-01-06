//
//  Settings.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-05.
//

import Foundation
import SwiftUI

//Settings
struct SettingsView: View {
    @State private var evan = true
    var body: some View {
        Toggle("Evan how the fuck does the database work???", isOn: $evan)
    
    }
}

//Graph Helper
struct Pie: View {

    @State var slices: [(Double, Color)]

    var body: some View {
        Canvas { context, size in
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))

                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
