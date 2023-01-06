//
//  Login.swift
//  ShopPal
//
//  Created by Evan Wang on 2023-01-05.
//

import Foundation
import SwiftUI

//Login screen
struct LoginView: View {
    
    //Variables to store input field data
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginInfoCorrect: Bool = false
    @State private var messageToUser: String = ""
    @State private var shouldNav = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.06, green: 0.06, blue: 0.06)
                    .ignoresSafeArea()
                
                VStack {
                    
                    Group{
                        Spacer()
                        Image("LongLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 380.0)
                            .cornerRadius(30)
                        
                        Spacer()
                    }
                    
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
                        .textInputAutocapitalization(.never)
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
                    
                    //Login button
                    VStack{
                        Button(action:{
                            let responseJson = ShopPal.login(email: email.lowercased(), password: password)
                            
                            if responseJson["status"] as! Int == 200 {
                                isLoginInfoCorrect = true
                            } else {
                                isLoginInfoCorrect = false
                            }
                            
                            //Navigate to new page if correct
                            if isLoginInfoCorrect {
                                self.shouldNav = true
                            }
                            else { //Output message to user if incorrect
                                messageToUser = "Incorrect email or password"
                            }
                            
                            
                        }){
                            Text("Login")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(.black)
                                .frame(width: 220, height: 60)
                                .background(Color.green)
                                .cornerRadius(15)
                                .padding(.top, 20)
                        }
                        
                        NavigationLink(destination: mainScreen(), isActive: $shouldNav){
                            Spacer()
                        }
                    }
                    
                    Group{
                        Spacer()
                        
                        Text(messageToUser)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .background(Color.black)
                            .foregroundColor(Color(.red))
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(Color(.lightGray))
                        
                            NavigationLink(destination: SignUpView()){
                                Text("SIGN UP")
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                    .foregroundColor(.green)
                            }
                    }
                }
                .preferredColorScheme(.dark)
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
    
    func login() {
        // Perform login action here
        print("Username: \(email)")
        print("Password: \(password)")
    }
}//End of Login screen


func login(email: String, password: String) -> [String: Any] {
    let url = URL(string: "https://www.wangevan.com/user/login")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = ["email": email, "password": password]
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
