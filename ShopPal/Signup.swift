//
//  Signup.swift
//  ShopPal
//
//  Created by Evan Wang on 2023-01-05.
//

import Foundation
import SwiftUI

//Sign up screen
struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError = false

    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.06, blue: 0.06)
                .ignoresSafeArea()
            
            VStack {
                Text("Sign Up")
                    .padding(.vertical)
                    .foregroundColor(.green)
                    .font(.system(size: 40, weight: .heavy, design: .default))
                
                TextField("First Name", text: $firstName)
                    .placeholder(when: firstName.isEmpty) {
                        Text("First Name").foregroundColor(Color(.lightGray))
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
//                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                TextField("Last Name", text: $lastName)
                    .placeholder(when: lastName.isEmpty) {
                        Text("Last Name").foregroundColor(Color(.lightGray))
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
//                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                TextField("Email", text: $email)
                    .placeholder(when: email.isEmpty) {
                        Text("Email").foregroundColor(Color(.lightGray))
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
//                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                HybridTextField(text: $password, titleKey: "Password")
                    .placeholder(when: password.isEmpty) {
                        Text("Password").foregroundColor(Color(.lightGray))
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
//                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                
                HybridTextField(text: $confirmPassword, titleKey: "Confirm Password")
                    .placeholder(when: confirmPassword.isEmpty) {
                        Text("Confirm Password").foregroundColor(Color(.lightGray))
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
//                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button(action: {
                    if(password == confirmPassword) {
                        let responseJson = ShopPal.signUp(firstName: firstName, lastName: lastName, email: email.lowercased(), password: password)
                        if responseJson["status"] as! Int == 200 {
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            withAnimation {
                                self.showError = true
                            }
                        }
                    }
                    else {
                        self.showError = true
                    }
                }) {
                    Text("Submit")
                }
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15)
                    .padding(.top, 20)
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text("Invalid sign up information"), dismissButton: .default(Text("Ok")))
                    }
                Spacer()
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
}//End of Sign up screen


//Sign up code
func signUp(firstName: String, lastName: String, email: String, password: String) -> [String: Any] {
    let url = URL(string: "https://www.wangevan.com/user/signup")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = ["firstName": firstName, "lastName":lastName , "email": email, "password": password]
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
//                responseJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                responseJson["status"] = httpResponse.statusCode
            }
        }
        semaphore.signal()
    }.resume()
    semaphore.wait()
    return responseJson
}
