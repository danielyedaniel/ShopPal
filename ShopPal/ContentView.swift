import SwiftUI
import Charts

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
            .frame(width: 350, height: 450, alignment: .center)
        }
        .frame(alignment:.center)
    }

    func login() {
        // Perform login action here
        print("Username: \(username)")
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

//This will be the main screen
struct mainScreen: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            ChartView()
                .tabItem{
                    Image(systemName: "airpodpro.right")
                    Text("Chart")
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
