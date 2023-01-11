//
//  Main.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-05.
//

import Foundation
import SwiftUI

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
            CameraView()
                .tabItem{
                    Image(systemName: "camera")
                    Text("Scan")
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

class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }

    static func save(
        service: String,
        account: String,
        email: String,
        password: String
    ) throws {
        let data: [String: String] = [
            "email": email,
            "password": password
        ]

        let encoded = try JSONEncoder().encode(data)

        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: encoded as AnyObject,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }

        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        print("saved")
    }

    static func get(
        service: String,
        account: String
    ) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )
        return result as? Data
    }
    
    static func delete(
        service: String,
        account: String
    ) -> Int32? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
        ]

        let status = SecItemDelete(query as CFDictionary)

        
        return status
    }
}
