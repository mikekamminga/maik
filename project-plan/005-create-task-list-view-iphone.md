# Issue #005: Create task list view for iPhone

**Labels:** `phase-1` `ui` `ios` `swiftui` `priority-high`

## Description

Build the main task list interface for iPhone using SwiftUI. This view will display all user tasks in an organized, ADHD-friendly layout that minimizes cognitive load while providing essential task information at a glance.

## Background

The task list is the primary interface users will interact with daily. For ADHD users, the design must be clean, non-overwhelming, and provide quick visual cues about task status, priority, and urgency without creating decision paralysis.

## Acceptance Criteria

- [ ] SwiftUI List view displays all tasks from storage
- [ ] Tasks show title, due date (if set), and priority indicator
- [ ] Completed tasks are visually distinct (strikethrough, dimmed)
- [ ] Tasks can be marked complete/incomplete with tap gesture
- [ ] List supports pull-to-refresh functionality
- [ ] Empty state is handled gracefully with helpful messaging
- [ ] List performance is smooth with 100+ tasks
- [ ] Accessibility features are properly implemented
- [ ] Visual design follows ADHD-friendly principles (clear, minimal)

## Implementation Guidance

### Using Cursor
- Use Cursor to generate SwiftUI List implementation
- Ask Cursor to create task row components with proper styling
- Use Cursor to implement accessibility features and VoiceOver support

### Technical Implementation
```swift
struct TaskListView: View {
    @StateObject private var taskRepository = TaskRepository()
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(taskRepository.tasks) { task in
                    TaskRowView(task: task) {
                        taskRepository.toggleCompletion(for: task)
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAddTask = true
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
            .refreshable {
                taskRepository.refresh()
            }
        }
    }
}

struct TaskRowView: View {
    let task: Task
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                if let dueDate = task.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundColor(task.isOverdue ? .red : .secondary)
                }
            }
            
            Spacer()
            
            PriorityIndicator(priority: task.priority)
        }
        .contentShape(Rectangle())
    }
}
```

### ADHD-Friendly Design Principles
1. **Visual Hierarchy**: Clear distinction between completed/incomplete tasks
2. **Minimal Cognitive Load**: Only essential information visible
3. **Quick Actions**: One-tap completion toggle
4. **Color Coding**: Subtle priority and urgency indicators
5. **Consistent Layout**: Predictable information placement

### Accessibility Features
- VoiceOver support for all interactive elements
- Dynamic Type support for text scaling
- High contrast mode compatibility
- Voice Control compatibility
- Reduced motion support

### Performance Considerations
- Lazy loading for large task lists
- Efficient task filtering and sorting
- Minimal re-renders on data updates
- Proper memory management

## Definition of Done

- Task list displays and updates correctly
- All interactions work smoothly
- Accessibility requirements are met
- Performance is acceptable with large datasets
- Visual design is clean and ADHD-friendly
- Code is well-structured and testable

## Related Issues

- Depends on: #004 - Implement task storage
- Next: #006 - Add task creation form for iPhone
- Enhances: #003 - Define Task model in Swift
- Connects to: #008 - Set up basic watchOS app

## Estimated Effort

**Time:** 3-4 hours  
**Complexity:** Medium  
**Prerequisites:** SwiftUI knowledge, understanding of List views and data binding 