# Issue #011: Define add task intent

**Labels:** `phase-2` `siri` `app-intents` `nlp` `priority-high`

## Description

Define comprehensive intent definitions for adding tasks through Siri, including parameter handling, natural language processing, and response generation. This builds upon the App Intents extension to provide robust voice-driven task creation.

## Background

The intent definition is the core of Siri integration, determining how natural language is parsed into structured task data. For ADHD users, the intent must handle varied, spontaneous speech patterns while extracting meaningful task information.

## Acceptance Criteria

- [ ] `AddTaskIntent` is fully defined with all supported parameters
- [ ] Intent handles various natural language patterns for task creation
- [ ] Priority extraction from speech works reliably (e.g., "urgent task")
- [ ] Date parsing supports relative dates (today, tomorrow, next week)
- [ ] Intent provides helpful prompts for missing required information
- [ ] Response messages are natural and encouraging
- [ ] Intent supports batch task creation (multiple tasks in one command)
- [ ] Error messages guide users toward successful completion
- [ ] Intent appears correctly in Siri suggestions and Shortcuts app

## Implementation Guidance

### Using Cursor
- Use Cursor to generate comprehensive intent definitions
- Ask Cursor to create natural language processing for parameter extraction
- Use Cursor to implement proper response handling and user feedback

### Technical Implementation
```swift
import AppIntents

struct AddTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Task"
    static var description = IntentDescription("Add a new task to NeuroAssist", categoryName: "Productivity")
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$taskTitle) task") {
            \.$priority
            \.$dueDate
            \.$tags
        }
    }
    
    @Parameter(title: "Task Title", description: "What needs to be done")
    var taskTitle: String
    
    @Parameter(title: "Priority", description: "How important is this task", default: .medium)
    var priority: TaskPriority
    
    @Parameter(title: "Due Date", description: "When should this be completed")
    var dueDate: Date?
    
    @Parameter(title: "Tags", description: "Categories or labels for this task")
    var tags: [String]?
    
    @Parameter(title: "Notes", description: "Additional details about the task")
    var notes: String?
    
    static var openAppWhenRun: Bool = false
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        // Validate input
        guard !taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw $taskTitle.needsValueError("What task would you like to add?")
        }
        
        // Create task
        let task = Task(
            title: taskTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: dueDate,
            priority: priority,
            tags: tags ?? [],
            notes: notes
        )
        
        // Save to repository
        await TaskRepository.shared.addTask(task)
        
        // Generate response
        let dialog = generateResponseDialog(for: task)
        
        return .result(dialog: dialog) {
            TaskSnippetView(task: task)
        }
    }
    
    private func generateResponseDialog(for task: Task) -> IntentDialog {
        var message = "Added task: \(task.title)"
        
        if let dueDate = task.dueDate {
            let formatter = RelativeDateTimeFormatter()
            message += " due \(formatter.localizedString(for: dueDate, relativeTo: Date()))"
        }
        
        if task.priority == .high || task.priority == .urgent {
            message += " with \(task.priority.rawValue.lowercased()) priority"
        }
        
        return IntentDialog(message)
    }
}

enum TaskPriority: String, AppEnum, CaseIterable {
    case low = "Low"
    case medium = "Medium"  
    case high = "High"
    case urgent = "Urgent"
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Priority")
    static var caseDisplayRepresentations: [TaskPriority: DisplayRepresentation] = [
        .low: "Low Priority",
        .medium: "Medium Priority",
        .high: "High Priority",
        .urgent: "Urgent"
    ]
}

struct TaskSnippetView: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
                Text("Task Added")
                    .font(.headline)
                Spacer()
            }
            
            Text(task.title)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            if let dueDate = task.dueDate {
                Label(dueDate.formatted(date: .abbreviated, time: .shortened), 
                      systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if task.priority != .medium {
                Label(task.priority.rawValue, systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundColor(priorityColor)
            }
        }
        .padding()
    }
    
    private var priorityColor: Color {
        switch task.priority {
        case .urgent: return .red
        case .high: return .orange
        case .low: return .blue
        case .medium: return .secondary
        }
    }
}
```

### Natural Language Patterns
The intent should recognize these common patterns:
- "Add task to buy milk"
- "Remind me to call Mom tomorrow"
- "Create high priority task to finish report"
- "Add urgent task to pick up prescription by 5 PM"
- "New task: water plants with tag home"

### Advanced Features
```swift
// Support for batch task creation
struct AddMultipleTasksIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Multiple Tasks"
    
    @Parameter(title: "Task List")
    var taskList: String
    
    func perform() async throws -> some IntentResult {
        let tasks = parseTaskList(taskList)
        
        for taskTitle in tasks {
            let task = Task(title: taskTitle)
            await TaskRepository.shared.addTask(task)
        }
        
        return .result(dialog: "Added \(tasks.count) tasks")
    }
    
    private func parseTaskList(_ input: String) -> [String] {
        // Parse comma-separated or bullet-pointed lists
        return input.components(separatedBy: .newlines)
            .flatMap { $0.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
```

### Error Handling
- Handle ambiguous dates gracefully
- Provide suggestions for unrecognized priorities
- Guide users when required information is missing
- Offer alternatives when intents fail

## Definition of Done

- Intent definitions compile and work correctly
- Siri recognizes all supported natural language patterns
- Parameter extraction is accurate and robust
- Response messages are helpful and natural
- Intent appears in Shortcuts app with proper descriptions
- Error handling guides users effectively
- Performance is fast enough for real-time interaction

## Related Issues

- Depends on: #010 - Add App Intents extension for Siri integration
- Next: #012 - Implement intent handling
- Enhances: #007 - Add voice input for task creation on iPhone
- Prepares for: #013 - Use NLP for task categorization

## Estimated Effort

**Time:** 2-3 hours  
**Complexity:** Medium  
**Prerequisites:** App Intents framework, natural language processing concepts 