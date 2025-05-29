//
//  ContentView.swift
//  NeuroAssist
//
//  Created by Mike Kamminga on 29/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskRepository = TaskRepository()
    @State private var showingAddTaskDemo = false
    @State private var newTaskTitle = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // NeuroAssist Header
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("NeuroAssist")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Your AI-powered personal assistant")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // Task Statistics
                if !taskRepository.tasks.isEmpty {
                    TaskStatsView(repository: taskRepository)
                }
                
                // Task Storage Demo Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Persistent Task Storage")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Add Task") {
                            showingAddTaskDemo = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                    
                    if taskRepository.isLoading {
                        ProgressView("Loading tasks...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else if taskRepository.tasks.isEmpty {
                        EmptyStateView {
                            loadSampleTasks()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(taskRepository.tasks) { task in
                                    TaskRowView(task: task) {
                                        taskRepository.toggleTaskCompletion(task)
                                    } onDelete: {
                                        taskRepository.deleteTask(task)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                // Status Badge
                Text("Issue #004: Task Storage Complete ✅")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.green.opacity(0.1))
                            .stroke(.green, lineWidth: 1)
                    )
                    .padding(.horizontal)
            }
            .navigationTitle("NeuroAssist")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddTaskDemo) {
                AddTaskDemoView(repository: taskRepository)
            }
            .alert("Error", isPresented: .constant(taskRepository.errorMessage != nil)) {
                Button("OK") {
                    taskRepository.errorMessage = nil
                }
            } message: {
                Text(taskRepository.errorMessage ?? "")
            }
        }
    }
    
    private func loadSampleTasks() {
        let sampleTasks = [
            TaskModel(
                title: "Call doctor for appointment",
                dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
                priority: .high,
                tags: ["health", "phone"],
                notes: "Need to schedule annual checkup"
            ),
            TaskModel(
                title: "Buy groceries",
                dueDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
                priority: .medium,
                tags: ["shopping", "food"],
                notes: "Milk, bread, eggs"
            ),
            TaskModel(
                title: "Finish project presentation",
                dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()), // Overdue
                priority: .urgent,
                tags: ["work", "deadline"],
                notes: "Final slides for client meeting"
            ),
            TaskModel(
                title: "Read book chapter",
                priority: .low,
                tags: ["personal", "learning"]
            ),
            TaskModel(
                title: "Exercise",
                dueDate: Date(),
                priority: .medium,
                tags: ["health", "daily"]
            )
        ]
        
        for task in sampleTasks {
            taskRepository.addTask(task)
        }
    }
}

struct TaskStatsView: View {
    @ObservedObject var repository: TaskRepository
    
    var body: some View {
        let stats = repository.getTaskCount()
        
        HStack(spacing: 20) {
            StatItemView(title: "Total", value: stats.total, color: .blue)
            StatItemView(title: "Completed", value: stats.completed, color: .green)
            StatItemView(title: "Pending", value: stats.pending, color: .orange)
            StatItemView(title: "Overdue", value: stats.overdue, color: .red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.secondary.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

struct StatItemView: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct EmptyStateView: View {
    let onLoadSample: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No tasks yet!")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap below to load sample tasks and see persistent storage in action")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Load Sample Tasks") {
                onLoadSample()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.secondary.opacity(0.1))
        )
        .padding(.horizontal)
    }
}

struct AddTaskDemoView: View {
    @ObservedObject var repository: TaskRepository
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var priority = TaskModel.Priority.medium
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Details") {
                    TextField("Task title", text: $title)
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskModel.Priority.allCases, id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(priority.color)
                                    .frame(width: 12, height: 12)
                                Text(priority.rawValue)
                            }
                        }
                    }
                    
                    Toggle("Set due date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Due date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("Add Task")
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
        let task = TaskModel(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            dueDate: hasDueDate ? dueDate : nil,
            priority: priority
        )
        
        repository.addTask(task)
        dismiss()
    }
}

struct TaskRowView: View {
    let task: TaskModel
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Completion Toggle
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title3)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                // Task Title
                Text(task.title)
                    .font(.headline)
                    .lineLimit(2)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                // Status and Due Date
                HStack {
                    if !task.displayStatus.isEmpty {
                        Text(task.displayStatus)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(statusBackgroundColor)
                            )
                    }
                    
                    if let dueDateText = task.dueDateDisplayText {
                        Text(dueDateText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Tags
                if !task.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(task.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(.blue.opacity(0.1))
                                    )
                            }
                        }
                    }
                }
                
                // Categories (if detected)
                if !task.detectedCategories.isEmpty {
                    Text("Categories: \(task.detectedCategories.joined(separator: ", "))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            
            Spacer()
            
            // Priority Icon
            Image(systemName: task.priority.icon)
                .foregroundColor(task.priority.color)
                .font(.title3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .swipeActions(edge: .trailing) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
        }
    }
    
    private var statusBackgroundColor: Color {
        if task.displayStatus.contains("Complete") {
            return .green.opacity(0.2)
        } else if task.displayStatus.contains("Overdue") {
            return .red.opacity(0.2)
        } else if task.displayStatus.contains("Due Today") {
            return .orange.opacity(0.2)
        } else {
            return .blue.opacity(0.2)
        }
    }
}

#Preview {
    ContentView()
}
