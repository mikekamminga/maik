# Issue #004: Implement task storage

**Labels:** `phase-1` `data-persistence` `core-data` `priority-high`

## Description

Implement persistent storage for tasks using Core Data or UserDefaults to ensure tasks are saved across app launches and synced between iPhone and Apple Watch. This is critical infrastructure for all task management functionality.

## Background

Reliable data persistence is essential for NeuroAssist users who rely on the app to remember their captured thoughts. The storage system must be robust, efficient, and support synchronization across devices.

## Acceptance Criteria

- [ ] Storage system is implemented (Core Data recommended for complex queries)
- [ ] Tasks persist across app launches
- [ ] CRUD operations work correctly (Create, Read, Update, Delete)
- [ ] Data model supports all Task properties from Issue #003
- [ ] Storage is optimized for quick writes (important for ADHD quick capture)
- [ ] Data can be queried efficiently for list views
- [ ] Storage supports offline operation
- [ ] Data is prepared for Watch synchronization
- [ ] Proper error handling for storage failures

## Implementation Guidance

### Using Cursor
- Use Cursor to generate Core Data stack setup
- Ask Cursor to create repository pattern for clean data access
- Use Cursor to implement proper error handling and logging

### Technical Approach
```swift
import CoreData

class TaskRepository: ObservableObject {
    @Published var tasks: [Task] = []
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TaskModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data error: \(error)")
            }
        }
        fetchTasks()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
    
    func addTask(_ task: Task) {
        // Implementation
    }
    
    func updateTask(_ task: Task) {
        // Implementation
    }
    
    func deleteTask(_ task: Task) {
        // Implementation
    }
    
    func fetchTasks() {
        // Implementation
    }
}
```

### Storage Requirements
1. **Quick Write Performance**: Optimized for rapid task capture
2. **Efficient Queries**: Support filtering by completion, priority, due date
3. **Data Integrity**: Consistent state across all operations
4. **Migration Support**: Handle future schema changes
5. **Memory Efficiency**: Appropriate for mobile devices

### Testing Requirements
- Test large numbers of tasks (1000+)
- Test concurrent access scenarios
- Test storage during low memory conditions
- Test data recovery after crashes
- Test migration scenarios

## Definition of Done

- All CRUD operations work reliably
- Performance is acceptable for expected task volumes
- Data persists correctly across app restarts
- Code is well-documented and follows best practices
- Unit tests cover all major functionality
- Integration with Task model is seamless

## Related Issues

- Depends on: #003 - Define Task model in Swift
- Next: #005 - Create task list view for iPhone
- Enables: #009 - Implement data syncing between iPhone and Apple Watch

## Estimated Effort

**Time:** 3-4 hours  
**Complexity:** Medium  
**Prerequisites:** Understanding of Core Data or UserDefaults, data persistence patterns 