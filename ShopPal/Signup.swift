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
    @State private var creationSuccess = false
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State private var messageToUser = ""

    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.06, blue: 0.06)
                .ignoresSafeArea()
            
            VStack {
                Text("Sign Up")
                    .padding(.vertical)
                    .foregroundColor(.green)
                    .font(.system(size: 40, weight: .heavy, design: .default))
                
                //First name field
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
                
                //Last name field
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
                
                //Email field
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
                
                //Password field
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
                
                //Confirm password field
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
                
            //Confirm button
                Button(action: {
                    isValidEmail = true
                    isValidPassword = true
                    var atCounter = 0
                    var atIndex: Int = -1
                    var dotIndex: Int = -1
                    var counter = 0
                    var dotCounter = 0
                    
                    //Check if email is valid
                    for char in email {
                        if(char == "@"){
                            atCounter += 1
                            atIndex = counter
                        }
                        if(char == "."){
                            dotCounter += 1
                            dotIndex = counter
                        }
                        counter += 1
                    }
                    
                    if(dotIndex < atIndex || dotCounter != 1 || atCounter != 1 || atIndex < 1 || email.count - atIndex + 1 < 3 || email.count - dotIndex + 1 < 1){
                        isValidEmail = false
                    }
                    
                    if(password.count < 8){
                        isValidPassword = false
                    }
                   
                    if(isValidEmail){
                        messageToUser = ""
                        if(isValidPassword){
                            messageToUser = ""
                            if(password == confirmPassword) {
                                messageToUser = ""
                                let responseJson = ShopPal.signUp(firstName: firstName, lastName: lastName, email: email.lowercased(), password: password)
                                if responseJson["status"] as! Int == 200 {
                                    self.presentationMode.wrappedValue.dismiss()
                                    self.creationSuccess = true
                                }
                                
                            }else{
                                messageToUser = "Passwords do not match."
                            }
                        }
                        else{
                            messageToUser = "Password must be atleast 8 characters."
                        }
                    }
                    else{
                        messageToUser = "Invalid email."
                    }
                
                    
                    
                }) {
                    Text("Submit")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15)
                        .padding(.top, 20)
                }
                    
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text("Invalid sign up information"), dismissButton: .default(Text("Ok")))
                    }
                    .alert(isPresented: $creationSuccess) {
                        Alert(title: Text("Success!"), message: Text("Your account has been successfully created. Please sign in now."),
                              dismissButton: .default(Text("Dismiss")))
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
                responseJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                responseJson["status"] = httpResponse.statusCode
            }
        }
        semaphore.signal()
    }.resume()
    semaphore.wait()
    return responseJson
}
