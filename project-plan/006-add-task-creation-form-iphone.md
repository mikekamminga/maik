# Issue #006: Add task creation form for iPhone

**Labels:** `phase-1` `ui` `ios` `forms` `priority-high`

## Description

Create a task creation form interface for iPhone that allows users to manually add new tasks with optional metadata like due dates, priorities, and tags. The form must be simple and quick to use, minimizing friction for ADHD users.

## Background

While voice input (#007) will be the primary method for quick capture, users also need a manual form for more detailed task creation. The form should support quick entry while offering optional fields for organization without overwhelming the user.

## Acceptance Criteria

- [ ] Form includes required field for task title
- [ ] Optional fields for due date, priority, and tags
- [ ] Date picker is easy to use and supports common presets (Today, Tomorrow, This Week)
- [ ] Priority selection uses clear visual indicators
- [ ] Tags can be added with suggestions from existing tags
- [ ] Form validates input and shows helpful error messages
- [ ] Save button creates task and dismisses form
- [ ] Cancel button discards changes with confirmation if needed
- [ ] Form is accessible with VoiceOver support
- [ ] Keyboard shortcuts and navigation work properly

## Implementation Guidance

### Using Cursor
- Use Cursor to generate SwiftUI Form with proper field binding
- Ask Cursor to create date picker with preset options
- Use Cursor to implement tag input with suggestions

### Technical Implementation
```swift
struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var taskRepository = TaskRepository()
    
    @State private var title = ""
    @State private var dueDate: Date?
    @State private var hasDueDate = false
    @State private var priority = Task.Priority.medium
    @State private var tags: [String] = []
    @State private var newTag = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Details") {
                    TextField("Task title", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    Toggle("Set due date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Due date", selection: Binding(
                            get: { dueDate ?? Date() },
                            set: { dueDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute])
                        
                        QuickDateButtons(dueDate: $dueDate)
                    }
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $priority) {
                        ForEach(Task.Priority.allCases, id: \.self) { priority in
                            HStack {
                                PriorityIndicator(priority: priority)
                                Text(priority.rawValue)
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Tags") {
                    TagInputView(tags: $tags, newTag: $newTag)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let task = Task(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority,
            tags: tags
        )
        
        taskRepository.addTask(task)
        dismiss()
    }
}

struct QuickDateButtons: View {
    @Binding var dueDate: Date?
    
    var body: some View {
        HStack {
            Button("Today") {
                dueDate = Calendar.current.startOfDay(for: Date())
            }
            Button("Tomorrow") {
                dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            }
            Button("This Week") {
                dueDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())
            }
        }
        .buttonStyle(.bordered)
    }
}
```

### ADHD-Friendly Form Design
1. **Progressive Disclosure**: Optional fields are hidden until needed
2. **Quick Presets**: Common date options available as buttons
3. **Visual Priority**: Clear priority indicators reduce cognitive load
4. **Smart Defaults**: Sensible defaults minimize decisions
5. **Validation**: Immediate feedback on required fields

### Form Features
- **Auto-focus**: Title field is focused when form opens
- **Smart Keyboard**: Appropriate keyboard types for each field
- **Haptic Feedback**: Subtle feedback for successful actions
- **Quick Actions**: Swipe gestures for common operations
- **Keyboard Shortcuts**: Support for external keyboards

### Tag Management
- Suggestions based on existing tags
- Quick removal with swipe gestures
- Visual indicators for different tag categories
- Autocomplete for faster entry

## Definition of Done

- Form creates tasks correctly with all field combinations
- User experience is smooth and intuitive
- All accessibility requirements are met
- Input validation works properly
- Integration with task storage is seamless
- Form follows iOS design guidelines

## Related Issues

- Depends on: #005 - Create task list view for iPhone
- Next: #007 - Add voice input for task creation on iPhone
- Enhances: #004 - Implement task storage
- Connects to: #003 - Define Task model in Swift

## Estimated Effort

**Time:** 2-3 hours  
**Complexity:** Medium  
**Prerequisites:** SwiftUI Forms, data binding, user input validation 