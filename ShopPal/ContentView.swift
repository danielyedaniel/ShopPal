

import SwiftUI

struct LoginView: View {
    
    //Variables to store input field data
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showCreateUserScreen: Bool = true

    var body: some View {
        //Navigation view for the new user page
        NavigationView {
            
            //Geometry Reader to bind elements to certain margins of parent view
            GeometryReader { metrics in
                
                //Vstack containing all views
                VStack (alignment: .center){
                    
                    //Title
                    Text("Login:")
                        .padding(20)
                        .font(.system(.title, design: .monospaced))
                    
                    //Username field
                    TextField("Username", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .padding(5)
                        .frame(width: metrics.size.width*0.85,alignment: .center)
                    
                    //Password field
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(5)
                        .frame(width: metrics.size.width*0.85,alignment: .center)
                    
                    //Login button (currently holds no purpose)
                    Button(action: login) {
                        Text("Login")
                    }
                    .buttonStyle(RoundedButtonStyle())
                    .frame(height:20)
                    .padding()
                    
                    //New user creation button
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

//Button styling method
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

//New user screen
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

//Main
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
