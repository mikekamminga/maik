# Issue #013: Use NLP for task categorization

**Labels:** `phase-2` `nlp` `ai` `categorization` `priority-medium`

## Description

Implement natural language processing to automatically categorize and tag tasks based on their content. This reduces manual organization burden for ADHD users by intelligently sorting tasks into meaningful categories.

## Background

ADHD users often struggle with organizing and categorizing information manually. Automatic categorization using NLP helps create structure without requiring additional mental effort, making tasks easier to find and manage.

## Acceptance Criteria

- [ ] NLP framework analyzes task titles and extracts meaningful categories
- [ ] Common categories are detected (Shopping, Work, Personal, Health, etc.)
- [ ] Priority levels are inferred from task language (urgent, important, etc.)
- [ ] Tags are automatically suggested based on content analysis
- [ ] Location information is extracted when present (grocery store, office)
- [ ] Time-sensitive language is recognized (today, tomorrow, deadline)
- [ ] User can accept/reject automatic categorizations
- [ ] System learns from user corrections to improve accuracy
- [ ] Performance is fast enough for real-time categorization

## Implementation Guidance

### Using Cursor
- Use Cursor to implement Apple's Natural Language framework integration
- Ask Cursor to create custom text analysis and category mapping
- Use Cursor to build user feedback loops for improved accuracy

