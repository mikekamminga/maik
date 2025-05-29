# Issue #003: Define Task model in Swift

**Labels:** `phase-1` `data-model` `swift` `priority-high`

## Description

Create a comprehensive `Task` data model that will serve as the foundation for all task management functionality in NeuroAssist. The model must support the unique needs of ADHD users including flexible categorization, priority levels, and completion tracking.

## Background

The Task model is the core data structure that represents user-generated tasks. It needs to support both quick capture (minimal required fields) and rich organization (optional metadata) to accommodate the varying needs of neurodiverse users.

## Acceptance Criteria

- [ ] `Task` struct is defined with all required properties
- [ ] Task conforms to `Identifiable` protocol for SwiftUI list management
- [ ] Task conforms to `Codable` protocol for data persistence
- [ ] Priority enum is properly defined with appropriate cases
- [ ] All properties have appropriate default values
- [ ] Task includes computed properties for display logic
- [ ] Unit tests are written to validate the model
- [ ] Documentation comments are added for all public properties

## Implementation Guidance

### Using Cursor
- Use Cursor to generate the complete Task struct with proper Swift conventions
- Ask Cursor to create comprehensive unit tests for the model
- Use Cursor to generate documentation comments

### Required Properties
```swift
struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var dueDate: Date?
    var priority: Priority
    var tags: [String]
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?
    var notes: String?
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case urgent = "Urgent"
    }
}
```

### Additional Features
- Computed property for `isOverdue`
- Computed property for `displayPriority` with colors
- Custom initializer with sensible defaults
- Extension methods for common operations
- Category detection from title text

### Testing Requirements
- Test task creation with minimal data
- Test task creation with full data
- Test priority ordering
- Test completion state changes
- Test date calculations

## Definition of Done

- Task model compiles without errors
- All properties are properly typed and documented
- Unit tests pass with good coverage
- Model can be instantiated and used in SwiftUI previews
- Code follows Swift style guidelines

## Related Issues

- Depends on: #002 - Initialize GitHub repository
- Next: #004 - Implement task storage
- Enables: #005 - Create task list view for iPhone

## Estimated Effort

**Time:** 2-3 hours  
**Complexity:** Medium  
**Prerequisites:** Basic Swift knowledge, understanding of protocols 