//
//  Settings.swift
//  ShopPal
//
//  Created by Daniel Ye on 2023-01-05.
//

import Foundation
import SwiftUI

//Settings
struct SettingsView: View {
    @State private var evan = true
    var body: some View {
        Toggle("Evan how the fuck does the database work???", isOn: $evan)
    
    }
}
