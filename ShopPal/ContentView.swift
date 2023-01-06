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
//Main, use to call first screen
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
