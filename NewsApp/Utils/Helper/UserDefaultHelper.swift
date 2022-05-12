//
//  Helper.swift
//  NewsApp
//
//  Created by Devansh Vyas on 12/05/22.
//

import Foundation

class UserDefaultHelper {
    static let shared = UserDefaultHelper()
    private let userDefault = UserDefaults.standard
    
    var user: User? {
        get {
            let data = userDefault.data(forKey: "user") ?? Data()
            do {
                return try JSONDecoder().decode(User.self, from: data)
            } catch {
                return nil
            }
        } set (newValue) {
            let data = try? JSONEncoder().encode(newValue)
            userDefault.set(data, forKey: "user")
            userDefault.synchronize()
        }
    }
}
