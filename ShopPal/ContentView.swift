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

    var body: some View {
        VStack (alignment: .center){
            Text("Login:")
                .padding(20)
                .font(.title)
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding(5)
                .frame(width: 300)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(5)
                .frame(width: 300)
            Button(action: login) {
                Text("Login")
            }
            .padding()
        }
    }

    func login() {
        // Perform login action here
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
