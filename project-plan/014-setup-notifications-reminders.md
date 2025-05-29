# Issue #014: Set up notifications for reminders

**Labels:** `phase-2` `notifications` `reminders` `priority-high`

## Description

Implement a comprehensive notification system that reminds users about upcoming tasks and deadlines. For ADHD users, timely and contextual reminders are crucial for task completion and time management.

## Acceptance Criteria

- [ ] Local notifications are scheduled for tasks with due dates
- [ ] Smart reminder timing based on task priority and user patterns
- [ ] Customizable reminder intervals (15 min, 1 hour, 1 day before)
- [ ] Rich notifications with task details and quick actions
- [ ] Location-based reminders when near relevant places
- [ ] Gentle escalation for overdue tasks
- [ ] Notification permissions are requested appropriately
- [ ] Quiet hours and do-not-disturb integration
- [ ] Apple Watch notifications work seamlessly

## Technical Implementation
```swift
import UserNotifications
import CoreLocation

class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()
    
    override init() {
        super.init()
        requestPermissions()
    }
    
    func scheduleReminder(for task: Task) {
        guard let dueDate = task.dueDate else { return }
        
        let intervals = reminderIntervals(for: task.priority)
        
        for interval in intervals {
            let notificationDate = Calendar.current.date(byAdding: .minute, value: -interval, to: dueDate)
            guard let notificationDate = notificationDate, notificationDate > Date() else { continue }
            
            scheduleNotification(
                for: task,
                at: notificationDate,
                type: .reminder(minutesBefore: interval)
            )
        }
    }
    
    private func reminderIntervals(for priority: Task.Priority) -> [Int] {
        switch priority {
        case .urgent:
            return [5, 15, 60, 1440] // 5min, 15min, 1hr, 1day
        case .high:
            return [15, 60, 1440] // 15min, 1hr, 1day
        case .medium:
            return [60, 1440] // 1hr, 1day
        case .low:
            return [1440] // 1day
        }
    }
}
```

## Related Issues

- Depends on: #013 - Use NLP for task categorization
- Next: #015 - Implement rule-based task prioritization
- Enhances: #003 - Define Task model in Swift

## Estimated Effort

**Time:** 3-4 hours  
**Complexity:** Medium 