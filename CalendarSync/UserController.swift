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
    var mockUser = User()
    var contacts: [Contact] = []
    var events: [Event] = []
    var pendingEvents: [Event] = []
    var contactEvents: [Event] = []
    let formatter = DateFormatter()
    
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
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("contacts").appendingPathComponent(contact.contactNumber).appendingPathExtension("json")
        
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
    
    func fetchContactEvents(contact: Contact, date: Date, completion: @escaping() -> Void) {
        guard let baseUrl = baseURL else { completion(); return }
        formatter.dateFormat = "MMMM dd yyyy"
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(contact.contactNumber).appendingPathComponent("events").appendingPathComponent(formatter.string(from: date)).appendingPathExtension("json")
        
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
            
            guard let eventsDictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { completion(); return }
            
            
            for value in eventsDictionary.values {
                guard let dictionary = value as? [String: Any],
                    let event = Event(jsonDictionary: dictionary)
                    else { return }
                self.contactEvents.append(event)
            }
            completion()
        }
        dataTask.resume()
    }
    
    func fetchEvents(date: Date, completion: @escaping() -> Void) {
        guard let baseUrl = baseURL else { completion(); return }
        formatter.dateFormat = "MMMM dd yyyy"
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("events").appendingPathComponent(formatter.string(from: date)).appendingPathExtension("json")
        
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
            
            guard let eventsDictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { completion(); return }
            
            var eventList: [Event] = []
            
            for value in eventsDictionary.values {
                guard let dictionary = value as? [String: Any],
                    let event = Event(jsonDictionary: dictionary)
                    else { completion(); return }
                eventList.append(event)
            }
            self.events = eventList
            completion()
        }
        dataTask.resume()
    }
    
    func fetchPendingEvents(completion: @escaping() -> Void) {
        guard let baseUrl = baseURL else { completion(); return }
        formatter.dateFormat = "MMMM dd yyyy"
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("pendingEvents").appendingPathExtension("json")
        
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
            
            guard let eventsDictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { completion(); return }
            
            var eventList: [Event] = []
            
            for value in eventsDictionary.values {
                guard let dictionary = value as? [String: Any],
                    let event = Event(jsonDictionary: dictionary)
                    else { return }
                eventList.append(event)
            }
            self.pendingEvents = eventList
            completion()
        }
        dataTask.resume()
    }
    
    func addEvent(withName name: String, startTime: String, endTime: String, date: String, contacts: [String: [String: String]], details: String, creator: String, completion: @escaping() -> Void) {
        
        let event = Event(startTime: startTime, endTime: endTime, date: date, contacts: contacts, name: name, details: details, creator: creator)
        
        if event.endTime[5] == "a" && event.startTime[5] == "p" {
            guard let day = formatter.date(from: date) else { return }
            let nextDay = Date(timeInterval: 86400, since: day)
            let nextDayString = formatter.string(from: nextDay)
            addEvent(withName: name, startTime: "12:00 am", endTime: endTime, date: nextDayString, contacts: contacts, details: details, creator: creator, completion: {})
            event.endTime = "11:00 pm"
        }
        
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("events").appendingPathComponent(event.date).appendingPathExtension("json")
        
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
            guard let contactDictionary = event.contacts["info"] else { return }
            for value in contactDictionary {
                self.requestEvent(event: event, contactNumber: value.key, completion: {})
            }
            
            completion()
        }
        dataTask.resume()
    }
    
    func addPendingEvent(event: Event, completion: @escaping() -> Void) {
        
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("events").appendingPathComponent(event.date).appendingPathExtension("json")
        
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
            self.deletePendingEvent(event: event, completion: {})
            
            completion()
        }
        dataTask.resume()
    }
    
    func requestEvent(event: Event, contactNumber: String, completion: @escaping() -> Void) {

        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(contactNumber).appendingPathComponent("pendingEvents").appendingPathExtension("json")
        
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
            
            completion()
        }
        dataTask.resume()
    }
    
    func deleteEvent(event: Event, completion: @escaping() -> Void) {
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("events").appendingPathComponent(event.date).appendingPathComponent(event.name).appendingPathExtension("json")
        
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
            
            guard let index = self.events.index(of: event) else { completion(); return }
            self.events.remove(at: index)
            
            completion()
        }
        dataTask.resume()
    }
    
    func deletePendingEvent(event: Event, completion: @escaping() -> Void) {
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(user.phoneNumber).appendingPathComponent("pendingEvents").appendingPathComponent(event.name).appendingPathExtension("json")
        
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
            
            guard let index = self.pendingEvents.index(of: event) else { return }
            self.pendingEvents.remove(at: index)
            
            completion()
        }
        dataTask.resume()
    }
    
    func fetchNumber(withID userID: String, completion: @escaping(_ success: Bool) -> Void) {
        
        guard let baseUrl = baseURL else { return }
        let url = baseUrl.appendingPathComponent("users").appendingPathComponent(userID).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error getting data for user: \(error)")
                completion(false)
                return
            }
            
            guard let data = data,
                let _ = String(data: data, encoding: .utf8) else {completion(false); return }
            
            guard let userDictionary = (try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])) as? [String: Any] else { completion(false); return }
            
            guard let user = User(jsonDictionary: userDictionary, phoneNumber: userID) else { completion(false); return }
            self.mockUser = user
            
            completion(true)
        }
        dataTask.resume()
    }
}

    













