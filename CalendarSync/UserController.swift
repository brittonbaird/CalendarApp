//
//  UserController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/28/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    var user = User()
    var contacts: [User] = []
    var events: [Event] = []
    
    static var shared = UserController()
    
    let baseURL = URL(string: "https://calendarsync-79cbe.firebaseio.com/")
    
    func updateUser(WithName name: String, email: String, userID: String) {
        self.user = User(name: name, email: email, userID: userID)
    }
    
    func fetchUser(withID userID: String, completion: @escaping() -> Void) {
       
        guard let baseUrl = baseURL else { completion(); return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(userID).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error getting data for user: \(error)")
                completion()
                return
            }
            
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8) else { completion(); return }
            print(responseDataString)
            
            guard let userDictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { completion(); return }
            
            guard let user = User(jsonDictionary: userDictionary, userID: userID) else { completion(); return }
            
            self.user = user
            
            completion()
        }
        dataTask.resume()
    }
    
    func updateFirebaseUser(completion: @escaping() -> Void) {
        
        guard let baseUrl = baseURL else { completion(); return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.userID).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = user.jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8)
                else { completion(); return }
            
            
            if let error = error {
                print("Error updating user data: \(error)")
                completion()
                return
            } else {
                print(responseDataString)
                completion()
            }
            
        }
        dataTask.resume()
    }
    
//    func fetchContact(withID userID: String) {
//        
//        guard let baseUrl = baseURL else { return }
//        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(userID).appendingPathExtension("json")
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.httpBody = nil
//        
//        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
//            if let error = error {
//                print("Error fetching contact: \(error)")
//            }
//            
//            guard let data = data,
//                let responseDataString = String(data: data, encoding: .utf8) else { return }
//            
//            print(responseDataString)
//            
//            guard let contactDictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { return }
//            
//            guard let contact = User(jsonDictionary: contactDictionary, userID: userID) else { return }
//            
//            self.contacts.append(contact)
//        }
//        dataTask.resume()
//    }
    
}












