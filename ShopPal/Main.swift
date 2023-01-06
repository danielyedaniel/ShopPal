//
//  Main.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-05.
//

import Foundation
import SwiftUI

//Button styling method
struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.headline)
    }
}

//Main screen
struct mainScreen: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ChartView()
                .tabItem{
                    Image(systemName: "chart.bar.fill")
                    Text("Chart")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}//End of main screen

