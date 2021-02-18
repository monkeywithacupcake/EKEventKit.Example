//
//  RemindersRepository.swift
//  EventKit.Example
//
//  Created by Jess Chandler on 210216.
//

import Foundation
import EventKit
import SwiftUI
import Combine

typealias RAction = () -> ()

class RemindersRepository: ObservableObject {
    static let shared = RemindersRepository()
    
    private var subscribers: Set<AnyCancellable> = []
    
    let store = EKEventStore()
    
    @Published var remindersCalendars: Set<EKCalendar>?
    
    @Published var reminders: [EKReminder]?
    
    private init() {
        remindersCalendars = loadSelectedCalendars() ?? Set([store.defaultCalendarForNewReminders()].compactMap({ $0 }))
        
        $remindersCalendars.sink { [weak self] (calendars) in
            self?.saveSelectedCalendars(calendars)
            self?.loadAndUpdateReminders()
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: .eventsDidChange)
            .sink { [weak self] (notification) in
                self?.loadAndUpdateReminders()
                
            }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink { [weak self] (notification) in
                self?.loadAndUpdateReminders()
            }
            .store(in: &subscribers)
    }
    
    private func loadSelectedCalendars() -> Set<EKCalendar>? {
        //if let identifiers = UserDefaults.standard.stringArray(forKey: "RCalendarIdentifiers") {
            let calendars = store.calendars(for: .reminder)
        print("calendars")
        print(calendars)
            guard !calendars.isEmpty else { return nil }
            return Set(calendars)
        //} else {
            //return nil
        //}
    }
    
    private func saveSelectedCalendars(_ calendars: Set<EKCalendar>?) {
        if let identifiers = calendars?.compactMap({ $0.calendarIdentifier }) {
            UserDefaults.standard.set(identifiers, forKey: "RCalendarIdentifiers")
        }
    }
    
    private func loadAndUpdateReminders() {
        print("load and update")
        loadReminders(completion: { (reminders) in
            DispatchQueue.main.async {
                self.reminders = reminders
                print(reminders ?? [])
            }
        })
    }
    
    func requestAccess(onGranted: @escaping Action, onDenied: @escaping Action) {
        store.requestAccess(to: .reminder) { (granted, error) in
            if granted {
                onGranted()
            } else {
                onDenied()
            }
        }
    }

    func loadReminders(completion: @escaping (([EKReminder]?) -> Void)) {
        print("I am load")
        requestAccess(onGranted: {
                        print("I am granted")
            let predicate = self.store.predicateForReminders(in: nil)
            self.store.fetchReminders(matching: predicate, completion: {(_ reminders: [Any]?) -> Void in
                    for reminder: EKReminder? in reminders as? [EKReminder?] ?? [EKReminder?]() {
                        print("hi")
                        print(reminder!)
                    }
                })
            
            self.store.fetchReminders(matching: predicate, completion: {(reminders: [EKReminder]?) -> Void in
                completion(reminders)
            })
        }) {
            completion(nil)
        }
    }
    
    deinit {
        subscribers.forEach { (sub) in
            sub.cancel()
        }
    }
}
