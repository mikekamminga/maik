# Issue #015: Implement rule-based task prioritization

**Labels:** `phase-3` `prioritization` `ai` `smart-features` `priority-medium`

## Description

Develop intelligent task prioritization using rule-based algorithms that suggest optimal task ordering based on due dates, priorities, estimated effort, and user behavior patterns. This helps ADHD users focus on the most important tasks first.

## Acceptance Criteria

- [ ] Algorithm analyzes tasks and suggests optimal ordering
- [ ] Considers due dates, priorities, and estimated completion time
- [ ] Learns from user task completion patterns
- [ ] Suggests "focus mode" with 1-3 priority tasks
- [ ] Adapts to different times of day and user energy levels
- [ ] Provides reasoning for prioritization suggestions
- [ ] User can accept/reject suggestions
- [ ] Integration with main task list view

## Technical Implementation
```swift
class TaskPrioritizer {
    static let shared = TaskPrioritizer()
    
    func prioritizeTasks(_ tasks: [Task]) -> [PrioritizedTask] {
        return tasks.compactMap { task in
            let score = calculatePriorityScore(task)
            return PrioritizedTask(task: task, score: score)
        }.sorted { $0.score > $1.score }
    }
    
    private func calculatePriorityScore(_ task: Task) -> Double {
        var score: Double = 0
        
        // Due date urgency (0-50 points)
        if let dueDate = task.dueDate {
            let hoursUntilDue = dueDate.timeIntervalSinceNow / 3600
            score += max(0, 50 - hoursUntilDue / 24)
        }
        
        // Priority weight (0-30 points)
        switch task.priority {
        case .urgent: score += 30
        case .high: score += 20
        case .medium: score += 10
        case .low: score += 5
        }
        
        // Overdue penalty (+20 points)
        if task.isOverdue {
            score += 20
        }
        
        return score
    }
}
```

## Related Issues

- Depends on: #014 - Set up notifications for reminders
- Next: #016 - Add location-based reminders
- Enhances: #005 - Create task list view for iPhone

## Estimated Effort

**Time:** 4-5 hours  
**Complexity:** Medium 