//
//  String.swift
//  NewsApp
//
//  Created by Devansh Vyas on 11/05/22.
//

import Foundation
import libPhoneNumber_iOS

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,15}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidUsername() -> Bool {
        let passwordRegex = "^[0-9a-zA-Z\\_]{1,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        let phoneNumber = try? NBPhoneNumberUtil().parse(self, defaultRegion: "IN")
        return NBPhoneNumberUtil().isValidNumber(phoneNumber)
    }
}
