import SwiftUI
import Charts
import Foundation

//Kevin password field
struct HybridTextField: View {
    @Binding var text: String
    @State var isSecure: Bool = true
    var titleKey: String
    var body: some View {
        HStack{
            Group{
                if isSecure{
                    SecureField(titleKey, text: $text)
                }else{
                    TextField(titleKey, text: $text)
                }
            }
                .animation(.easeInOut(duration: 0.2), value: isSecure)
                .textFieldStyle(PlainTextFieldStyle())
                .multilineTextAlignment(.leading)
                .font(.system(size: 20, weight: .medium, design: .default))
//                .autocapitalization(.none)
            Button(action: {
                isSecure.toggle()
            }, label: {
                Image(systemName: !isSecure ? "eye.slash" : "eye" )
                    
            })
        }
    }
}

//Not sure
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

//Sign up screen
struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
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
                        print("Success")
                    }
                    else {
                        print("Fail")
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

//Login screen
struct LoginView: View {
    
    //Variables to store input field data
    @State private var usernameOrEmail: String = ""
    @State private var password: String = ""
    @State private var isLoginInfoCorrect: Bool = true
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
                    
                    TextField("Username or email", text: $usernameOrEmail)
                        .placeholder(when: usernameOrEmail.isEmpty) {
                            Text("Username or email").foregroundColor(Color(.lightGray))
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
                        .scaledToFit()
                        .padding(4)
//                        .autocapitalization(.none)
                     
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
                        .scaledToFit()
                    
                    //Login button
                    VStack{
                        Button(action:{
                            

                            let responseJson = ShopPal.login(email: usernameOrEmail.lowercased(), password: password)
                            
                            if responseJson["status"] as! Int == 200 {
                                isLoginInfoCorrect = true
                            } else {
                                isLoginInfoCorrect = false
                            }
                            
                            //Check the username or password in database
                            //This is temp for testing
//                            if usernameOrEmail == "John" && password == "Turco" {
//                                isLoginInfoCorrect = true
//                            }
//                            else{
//                                isLoginInfoCorrect = false
//                            }
                            
                            
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
        print("Username: \(usernameOrEmail)")
        print("Password: \(password)")
    }
}//End of Login screen
 

//Button styling method
struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.headline)
    }
}


//Main screen
struct mainScreen: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ChartView()
                .tabItem{
                    Image(systemName: "chart.bar.fill")
                    Text("Chart")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}//End of main screen

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
}//End of home screen

//Settings
struct SettingsView: View {
    @State private var evan = true
    var body: some View {
        Toggle("Evan how the fuck does the database work???", isOn: $evan)
    
    }
}

//Graph
struct ChartView: View {
    let slices  = [1,2,3,4,5,6,7]
    let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .cyan, .purple]

    var body: some View {
        VStack {
            Pie(slices: slices.enumerated().map { (index, slice) in
                return (Double(slice), Color(colors[index]))
            })
            
            List(slices, id: \.self) { slice in
                Text("\(slice)")
            }
        }
    }
}

//Graph helper
struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

//Graph Helper
var data: [ToyShape] = [
    .init(type: "Cube", count: 5),
    .init(type: "Sphere", count: 4),
    .init(type: "Pyramid", count: 4)
]
//Graph Helper
struct Pie: View {

    @State var slices: [(Double, Color)]

    var body: some View {
        Canvas { context, size in
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))

                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

//Main, use to call first screen
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


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
            print(response)
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
