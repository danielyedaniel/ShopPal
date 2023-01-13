//
//  Home.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-05.
//

import Foundation
import SwiftUI
import UIKit


//Home Screen
struct HomeView: View {
    var receipts: Receipts
    @State private var checked = [Bool](repeating: false, count: 4)
    
    init() {
        receipts = getReceipts()
        print(receipts)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ForEach(receipts.items, id: \.self) { receipt in
                    NavigationLink(destination: ReceiptView(receipt: receipt)) {
                        HStack {
                            Text(receipt.store)
                            Spacer()
                            Text("$\(String(format: "%.2f", receipt.total))")
                            Spacer()
                            Text(formatDate(receipt.receiptDate))
                        }.background(RoundedRectangle(cornerRadius: 32)
                          .strokeBorder(LinearGradient(
                            gradient: .init(colors: [
                            ]
                          ),
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing
                          ))
                        ).padding(20)
                    }

                    .background(border)
                }
                .navigationBarTitle("Receipts")
                Spacer()

            }
            
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

struct ReceiptView: View {
    var receipt: Receipt
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(receipt.store)
                .font(.headline)
            Text(formatDate(receipt.receiptDate))
                .font(.subheadline)
            if let url = URL(string: receipt.image),
                let data = try? Data(contentsOf: url),
                let uiImage = UIImage(data: data) {
                  Image(uiImage: uiImage)
                      .resizable()
                      .frame(width: 300, height: 400)
            }
            Text("$\(String(format: "%.2f", receipt.total))")
                .font(.headline)
            ForEach(receipt.items, id: \.self) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("$\(String(format: "%.2f", item.price))")
                }
            }
        }
    }
}

struct Receipts: Decodable {
    let items: [Receipt]
}

struct Receipt: Decodable, Hashable {
    let image: String
    let receiptDate: String
    let total: Double
    let address: String?
    let email: String
    let items: [Item]
    let store: String
}

struct Item: Decodable, Hashable {
    let name: String
    let price: Double
}

func getReceipts() -> Receipts {
    let data = KeychainManager.get(
        service: "ShopPal",
        account: "emailAndPassword"
    )
    let credentials = try! JSONDecoder().decode([String: String].self, from: data!)

    let url = URL(string: "https://www.wangevan.com/history/get")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonData = try! JSONSerialization.data(withJSONObject: credentials)
    request.httpBody = jsonData

    let semaphore = DispatchSemaphore(value: 0)
    var responseData: Data?
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print(error)
        } else {
            responseData = data
        }
        semaphore.signal()
    }.resume()
    semaphore.wait()

    let receipts = try! JSONDecoder().decode(Receipts.self, from: responseData!)
    return receipts
}

func formatDate(_ dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: date!)
}
