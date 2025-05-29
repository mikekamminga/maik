import Foundation
import SwiftUI

/// Core data model representing a task in NeuroAssist
/// 
/// Designed specifically for neurodiverse users who need flexible task capture
/// with minimal friction and intelligent organization capabilities.
struct Task: Identifiable, Codable, Equatable {
    
    // MARK: - Core Properties
    
    /// Unique identifier for the task
    let id: UUID
    
    /// The main task description (required)
    var title: String
    
    /// Optional due date for the task
    var dueDate: Date?
    
    /// Priority level for organization and display
    var priority: Priority
    
    /// Flexible tags for categorization
    var tags: [String]
    
    /// Whether the task has been completed
    var isCompleted: Bool
    
    /// When the task was created
    let createdAt: Date
    
    /// When the task was marked complete (if applicable)
    var completedAt: Date?
    
    /// Optional additional notes or details
    var notes: String?
    
    // MARK: - Priority Enum
    
    /// Priority levels optimized for ADHD task management
    enum Priority: String, Codable, CaseIterable, Comparable {
        case low = "Low"
        case medium = "Medium" 
        case high = "High"
        case urgent = "Urgent"
        
        /// Display order for sorting (urgent first)
        var sortOrder: Int {
            switch self {
            case .urgent: return 0
            case .high: return 1
            case .medium: return 2
            case .low: return 3
            }
        }
        
        /// Color representation for UI display
        var color: Color {
            switch self {
            case .urgent: return .red
            case .high: return .orange
            case .medium: return .blue
            case .low: return .gray
            }
        }
        
        /// Icon representation for quick visual recognition
        var icon: String {
            switch self {
            case .urgent: return "exclamationmark.triangle.fill"
            case .high: return "exclamationmark.circle.fill"
            case .medium: return "circle.fill"
            case .low: return "circle"
            }
        }
        
        static func < (lhs: Priority, rhs: Priority) -> Bool {
            return lhs.sortOrder < rhs.sortOrder
        }
    }
    
    // MARK: - Initializers
    
    /// Create a new task with minimal required information
    /// 
    /// - Parameters:
    ///   - title: The task description
    ///   - dueDate: Optional due date
    ///   - priority: Priority level (defaults to medium)
    ///   - tags: Optional tags for categorization
    ///   - notes: Optional additional details
    init(
        title: String,
        dueDate: Date? = nil,
        priority: Priority = .medium,
        tags: [String] = [],
        notes: String? = nil
    ) {
        self.id = UUID()
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.dueDate = dueDate
        self.priority = priority
        self.tags = tags
        self.isCompleted = false
        self.createdAt = Date()
        self.completedAt = nil
        self.notes = notes
    }
    
    // MARK: - Computed Properties
    
    /// Whether the task is overdue (has a due date that has passed)
    var isOverdue: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        return dueDate < Date()
    }
    
    /// Whether the task is due today
    var isDueToday: Bool {
        guard let dueDate = dueDate else { return false }
        return Calendar.current.isDateInToday(dueDate)
    }
    
    /// Whether the task is due this week
    var isDueThisWeek: Bool {
        guard let dueDate = dueDate else { return false }
        let weekFromNow = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
        return dueDate <= weekFromNow && dueDate >= Date()
    }
    
    /// Display text for due date with smart formatting
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
        } else if isDueThisWeek {
            formatter.dateFormat = "EEEE 'at' h:mm a"
            return formatter.string(from: dueDate)
        } else {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: dueDate)
        }
    }
    
    /// Smart status for display in UI
    var displayStatus: String {
        if isCompleted {
            return "✅ Complete"
        } else if isOverdue {
            return "⚠️ Overdue"
        } else if isDueToday {
            return "📅 Due Today"
        } else if isDueThisWeek {
            return "📆 Due This Week"
        } else {
            return ""
        }
    }
    
    /// Whether this task should be prominently displayed (high priority or due soon)
    var isProminent: Bool {
        return priority == .urgent || priority == .high || isDueToday || isOverdue
    }
    
    /// Categories detected from title and tags using simple keyword matching
    var detectedCategories: [String] {
        let allText = "\(title) \(tags.joined(separator: " "))".lowercased()
        var categories: [String] = []
        
        // Common ADHD-friendly categories
        let categoryKeywords: [String: [String]] = [
            "Work": ["work", "job", "meeting", "project", "deadline", "office", "email", "call"],
            "Health": ["doctor", "appointment", "medicine", "exercise", "gym", "dentist", "therapy"],
            "Shopping": ["buy", "purchase", "store", "grocery", "milk", "bread", "food", "get"],
            "Personal": ["family", "friend", "birthday", "home", "clean", "organize"],
            "Errands": ["bank", "post office", "dmv", "pickup", "drop off", "return"],
            "Learning": ["read", "study", "course", "book", "research", "learn", "practice"]
        ]
        
        for (category, keywords) in categoryKeywords {
            if keywords.contains(where: allText.contains) {
                categories.append(category)
            }
        }
        
        return Array(Set(categories)) // Remove duplicates
    }
}

// MARK: - Task Extensions

extension Task {
    
    /// Mark the task as completed
    mutating func complete() {
        isCompleted = true
        completedAt = Date()
    }
    
    /// Mark the task as incomplete
    mutating func uncomplete() {
        isCompleted = false
        completedAt = nil
    }
    
    /// Toggle completion status
    mutating func toggleCompletion() {
        if isCompleted {
            uncomplete()
        } else {
            complete()
        }
    }
    
    /// Add a tag if it doesn't already exist
    mutating func addTag(_ tag: String) {
        let trimmedTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
        }
    }
    
    /// Remove a tag if it exists
    mutating func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    /// Update the task's priority with smart suggestions based on keywords
    mutating func updatePriorityFromContent() {
        let titleLowercase = title.lowercased()
        
        if titleLowercase.contains("urgent") || titleLowercase.contains("asap") || titleLowercase.contains("emergency") {
            priority = .urgent
        } else if titleLowercase.contains("important") || titleLowercase.contains("deadline") || titleLowercase.contains("must") {
            priority = .high
        } else if titleLowercase.contains("maybe") || titleLowercase.contains("sometime") || titleLowercase.contains("eventually") {
            priority = .low
        }
        // Keep existing priority if no keywords detected
    }
}

// MARK: - Sample Data for Development

extension Task {
    
    /// Sample tasks for development and testing
    static let sampleTasks: [Task] = [
        Task(
            title: "Call doctor for appointment",
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            priority: .high,
            tags: ["health", "phone"],
            notes: "Need to schedule annual checkup"
        ),
        Task(
            title: "Buy groceries",
            dueDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
            priority: .medium,
            tags: ["shopping", "food"],
            notes: "Milk, bread, eggs"
        ),
        Task(
            title: "Finish project presentation",
            dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()), // Overdue
            priority: .urgent,
            tags: ["work", "deadline"],
            notes: "Final slides for client meeting"
        ),
        Task(
            title: "Read book chapter",
            priority: .low,
            tags: ["personal", "learning"]
        ),
        Task(
            title: "Exercise",
            dueDate: Date(),
            priority: .medium,
            tags: ["health", "daily"]
        )
    ]
} 