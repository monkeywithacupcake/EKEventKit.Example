//
//  MainView.swift
//  EventKit.Example
//
//  Created by Jess Chandler on 210217.
//  Copyright © 2021 Filip Němeček. All rights reserved.
//

import SwiftUI
import EventKit
import Combine

struct MainView: View {

    
    @ObservedObject var remindersRepository = RemindersRepository.shared
    
    @State private var selectedReminder: EKReminder?
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if remindersRepository.reminders?.isEmpty ?? true {
                        Text("No reminders available for this calendar selection")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    ForEach(remindersRepository.reminders ?? [], id: \.self) { reminder in
                        ReminderRow(reminder: reminder)
                        }
                    }
                }
                
              
            }
            .navigationBarTitle("EventKit Reminder Example")
            .navigationBarItems(trailing: Button(action: {

            }, label: {
                //Image(systemName: "plus").frame(width: 44, height: 44)
                Text("Add")
            }))
        }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
