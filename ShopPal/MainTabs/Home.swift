//
//  Home.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-05.
//

import Foundation
import SwiftUI


//Home Screen
struct HomeView: View {
    let groceryList = ["Apples", "Bananas", "Oranges", "Strawberries"]
    @State private var checked = [Bool](repeating: false, count: 4)

    var body: some View {
        List {
            ForEach(groceryList, id: \.self) { grocery in
                HStack {
                    Text(grocery)
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding(.trailing)
                        .scaledToFit()
                    Spacer()
                    Button(action: {
                        self.checked[self.groceryList.firstIndex(of: grocery)!] = !self.checked[self.groceryList.firstIndex(of: grocery)!]
                    }) {
                        Image(systemName: self.checked[self.groceryList.firstIndex(of: grocery)!] ? "checkmark.square" : "square")
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .foregroundColor(.white)
                            .padding(.leading)
                            .padding(.trailing)
                            .scaledToFit()
                    }
                }
            }
            .overlay(border, alignment: .top)
        }
        .ignoresSafeArea()
        .background(Color(red: 0.06, green: 0.06, blue: 0.06))
        
    }
    var border: some View {
        RoundedRectangle(cornerRadius: 16)
          .strokeBorder(
            LinearGradient(
              gradient: .init(
                colors: [
                    Color(red: 0.08, green: 0.64, blue: 0.15)
                ]
              ),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
      }
}//End of home screen
