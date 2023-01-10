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
    let receipts: [AnyObject]
    @State private var checked = [Bool](repeating: false, count: 4)
    
    init() {
        let responseJson = getReceipts()
        receipts = responseJson["items"] as! [AnyObject]
    }

    var body: some View {
      VStack(alignment: .leading) {
//          ForEach(receipts, id: \.self) { receipt in
//              VStack(alignment: .leading) {
//                  Text(receipt["store"])
//                      .font(.headline)
//                  Text(receipt["receiptDate"])
//                      .font(.subheadline)
//                  Image(uiImage: receipt.image)
//                      .resizable()
//                      .frame(width: 300, height: 150)
//                  Text("Total: $\(receipt.total)")
//                      .font(.headline)
//                  ForEach(receipt["items"], id: \.self) { item in
//                      HStack {
//                          Text(item.name)
//                          Spacer()
//                          Text("$\(item.price)")
//                      }
//                  }
//              }
//          }
          Text("Hi")
      }
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
    
    
}//End of home screen

func getReceipts() -> [String: Any] {
    let data = KeychainManager.get(
        service: "ShopPal",
        account: "emailAndPassword"
    )
    let body = try! JSONDecoder().decode([String: String].self, from: data!)
    
    let url = URL(string: "https://www.wangevan.com/history/get")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
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
