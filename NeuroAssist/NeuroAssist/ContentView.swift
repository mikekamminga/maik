//
//  ContentView.swift
//  NeuroAssist
//
//  Created by Mike Kamminga on 29/05/2025.
//

import SwiftUI

// Sample tasks for demo - defined inline to avoid build issues
let sampleTasks = [
    TaskModel(
        title: "Call doctor for appointment",
        dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
        priority: .high,
        tags: ["health", "phone"],
        notes: "Need to schedule annual checkup"
    ),
    TaskModel(
        title: "Buy groceries",
        dueDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
        priority: .medium,
        tags: ["shopping", "food"],
        notes: "Milk, bread, eggs"
    ),
    TaskModel(
        title: "Finish project presentation",
        dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()), // Overdue
        priority: .urgent,
        tags: ["work", "deadline"],
        notes: "Final slides for client meeting"
    ),
    TaskModel(
        title: "Read book chapter",
        priority: .low,
        tags: ["personal", "learning"]
    ),
    TaskModel(
        title: "Exercise",
        dueDate: Date(),
        priority: .medium,
        tags: ["health", "daily"]
    )
]

struct TaskModel: Identifiable {
    let id = UUID()
    var title: String
    var dueDate: Date?
    var priority: Priority
    var tags: [String]
    var isCompleted = false
    var notes: String?
    
    enum Priority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case urgent = "Urgent"
        
        var color: Color {
            switch self {
            case .urgent: return .red
            case .high: return .orange
            case .medium: return .blue
            case .low: return .gray
            }
        }
        
        var icon: String {
            switch self {
            case .urgent: return "exclamationmark.triangle.fill"
            case .high: return "exclamationmark.circle.fill"
            case .medium: return "circle.fill"
            case .low: return "circle"
            }
        }
    }
    
    init(title: String, dueDate: Date? = nil, priority: Priority = .medium, tags: [String] = [], notes: String? = nil) {
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.tags = tags
        self.notes = notes
    }
    
    var isOverdue: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        return dueDate < Date()
    }
    
    var isDueToday: Bool {
        guard let dueDate = dueDate else { return false }
        return Calendar.current.isDateInToday(dueDate)
    }
    
    var displayStatus: String {
        if isCompleted {
            return "✅ Complete"
        } else if isOverdue {
            return "⚠️ Overdue"
        } else if isDueToday {
            return "📅 Due Today"
        } else {
            return ""
        }
    }
    
    var dueDateDisplayText: String? {
        guard let dueDate = dueDate else { return nil }
        
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(dueDate) {
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return "Today at \(formatter.string(from: dueDate))"
        } else if Calendar.current.isDateInTomorrow(dueDate) {
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return "Tomorrow at \(formatter.string(from: dueDate))"
        } else {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: dueDate)
        }
    }
    
    var detectedCategories: [String] {
        let allText = "\(title) \(tags.joined(separator: " "))".lowercased()
        var categories: [String] = []
        
        let categoryKeywords: [String: [String]] = [
            "Work": ["work", "job", "meeting", "project", "deadline", "office"],
            "Health": ["doctor", "appointment", "medicine", "exercise", "gym"],
            "Shopping": ["buy", "purchase", "store", "grocery", "milk", "bread"],
            "Personal": ["family", "friend", "birthday", "home", "clean"],
            "Learning": ["read", "study", "course", "book", "research", "learn"]
        ]
        
        for (category, keywords) in categoryKeywords {
            if keywords.contains(where: allText.contains) {
                categories.append(category)
            }
        }
        
        return Array(Set(categories))
    }
}

struct ContentView: View {
    @State private var tasks = sampleTasks
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // NeuroAssist Header
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("NeuroAssist")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Your AI-powered personal assistant")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // Task Model Demo Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Task Model Demo")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(tasks) { task in
                                TaskRowView(task: task)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Status Badge
                Text("Issue #003: Task Model Complete ✅")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.green.opacity(0.1))
                            .stroke(.green, lineWidth: 1)
                    )
                    .padding(.horizontal)
            }
            .navigationTitle("NeuroAssist")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TaskRowView: View {
    let task: TaskModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Priority Indicator
            Circle()
                .fill(task.priority.color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                // Task Title
                Text(task.title)
                    .font(.headline)
                    .lineLimit(2)
                
                // Status and Due Date
                HStack {
                    if !task.displayStatus.isEmpty {
                        Text(task.displayStatus)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(statusBackgroundColor)
                            )
                    }
                    
                    if let dueDateText = task.dueDateDisplayText {
                        Text(dueDateText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Tags
                if !task.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(task.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(.blue.opacity(0.1))
                                    )
                            }
                        }
                    }
                }
                
                // Categories (if detected)
                if !task.detectedCategories.isEmpty {
                    Text("Categories: \(task.detectedCategories.joined(separator: ", "))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            
            Spacer()
            
            // Priority Icon
            Image(systemName: task.priority.icon)
                .foregroundColor(task.priority.color)
                .font(.title3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
    
    private var statusBackgroundColor: Color {
        if task.displayStatus.contains("Complete") {
            return .green.opacity(0.2)
        } else if task.displayStatus.contains("Overdue") {
            return .red.opacity(0.2)
        } else if task.displayStatus.contains("Due Today") {
            return .orange.opacity(0.2)
        } else {
            return .blue.opacity(0.2)
        }
    }
}

#Preview {
    ContentView()
}
