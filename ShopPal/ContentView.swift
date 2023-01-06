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
