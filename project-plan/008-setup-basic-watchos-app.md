# Issue #008: Set up basic watchOS app

**Labels:** `phase-1` `watchos` `ui` `setup` `priority-medium`

## Description

Create a basic watchOS app interface that displays tasks and allows quick interactions. The watch app should provide at-a-glance task information and enable simple task management without requiring the iPhone.

## Background

Apple Watch is crucial for ADHD users who need quick access to tasks without the distraction of opening their phone. The watch interface must be extremely simple, focused, and optimized for brief interactions.

## Acceptance Criteria

- [ ] watchOS app displays list of tasks from shared data
- [ ] Tasks show title and completion status clearly
- [ ] Users can mark tasks complete/incomplete with tap
- [ ] Interface follows watchOS design guidelines
- [ ] Navigation is intuitive with Digital Crown and tap gestures
- [ ] Performance is smooth on Apple Watch hardware
- [ ] App works independently when iPhone is not nearby
- [ ] Complications support (optional) for quick task count
- [ ] Accessibility features work with Apple Watch VoiceOver

## Implementation Guidance

### Using Cursor
- Use Cursor to generate watchOS SwiftUI views
- Ask Cursor to create watch-specific navigation patterns
- Use Cursor to implement Digital Crown integration

### Technical Implementation
```swift
// WatchOS ContentView
struct ContentView: View {
    @StateObject private var taskRepository = TaskRepository()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(incompleteTasks) { task in
                    TaskRowView(task: task)
                }
                
                if incompleteTasks.isEmpty {
                    Text("All done! 🎉")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("Tasks")
        }
    }
    
    private var incompleteTasks: [Task] {
        taskRepository.tasks.filter { !$0.isCompleted }
    }
}

struct TaskRowView: View {
    let task: Task
    @StateObject private var taskRepository = TaskRepository()
    
    var body: some View {
        HStack {
            Button(action: toggleTask) {
                Image(systemName: "circle")
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.body)
                    .lineLimit(2)
                
                if task.isOverdue {
                    Text("Overdue")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
            
            if task.priority == .high || task.priority == .urgent {
                Circle()
                    .fill(priorityColor)
                    .frame(width: 8, height: 8)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleTask()
        }
    }
    
    private func toggleTask() {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        if updatedTask.isCompleted {
            updatedTask.completedAt = Date()
        }
        taskRepository.updateTask(updatedTask)
    }
    
    private var priorityColor: Color {
        switch task.priority {
        case .urgent: return .red
        case .high: return .orange
        default: return .clear
        }
    }
}
```

### watchOS-Specific Features
1. **Simplified Interface**: Only essential information visible
2. **Large Touch Targets**: Easy interaction with fingers
3. **Digital Crown**: Scroll through long task lists
4. **Force Touch**: Quick actions menu (if supported)
5. **Complications**: Quick task count on watch face

### Watch-Specific Optimizations
- **Minimal Text**: Abbreviated labels and short titles
- **High Contrast**: Clear visibility in various lighting
- **Battery Efficiency**: Optimized for watch battery constraints
- **Quick Interactions**: Most actions complete in 1-2 taps
- **Offline Capability**: Core functions work without iPhone

### Navigation Patterns
```swift
// Watch-specific navigation
struct TaskDetailView: View {
    let task: Task
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.headline)
                
                if let dueDate = task.dueDate {
                    Label(dueDate.formatted(date: .abbreviated, time: .shortened), 
                          systemImage: "calendar")
                        .font(.caption)
                }
                
                if !task.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(task.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.secondary.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
```

## Definition of Done

- watchOS app builds and runs on Apple Watch simulator
- Task list displays correctly with proper formatting
- Task completion toggle works reliably
- Navigation follows watchOS conventions
- Performance is acceptable on real Apple Watch hardware
- Interface is accessible and easy to use
- Code is structured for future enhancements

## Related Issues

- Depends on: #004 - Implement task storage
- Next: #009 - Implement data syncing between iPhone and Apple Watch
- Enhances: #005 - Create task list view for iPhone
- Prepares for: #016 - Add location-based reminders

## Estimated Effort

**Time:** 3-4 hours  
**Complexity:** Medium  
**Prerequisites:** watchOS development knowledge, understanding of WatchKit limitations 