# Issue #012: Implement intent handling

**Labels:** `phase-2` `siri` `integration` `error-handling` `priority-high`

## Description

Implement robust intent handling that processes Siri requests, integrates with the task storage system, handles errors gracefully, and provides meaningful feedback to users. This completes the Siri integration functionality.

## Background

Intent handling is where the magic happens - converting user voice commands into actual tasks in the app. For ADHD users, this must be bulletproof, fast, and provide clear confirmation that their thoughts have been captured.

## Acceptance Criteria

- [ ] Intent handler processes all supported intent types correctly
- [ ] Integration with TaskRepository is seamless and reliable
- [ ] Error handling covers all failure scenarios with helpful messages
- [ ] Response generation provides clear confirmation of actions taken
- [ ] Performance is fast enough for real-time Siri interaction
- [ ] Intent execution works from Lock Screen, Shortcuts, and Control Center
- [ ] Logging and analytics track intent success/failure rates
- [ ] Background execution handles app state transitions properly
- [ ] Intent responses include relevant visual snippets when appropriate

## Implementation Guidance

### Using Cursor
- Use Cursor to generate comprehensive intent handler implementations
- Ask Cursor to create robust error handling and recovery strategies
- Use Cursor to implement proper logging and analytics

### Technical Implementation
```swift
import AppIntents

struct NeuroAssistShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTaskIntent(),
            phrases: [
                "Add task in NeuroAssist",
                "Create task \(.applicationName)",
                "New task \(.applicationName)",
                "Remind me to \(\.$taskTitle) in \(.applicationName)"
            ]
        )
    }
}

// Enhanced intent handling with comprehensive error management
extension AddTaskIntent {
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        // Log intent execution
        IntentLogger.shared.logIntentStarted(type: "AddTask", parameters: [
            "hasTitle": !taskTitle.isEmpty,
            "hasDueDate": dueDate != nil,
            "priority": priority.rawValue
        ])
        
        do {
            // Validate and sanitize input
            let sanitizedTitle = validateAndSanitizeTitle(taskTitle)
            let validatedDueDate = try validateDueDate(dueDate)
            
            // Create task with enhanced metadata
            let task = Task(
                title: sanitizedTitle,
                dueDate: validatedDueDate,
                priority: priority,
                tags: processTags(tags),
                notes: notes,
                createdVia: .siri
            )
            
            // Save with retry logic
            try await saveTaskWithRetry(task)
            
            // Generate success response
            let dialog = generateSuccessDialog(for: task)
            
            // Log success
            IntentLogger.shared.logIntentCompleted(type: "AddTask", success: true)
            
            return .result(dialog: dialog) {
                TaskSnippetView(task: task)
            }
            
        } catch let error as TaskValidationError {
            IntentLogger.shared.logIntentCompleted(type: "AddTask", success: false, error: error)
            throw IntentError.invalidParameter(error.localizedDescription)
            
        } catch let error as StorageError {
            IntentLogger.shared.logIntentCompleted(type: "AddTask", success: false, error: error)
            throw IntentError.generic(error.localizedDescription)
            
        } catch {
            IntentLogger.shared.logIntentCompleted(type: "AddTask", success: false, error: error)
            throw IntentError.generic("Something went wrong. Please try again.")
        }
    }
    
    private func validateAndSanitizeTitle(_ title: String) throws -> String {
        let sanitized = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !sanitized.isEmpty else {
            throw TaskValidationError.emptyTitle
        }
        
        guard sanitized.count <= 200 else {
            throw TaskValidationError.titleTooLong
        }
        
        return sanitized
    }
    
    private func validateDueDate(_ date: Date?) throws -> Date? {
        guard let date = date else { return nil }
        
        // Reject dates too far in the past
        if date < Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date() {
            throw TaskValidationError.pastDueDate
        }
        
        return date
    }
    
    private func processTags(_ tags: [String]?) -> [String] {
        return tags?.compactMap { tag in
            let processed = tag.trimmingCharacters(in: .whitespacesAndNewlines)
            return processed.isEmpty ? nil : processed
        } ?? []
    }
    
    private func saveTaskWithRetry(_ task: Task) async throws {
        var retryCount = 0
        let maxRetries = 3
        
        while retryCount < maxRetries {
            do {
                await TaskRepository.shared.addTask(task)
                return
            } catch {
                retryCount += 1
                if retryCount >= maxRetries {
                    throw StorageError.saveFailed(underlying: error)
                }
                // Wait briefly before retry
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            }
        }
    }
    
    private func generateSuccessDialog(for task: Task) -> IntentDialog {
        var message = "Added task: \(task.title)"
        
        if let dueDate = task.dueDate {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            message += " due \(formatter.localizedString(for: dueDate, relativeTo: Date()))"
        }
        
        if task.priority == .high || task.priority == .urgent {
            message += " with \(task.priority.rawValue.lowercased()) priority"
        }
        
        // Add encouraging completion
        let encouragements = [
            "Got it!",
            "All set!",
            "Done!",
            "Perfect!",
            "Captured!"
        ]
        
        let encouragement = encouragements.randomElement() ?? "Done!"
        return IntentDialog("\(encouragement) \(message)")
    }
}

// Additional intent types
struct CompleteTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete Task"
    static var description = IntentDescription("Mark a task as completed")
    
    @Parameter(title: "Task", description: "Which task to complete")
    var task: TaskEntity
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        try await TaskRepository.shared.completeTask(withId: task.id)
        
        return .result(dialog: "Marked '\(task.title)' as complete. Great job! 🎉")
    }
}

struct GetTasksIntent: AppIntent {
    static var title: LocalizedStringResource = "Get My Tasks"
    static var description = IntentDescription("Show your current tasks")
    
    @Parameter(title: "Filter", description: "Show only specific types of tasks")
    var filter: TaskFilter?
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let tasks = await TaskRepository.shared.getTasks(filter: filter)
        
        let dialog: IntentDialog
        if tasks.isEmpty {
            dialog = IntentDialog("You're all caught up! No tasks found.")
        } else {
            let taskCount = tasks.count
            let completedCount = tasks.filter(\.isCompleted).count
            dialog = IntentDialog("You have \(taskCount) tasks, \(completedCount) completed.")
        }
        
        return .result(dialog: dialog) {
            TaskListSnippetView(tasks: tasks)
        }
    }
}

// Error types for better error handling
enum TaskValidationError: LocalizedError {
    case emptyTitle
    case titleTooLong
    case pastDueDate
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Please tell me what task you'd like to add."
        case .titleTooLong:
            return "Task title is too long. Please keep it under 200 characters."
        case .pastDueDate:
            return "Due date cannot be in the past. Please choose a future date."
        }
    }
}

enum StorageError: LocalizedError {
    case saveFailed(underlying: Error)
    case notFound
    case syncFailed
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save task. Please try again."
        case .notFound:
            return "Task not found."
        case .syncFailed:
            return "Failed to sync with other devices."
        }
    }
}

// Intent logging for analytics and debugging
class IntentLogger {
    static let shared = IntentLogger()
    
    func logIntentStarted(type: String, parameters: [String: Any] = [:]) {
        // Log to analytics service
        print("[Intent] Started: \(type) with parameters: \(parameters)")
    }
    
    func logIntentCompleted(type: String, success: Bool, error: Error? = nil) {
        if success {
            print("[Intent] Completed successfully: \(type)")
        } else {
            print("[Intent] Failed: \(type), error: \(error?.localizedDescription ?? "unknown")")
        }
    }
}
```

### Enhanced Error Handling Features
1. **Graceful Degradation**: Provide partial functionality when possible
2. **User Guidance**: Clear instructions on how to fix issues
3. **Retry Logic**: Automatic retry for transient failures
4. **Context Preservation**: Maintain user input during error recovery
5. **Analytics**: Track failure patterns for improvement

### Performance Optimizations
- **Background Processing**: Handle intents efficiently in background
- **Caching**: Cache common responses and data
- **Lazy Loading**: Load only necessary data for intent execution
- **Timeout Handling**: Graceful timeout management

## Definition of Done

- All intent types are handled correctly and reliably
- Error scenarios are covered with helpful user feedback
- Integration with app storage works seamlessly
- Performance meets real-time interaction requirements
- Intent responses are natural and encouraging
- Analytics and logging provide insight into usage patterns
- Code is well-tested and maintainable

## Related Issues

- Depends on: #011 - Define add task intent
- Next: #013 - Use NLP for task categorization
- Completes: Core Siri integration functionality
- Enables: #014 - Set up notifications for reminders

## Estimated Effort

**Time:** 4-5 hours  
**Complexity:** High  
**Prerequisites:** Advanced App Intents knowledge, error handling patterns, async programming 