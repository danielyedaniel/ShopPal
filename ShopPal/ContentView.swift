//
//  ContentView.swift
//  ShopPal
//
//  Created by Daniel Ye on 2022-12-25.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showCreateUserScreen: Bool = true

    var body: some View {
        NavigationView {
            GeometryReader { metrics in
                VStack (alignment: .center){
                    Text("Login:")
                        .padding(20)
                        .font(.system(.title, design: .monospaced))
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .padding(5)
                        .frame(width: metrics.size.width*0.85,alignment: .center)
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(5)
                        .frame(width: metrics.size.width*0.85,alignment: .center)
                    Button(action: login) {
                        Text("Login")
                    }
                    .buttonStyle(RoundedButtonStyle())
                    .frame(height:20)
                    
                    .padding()
                    NavigationLink(destination: CreateUserScreen()) {
                        Text("New User")
                    }
                }

            }
            .frame(width: 350, height: 450, alignment: .center)
        }
        .frame(alignment:.center)
    }

    func login() {
        // Perform login action here
    }
}

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.headline)
            .frame(height:20)
    }
}

struct CreateUserScreen: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack{
            Form {
                Section {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                Section {
                    Button(action: {
                        // Create the new user here
                    }) {
                        Text("Submit")
                    }
                }
            }
        }
    }
}






//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
