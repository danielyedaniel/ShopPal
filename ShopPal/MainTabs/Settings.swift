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
    @Environment(\.presentationMode) var presentationMode
    @State private var currPassword: String
    @State private var enteredCur: String = ""
    @State private var enteredNew: String = ""
    @State private var enteredConfirm: String = ""
    @State private var messageToUser = ""
    @State private var email: String
    
    init() {
        let data = KeychainManager.get(
                    service: "ShopPal",
                    account: "emailAndPassword"
                )

        let credentials = try! JSONDecoder().decode([String: String].self, from: data!)
        _currPassword = State(initialValue: credentials["password"]!)
        _email = State(initialValue: credentials["email"]!)
    }
    
    var body: some View {
        VStack{
                Spacer()
                
                Text("Change Password")
                    .padding(.vertical)
                    .foregroundColor(.green)
                    .font(.system(size: 40, weight: .heavy, design: .default))
                

                    TextField("Current password", text: $enteredCur)
                        .placeholder(when: enteredCur.isEmpty) {
                            Text("Current password").foregroundColor(Color(.lightGray))
                        }
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .foregroundColor(.white)
                        .background(border)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(4)
                        .disableAutocorrection(true)
          
                
                TextField("New password", text: $enteredNew)
                    .placeholder(when: enteredNew.isEmpty) {
                        Text("New password").foregroundColor(Color(.lightGray))
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
                    .background(border)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(4)
                    .disableAutocorrection(true)
                
                TextField("Confirm password", text: $enteredConfirm)
                    .placeholder(when: enteredConfirm.isEmpty) {
                        Text("Confirm password").foregroundColor(Color(.lightGray))
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
                    .background(border)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(4)
                    .disableAutocorrection(true)
                    
                
                Group{
                    Spacer()
                    
                    Text(messageToUser)
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .background(Color.black)
                        .foregroundColor(Color(.red))
                    
                    Spacer()
                }
                
                Button {
                    print(enteredCur)
                    print(currPassword)
                    print(enteredNew)
                    print(enteredConfirm)
                    if(enteredCur == currPassword && enteredCur != enteredNew && enteredNew == enteredConfirm){
                        ShopPal.changePassword(email: email.lowercased(), newPassword: enteredNew)
                        KeychainManager.delete(
                            service: "ShopPal",
                            account: "emailAndPassword"
                        )
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    else if(enteredCur != currPassword){
                        messageToUser = "Current password is incorrect"
                    }
                    else if(enteredCur == enteredNew){
                        messageToUser = "New password must be different from current password"
                    }
                    else if(enteredNew.count < 8){
                        messageToUser = "Password must be atleast 8 characters"
                    }
                    else if(enteredNew != enteredConfirm){
                        messageToUser = "Passwords must match"
                    }
                        
                } label: {
                    Text("Submit Change")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15)
                        .padding(.top, 20)
                }

                
                Spacer()
            
            Button {
                KeychainManager.delete(
                    service: "ShopPal",
                    account: "emailAndPassword"
                )
                self.presentationMode.wrappedValue.dismiss()
                
            } label: {
                Text("Logout")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15)
            }
            
            Spacer()
                
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
}

func changePassword(email: String, newPassword: String) -> [String: Any] {
    let url = URL(string: "https://www.wangevan.com/user/changepassword")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = ["email": email, "newPassword": newPassword]
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

