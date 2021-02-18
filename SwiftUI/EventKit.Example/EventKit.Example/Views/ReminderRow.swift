//
//  ReminderRow.swift
//  EventKit.Example
//
//  Created by Jess Chandler on 210217.
//  Copyright © 2021 Filip Němeček. All rights reserved.
//

import SwiftUI
import EventKit

struct ReminderRow: View {
    let reminder: EKReminder
    
    private static var relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter
    }()
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    var body: some View {
        HStack {
            Circle()
                .fill(reminder.calendar.color)
                .frame(width: 10, height: 10, alignment: .center)
                
            
            VStack(alignment: .leading) {
                Text(ReminderRow.relativeDateFormatter.localizedString(for: (reminder.dueDateComponents?.date ?? Date()), relativeTo: Date()).uppercased())
                    .modifier(SecondaryCaptionTextStyle())
                    .padding(.bottom, 2)
                Text(reminder.title)
                    .font(.headline)
            }
            
            Spacer()
            
            VStack {
                Spacer()
                Text(reminder.isCompleted ? "complete" : "due")
                    .modifier(SecondaryCaptionTextStyle())
            }
        }.padding(.vertical, 5)
    }
}

