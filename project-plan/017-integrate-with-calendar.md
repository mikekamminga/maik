# Issue #017: Integrate with calendar

**Labels:** `phase-3` `calendar` `eventkit` `scheduling` `priority-medium`

## Description

Integrate NeuroAssist with the user's calendar to automatically schedule time blocks for tasks, show upcoming deadlines alongside calendar events, and provide better time management for ADHD users.

## Acceptance Criteria

- [ ] Tasks with due dates appear in calendar view
- [ ] Users can schedule dedicated time blocks for tasks
- [ ] Calendar events can be converted to tasks
- [ ] Smart scheduling suggests optimal times for task completion
- [ ] Integration respects existing calendar events and availability
- [ ] Works with multiple calendar accounts
- [ ] Privacy-conscious access to calendar data
- [ ] Two-way sync keeps tasks and events synchronized

## Technical Implementation
```swift
import EventKit

class CalendarIntegrationManager: ObservableObject {
    static let shared = CalendarIntegrationManager()
    
    private let eventStore = EKEventStore()
    @Published var hasCalendarAccess = false
    
    func requestCalendarAccess() async {
        let status = await eventStore.requestAccess(to: .event)
        await MainActor.run {
            hasCalendarAccess = status
        }
    }
    
    func scheduleTaskBlock(for task: Task, duration: TimeInterval, preferredTime: Date?) async throws {
        guard hasCalendarAccess else {
            throw CalendarError.noAccess
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = "Work on: \(task.title)"
        event.notes = "NeuroAssist scheduled task block"
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        if let startTime = preferredTime {
            event.startDate = startTime
            event.endDate = startTime.addingTimeInterval(duration)
        }
        
        try eventStore.save(event, span: .thisEvent)
    }
}
```

## Related Issues

- Depends on: #016 - Add location-based reminders
- Next: #018 - Create settings page
- Enhances: #003 - Define Task model in Swift

## Estimated Effort

**Time:** 5-6 hours  
**Complexity:** Medium 