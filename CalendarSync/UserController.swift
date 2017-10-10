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
    var contacts: [Contact] = []
    var events: [Event] = []
    
    static var shared = UserController()
    
    let baseURL = URL(string: "https://calendarsync-79cbe.firebaseio.com/")
    
    func saveToUserDefaults(value: String) {
        UserDefaults.standard.set(value, forKey: "phoneNumber")
        user.phoneNumber = value
    }
    
    func loadNumberFromUserDefaults(key: String) {
        guard let number = UserDefaults.standard.string(forKey: key) else { return }
        user.phoneNumber = number
    }
    
    func updateUser(WithName name: String, email: String, userID: String) {
        self.user = User(name: name, email: email, phoneNumber: userID)
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
                let _ = String(data: data, encoding: .utf8) else { completion(); return }
            //print(responseDataString)
            
            guard let userDictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { completion(); return }
            
            guard let user = User(jsonDictionary: userDictionary, phoneNumber: userID) else { completion(); return }
            
            self.user = user
            
            completion()
        }
        dataTask.resume()
    }
    
    func updateFirebaseUser(completion: @escaping() -> Void) {
        
        guard let baseUrl = baseURL else { completion(); return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = user.jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data,
                let _ = String(data: data, encoding: .utf8)
                else { completion(); return }
            
            
            if let error = error {
                print("Error updating user data: \(error)")
                completion()
                return
            } else {
                //print(responseDataString)
                completion()
            }
            
        }
        dataTask.resume()
    }
    
    func addContact(withPhoneNumber phoneNumber: String, name: String, completion: @escaping() -> Void) {
        let contact = Contact(name: name, contactNumber: phoneNumber)
        
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("contacts").appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = contact.jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data,
                let _ = String(data: data, encoding: .utf8)
                else { completion(); return }
            
            
            if let error = error {
                print("Error updating user data: \(error)")
                completion()
                return
            } else {
                //print(responseDataString)
                completion()
            }
            
            self.contacts.append(contact)
            
            completion()
        }
        dataTask.resume()
    }
    
    func deleteContact(contact: Contact, completion: @escaping() -> Void) {
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("events").appendingPathComponent(contact.name).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data,
                let _ = String(data: data, encoding: .utf8)
                else { completion(); return }
            
            
            if let error = error {
                print("Error updating user data: \(error)")
                completion()
                return
            } else {
                //print(responseDataString)
                completion()
            }
            
            guard let index = self.contacts.index(of: contact) else { return }
            self.contacts.remove(at: index)
            
            completion()
        }
        dataTask.resume()
    }
    
    func fetchContacts(completion: @escaping() -> Void) {
        guard let baseUrl = baseURL else { completion(); return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("contacts").appendingPathExtension("json")
        
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
                let _ = String(data: data, encoding: .utf8) else { completion(); return }
            //print(responseDataString)
            
            guard let contactsDictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { completion(); return }
            
            //guard let someInfo = contactsDictionary["contact"] as? [String: Any] else { return }
            //print(someInfo)
            
            for value in contactsDictionary.values {
                guard let dictionary = value as? [String: Any],
                    let contact = Contact(jsonDictionary: dictionary)
                    else { return }
                self.contacts.append(contact)
            }
            
            completion()
        }
        dataTask.resume()
    }
    
    func addEvent(withName name: String, startTime: String, endTime: String, date: String, contacts: [String: Bool], details: String, completion: @escaping() -> Void) {
        let event = Event(startTime: startTime, endTime: endTime, date: date, contacts: contacts, name: name, details: details)
        
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("events").appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = event.jsonData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data,
                let _ = String(data: data, encoding: .utf8)
                else { completion(); return }
            
            
            if let error = error {
                print("Error updating user data: \(error)")
                completion()
                return
            } else {
                //print(responseDataString)
                completion()
            }
            
            self.events.append(event)
            
            completion()
        }
        dataTask.resume()
    }
    
    func deleteEvent(event: Event, completion: @escaping() -> Void) {
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("events").appendingPathComponent(event.name).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data,
                let _ = String(data: data, encoding: .utf8)
                else { completion(); return }
            
            
            if let error = error {
                print("Error updating user data: \(error)")
                completion()
                return
            } else {
                //print(responseDataString)
                completion()
            }
            
            guard let index = self.events.index(of: event) else { return }
            self.events.remove(at: index)
            
            completion()
        }
        dataTask.resume()
    }
}

    













