import SwiftUI

struct ContentView: View {
    // Sample tasks to demonstrate the model
    @State private var sampleTasks = Task.sampleTasks
    
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
                
                // Task Model Demo Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Task Model Demo")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(sampleTasks) { task in
                                TaskRowView(task: task)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Status Badge
                Text("Issue #003: Task Model Complete ✅")
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
        }
    }
}

struct TaskRowView: View {
    let task: Task
    
    var body: some View {
        HStack(spacing: 12) {
            // Priority Indicator
            Circle()
                .fill(task.priority.color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                // Task Title
                Text(task.title)
                    .font(.headline)
                    .lineLimit(2)
                
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