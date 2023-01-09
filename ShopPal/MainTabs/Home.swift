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
    
    // function to get all user receipts
    func getReceipts() -> [String: Any] {
        let url = URL(string: "https://www.wangevan.com/history/get")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": "email", "password": "password"]
        let jsonData = try! JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        let semaphore = DispatchSemaphore(value: 0)
        var responseJson: [String: Any] = [:]
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                let httpResponse = response as! HTTPURLResponse
                if (httpResponse.statusCode == 400) {
                    let str = String(decoding: data!, as: UTF8.self)
                    print(str)
                    responseJson = ["status": 400, "error": str]
                } else {
                    responseJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    responseJson["status"] = httpResponse.statusCode
                }
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return responseJson
    }
    
}//End of home screen

