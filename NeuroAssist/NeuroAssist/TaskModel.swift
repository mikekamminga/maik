import SwiftUI
import Foundation

struct TaskModel: Identifiable {
    let id: UUID
    var title: String
    var dueDate: Date?
    var priority: Priority
    var tags: [String]
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?
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
    
    init(id: UUID = UUID(), title: String, dueDate: Date? = nil, priority: Priority = .medium, tags: [String] = [], isCompleted: Bool = false, createdAt: Date = Date(), completedAt: Date? = nil, notes: String? = nil) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.tags = tags
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.completedAt = completedAt
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