### Technical Implementation
```swift
import NaturalLanguage

class TaskCategorizer {
    static let shared = TaskCategorizer()
    
    private let tagger = NLTagger(tagSchemes: [.lexicalClass, .nameType])
    private let categoryKeywords: [String: [String]] = [
        "Shopping": ["buy", "purchase", "pick up", "store", "grocery", "milk", "bread", "food"],
        "Work": ["meeting", "project", "deadline", "report", "email", "call", "office"],
        "Health": ["doctor", "appointment", "medicine", "exercise", "gym", "dentist"],
        "Personal": ["call", "text", "birthday", "family", "friend", "home"],
        "Errands": ["bank", "post office", "DMV", "appointment", "pickup"],
        "Maintenance": ["fix", "repair", "clean", "organize", "maintenance"]
    ]
    
    private let priorityKeywords: [Task.Priority: [String]] = [
        .urgent: ["urgent", "asap", "immediately", "emergency", "critical"],
        .high: ["important", "soon", "priority", "deadline", "must"],
        .low: ["maybe", "sometime", "when possible", "eventually"]
    ]
    
    func categorizeTask(_ task: Task) -> EnhancedTask {
        let analysis = analyzeText(task.title)
        
        return EnhancedTask(
            originalTask: task,
            detectedCategories: analysis.categories,
            suggestedTags: analysis.tags,
            inferredPriority: analysis.priority,
            extractedLocation: analysis.location,
            timeContext: analysis.timeContext
        )
    }
    
    private func analyzeText(_ text: String) -> TaskAnalysis {
        tagger.string = text.lowercased()
        
        var categories: [String] = []
        var tags: [String] = []
        var inferredPriority: Task.Priority? = nil
        var location: String? = nil
        var timeContext: TimeContext? = nil
        
        // Analyze for categories
        categories = detectCategories(in: text)
        
        // Analyze for priority indicators
        inferredPriority = detectPriority(in: text)
        
        // Extract locations
        location = extractLocation(from: text)
        
        // Detect time context
        timeContext = detectTimeContext(in: text)
        
        // Generate tags from categories and context
        tags = generateTags(from: categories, location: location, timeContext: timeContext)
        
        return TaskAnalysis(
            categories: categories,
            tags: tags,
            priority: inferredPriority,
            location: location,
            timeContext: timeContext
        )
    }
    
    private func detectCategories(in text: String) -> [String] {
        var detectedCategories: [String] = []
        
        for (category, keywords) in categoryKeywords {
            let score = keywords.reduce(0) { sum, keyword in
                return sum + (text.contains(keyword) ? 1 : 0)
            }
            
            if score > 0 {
                detectedCategories.append(category)
            }
        }
        
        return detectedCategories
    }
    
    private func detectPriority(in text: String) -> Task.Priority? {
        for (priority, keywords) in priorityKeywords {
            for keyword in keywords {
                if text.contains(keyword) {
                    return priority
                }
            }
        }
        return nil
    }
    
    private func extractLocation(from text: String) -> String? {
        tagger.string = text
        let range = text.startIndex..<text.endIndex
        
        var detectedLocation: String? = nil
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType) { tag, tokenRange in
            if let tag = tag, tag == .placeName {
                detectedLocation = String(text[tokenRange])
                return false // Stop after first location
            }
            return true
        }
        
        return detectedLocation
    }
    
    private func detectTimeContext(in text: String) -> TimeContext? {
        let timeKeywords: [TimeContext: [String]] = [
            .today: ["today", "this afternoon", "tonight"],
            .tomorrow: ["tomorrow", "next day"],
            .thisWeek: ["this week", "by friday", "end of week"],
            .urgent: ["now", "asap", "immediately"]
        ]
        
        for (context, keywords) in timeKeywords {
            for keyword in keywords {
                if text.lowercased().contains(keyword) {
                    return context
                }
            }
        }
        
        return nil
    }
    
    private func generateTags(from categories: [String], location: String?, timeContext: TimeContext?) -> [String] {
        var tags = categories
        
        if let location = location {
            tags.append(location)
        }
        
        if let timeContext = timeContext {
            tags.append(timeContext.rawValue)
        }
        
        return Array(Set(tags)) // Remove duplicates
    }
}

struct TaskAnalysis {
    let categories: [String]
    let tags: [String]
    let priority: Task.Priority?
    let location: String?
    let timeContext: TimeContext?
}

struct EnhancedTask {
    let originalTask: Task
    let detectedCategories: [String]
    let suggestedTags: [String]
    let inferredPriority: Task.Priority?
    let extractedLocation: String?
    let timeContext: TimeContext?
    
    func applyEnhancements() -> Task {
        var enhanced = originalTask
        
        // Add suggested tags if they don't already exist
        let newTags = suggestedTags.filter { !enhanced.tags.contains($0) }
        enhanced.tags.append(contentsOf: newTags)
        
        // Update priority if none set and one was inferred
        if enhanced.priority == .medium, let inferredPriority = inferredPriority {
            enhanced.priority = inferredPriority
        }
        
        return enhanced
    }
}

enum TimeContext: String {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case thisWeek = "This Week"
    case urgent = "Urgent"
}

// User feedback for improving categorization
class CategorizationFeedback {
    static let shared = CategorizationFeedback()
    
    private var userCorrections: [String: [String]] = [:]
    
    func recordCorrection(taskText: String, actualCategory: String, suggestedCategory: String) {
        // Store user corrections to improve future categorization
        if userCorrections[taskText] == nil {
            userCorrections[taskText] = []
        }
        userCorrections[taskText]?.append("\(suggestedCategory) -> \(actualCategory)")
        
        // Update categorization weights based on feedback
        updateCategorizationWeights(taskText: taskText, correctCategory: actualCategory)
    }
    
    private func updateCategorizationWeights(taskText: String, correctCategory: String) {
        // Implement learning algorithm to improve categorization accuracy
        // This could use simple keyword weighting or more sophisticated ML
    }
}
```

### Integration with Task Creation
```swift
extension TaskRepository {
    func addTaskWithCategorization(_ task: Task) async {
        let enhancedTask = TaskCategorizer.shared.categorizeTask(task)
        let finalTask = enhancedTask.applyEnhancements()
        
        await addTask(finalTask)
        
        // Present categorization suggestions to user if needed
        if !enhancedTask.suggestedTags.isEmpty {
            await presentCategorizationSuggestions(enhancedTask)
        }
    }
    
    private func presentCategorizationSuggestions(_ enhancedTask: EnhancedTask) async {
        // Show UI to accept/reject suggestions
        // This improves the system through user feedback
    }
}
```

## Definition of Done

- NLP categorization works accurately for common task types
- Categories and tags are suggested appropriately
- Priority inference improves task organization
- User feedback system improves accuracy over time
- Performance is fast enough for real-time use
- Integration with task creation is seamless
- Code is well-tested with various task examples

## Related Issues

- Depends on: #012 - Implement intent handling
- Next: #014 - Set up notifications for reminders
- Enhances: #003 - Define Task model in Swift
- Connects to: #015 - Implement rule-based task prioritization

## Estimated Effort

**Time:** 5-6 hours  
**Complexity:** Medium-High  
**Prerequisites:** Natural Language framework, text analysis concepts 