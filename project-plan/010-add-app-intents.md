# Issue #010: Add App Intents extension for Siri integration

**Labels:** `phase-2` `siri` `app-intents` `accessibility` `priority-high`

## Description

Implement App Intents to enable Siri integration for hands-free task creation and management. This allows users to add tasks using voice commands like "Hey Siri, add a task to call Mom" without opening the app.

## Background

Siri integration is critical for ADHD users who need to capture thoughts immediately, especially when their hands are busy or when opening an app would interrupt their flow. App Intents provides the modern way to integrate with Siri and Shortcuts.

## Acceptance Criteria

- [ ] App Intents extension target is added to the project
- [ ] `AddTaskIntent` is defined with proper parameters
- [ ] Intent can accept task title via voice input
- [ ] Intent properly handles optional parameters (priority, due date)
- [ ] Siri responses are natural and helpful
- [ ] Intent integrates with existing task storage system
- [ ] Intent works from Lock Screen and Control Center
- [ ] Custom phrases are supported for task creation
- [ ] Error handling for failed intent execution

## Implementation Guidance

### Using Cursor
- Use Cursor to generate the App Intents extension setup
- Ask Cursor to create proper intent definitions and handlers
- Use Cursor to implement natural language processing for intent parameters

### Technical Implementation
```swift
import AppIntents

struct AddTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Task"
    static var description = IntentDescription("Add a new task to NeuroAssist")
    
    @Parameter(title: "Task Title")
    var taskTitle: String
    
    @Parameter(title: "Priority", default: .medium)
    var priority: TaskPriority
    
    @Parameter(title: "Due Date")
    var dueDate: Date?
    
    func perform() async throws -> some IntentResult {
        // Implementation
    }
}
```

### Intent Capabilities
1. **Add Task**: "Add task to buy milk"
2. **Set Priority**: "Add high priority task to call doctor"
3. **Set Due Date**: "Add task to submit report by Friday"
4. **Quick Capture**: "Remind me to water plants"

### Siri Phrase Examples
- "Add task [title]"
- "Remind me to [action]"
- "Create [priority] priority task [title]"
- "Add task [title] for [date]"

### Testing Scenarios
- Test various natural language inputs
- Test with different priority levels
- Test date parsing (today, tomorrow, specific dates)
- Test error handling for malformed requests
- Test from different interfaces (Lock Screen, Shortcuts app)

## Definition of Done

- App Intents extension builds and runs successfully
- Siri can successfully create tasks using voice commands
- Intent parameters are correctly parsed and applied
- Integration with main app's data storage works
- Siri provides helpful feedback for success/failure
- Intent appears in Shortcuts app for automation

## Related Issues

- Depends on: #009 - Implement data syncing between iPhone and Apple Watch
- Next: #011 - Define add task intent
- Enhances: #007 - Add voice input for task creation on iPhone
- Connects to: #013 - Use NLP for task categorization

## Estimated Effort

**Time:** 6-8 hours  
**Complexity:** High  
**Prerequisites:** Understanding of App Intents framework, Siri integration, voice interface design 