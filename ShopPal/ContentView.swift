import SwiftUI
import Charts

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
                .autocapitalization(.none)
            Button(action: {
                isSecure.toggle()
            }, label: {
                Image(systemName: !isSecure ? "eye.slash" : "eye" )
                    
            })
        }
    }
}

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

struct SignUpView: View {
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
                    Button(action:{
                        print("Username: \(username)")
                        print("Password: \(password)")
                        print("Confirm Password: \(confirmPassword)")
                        
                        if(password==confirmPassword){
                            print("Success")
                        }else{
                            print("Fail")
                        }
                    }) {
                        Text("Submit")
                    }
                }
            }
        }
    }
}

struct LoginView: View {
    
    //Variables to store input field data
    @State private var usernameOrEmail: String = ""
    @State private var password: String = ""
    @State private var isLoginInfoCorrect: Bool = true
    @State private var messageToUser: String = ""

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
                    .autocapitalization(.none)
                 
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
                
                
                if isLoginInfoCorrect {
                    
                    NavigationLink(destination: mainScreen()){
                        Text("Login")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .frame(width: 220, height: 60)
                            .background(Color.green)
                            .cornerRadius(15)
                            .padding(.top, 20)
                    }
                }
                else{
                    Button(action: {
                        
                        messageToUser = "Incorrect email/username or password"
                        
                    }, label: {
                        Text("Login")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .frame(width: 220, height: 60)
                            .background(Color.green)
                            .cornerRadius(15)
                            .padding(.top, 20)
                        
                    })
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
              
        }
    }
        
    
        
        

        /*
        //Navigation view for the new user page
        NavigationView {
            
            //Geometry Reader to bind elements to certain margins of parent view
            GeometryReader { metrics in
                
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    
                    //Vstack containing all views
                    VStack (){
                        
                        Color.black
                            .ignoresSafeArea()
                        
                        Image("Logo")
                            .resizable()
                            .frame(width: 350, height: 350)
                            .cornerRadius(50)
                        
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
                        NavigationLink(destination: mainScreen()) {
                            Text("Login")
                            .frame(width: metrics.size.width*0.7, height:metrics.size.height*0.01)
                        }
                        .buttonStyle(RoundedButtonStyle())
                        //New user creation button
                        NavigationLink(destination: CreateUserScreen()) {
                            Text("New User")
                            .frame(width: metrics.size.width*0.7, height:metrics.size.height*0.01)
                        }
                        .buttonStyle(RoundedButtonStyle())
                    }
                }
                
                

            }
            .frame(width: 350, height: 450, alignment: .center)
        }
        .frame(alignment:.center)
        */
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
    }
}


//This will be the main screen
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
}

//Temp
struct HomeView: View {
    let groceryList = ["Apples", "Bananas", "Oranges", "Strawberries"]

    @State private var checked = [Bool](repeating: false, count: 4)

    var body: some View {
        List {
            ForEach(groceryList, id: \.self) { grocery in
                HStack {
                    Text(grocery)
                    Spacer()
                    Button(action: {
                        self.checked[self.groceryList.firstIndex(of: grocery)!] = !self.checked[self.groceryList.firstIndex(of: grocery)!]
                    }) {
                        Image(systemName: self.checked[self.groceryList.firstIndex(of: grocery)!] ? "checkmark.square" : "square")
                    }
                }
            }
        }
    }
}

//Temp
struct SettingsView: View {
    var body: some View {
        Text("This is the settings view")
    }
}

//Temp
struct ChartView: View {
    var body: some View {
        VStack {
            BarChart()
                .frame(width: 300, height: 300)
            List {
                ForEach(0..<5) { index in
                    Text("Item #(index + 1)")
                }
            }
        }
    }
}

//Temp
struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

//Temp
var data: [ToyShape] = [
    .init(type: "Cube", count: 5),
    .init(type: "Sphere", count: 4),
    .init(type: "Pyramid", count: 4)
]
//Temp
struct BarChart: View {
    var body: some View {
        Chart {
            BarMark(
                x: .value("Shape Type", data[0].type),
                y: .value("Total Count", data[0].count)
            )
            BarMark(
                 x: .value("Shape Type", data[1].type),
                 y: .value("Total Count", data[1].count)
            )
            BarMark(
                 x: .value("Shape Type", data[2].type),
                 y: .value("Total Count", data[2].count)
            )
        }
    }
}

//Main
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
