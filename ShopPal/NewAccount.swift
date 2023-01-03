//
//  NewAccount.swift
//  ShopPal
//
//  Created by Kevin Liu on 2023-01-02.
//

import Foundation

final class NewAccount: Codable {
    var firstName:String
    var lastName:String
    var email:String
    var password:String
    
    init(firstName: String, lastName: String, email: String, password: String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
}
