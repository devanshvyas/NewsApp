//
//  User.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import Foundation


class User: Codable {
    var fullName: String?
    var username: String?
    var email: String?
    var dob: String?
    var mobile: String?
    
    init() {
        
    }
    
    init(fullName: String?, username: String?, email: String?, dob: String?, mobile: String?) {
        self.fullName = fullName
        self.username = username
        self.email = email
        self.dob = dob
        self.mobile = mobile
    }
    
    enum CodingKeys: CodingKey {
        case fullName
        case username
        case email
        case dob
        case mobile
    }
}
