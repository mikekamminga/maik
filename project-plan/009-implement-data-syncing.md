# Issue #009: Implement data syncing between iPhone and Apple Watch

**Labels:** `phase-1` `watchconnectivity` `sync` `data` `priority-high`

## Description

Implement robust data synchronization between iPhone and Apple Watch using WatchConnectivity framework. Tasks created or modified on either device should be immediately reflected on the other device to maintain consistency.

## Background

Seamless syncing is essential for NeuroAssist users who may capture tasks on either device. ADHD users particularly benefit from having their tasks accessible wherever they look, without worrying about which device they used to create them.

## Acceptance Criteria

- [ ] WatchConnectivity framework is properly configured on both devices
- [ ] Tasks created on iPhone appear on Apple Watch immediately
- [ ] Tasks created/modified on Apple Watch sync to iPhone
- [ ] Task completion status syncs bidirectionally
- [ ] Sync works when devices are paired and reachable
- [ ] Offline changes are queued and sync when connection is restored
- [ ] Conflict resolution handles simultaneous edits gracefully
- [ ] Performance remains smooth with large numbers of tasks
- [ ] Error handling manages connectivity issues properly

## Implementation Guidance

### Using Cursor
- Use Cursor to generate WatchConnectivity setup and session management
- Ask Cursor to create message passing protocols between devices
- Use Cursor to implement conflict resolution strategies

### Technical Implementation
```swift
import WatchConnectivity

class WatchSessionManager: NSObject, ObservableObject {
    static let shared = WatchSessionManager()
    
    @Published var isReachable = false
    private let session = WCSession.default
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func sendTask(_ task: Task) {
        guard session.isReachable else {
            // Queue for later transmission
            queueMessage(task: task)
            return
        }
        
        do {
            let data = try JSONEncoder().encode(task)
            let message = ["task": data, "action": "add"]
            session.sendMessage(message, replyHandler: nil) { error in
                print("Failed to send task: \(error.localizedDescription)")
            }
        } catch {
            print("Failed to encode task: \(error)")
        }
    }
    
    func updateTask(_ task: Task) {
        guard session.isReachable else {
            queueMessage(task: task, action: "update")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(task)
            let message = ["task": data, "action": "update"]
            session.sendMessage(message, replyHandler: nil)
        } catch {
            print("Failed to encode task update: \(error)")
        }
    }
    
    func deleteTask(_ taskId: UUID) {
        guard session.isReachable else {
            queueMessage(taskId: taskId, action: "delete")
            return
        }
        
        let message = ["taskId": taskId.uuidString, "action": "delete"]
        session.sendMessage(message, replyHandler: nil)
    }
    
    private func queueMessage(task: Task? = nil, taskId: UUID? = nil, action: String) {
        // Implement message queue for offline scenarios
    }
}

extension WatchSessionManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
            if session.isReachable {
                self.processQueuedMessages()
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.handleReceivedMessage(message)
        }
    }
    
    private func handleReceivedMessage(_ message: [String: Any]) {
        guard let action = message["action"] as? String else { return }
        
        switch action {
        case "add", "update":
            guard let taskData = message["task"] as? Data,
                  let task = try? JSONDecoder().decode(Task.self, from: taskData) else { return }
            
            if action == "add" {
                TaskRepository.shared.addTask(task, syncToWatch: false)
            } else {
                TaskRepository.shared.updateTask(task, syncToWatch: false)
            }
            
        case "delete":
            guard let taskIdString = message["taskId"] as? String,
                  let taskId = UUID(uuidString: taskIdString) else { return }
            
            TaskRepository.shared.deleteTask(withId: taskId, syncToWatch: false)
            
        default:
            break
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle iOS-specific session lifecycle
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
}
```

### Enhanced TaskRepository with Sync
```swift
extension TaskRepository {
    func addTask(_ task: Task, syncToWatch: Bool = true) {
        // Add to local storage
        addTaskLocally(task)
        
        // Sync to watch if enabled
        if syncToWatch {
            WatchSessionManager.shared.sendTask(task)
        }
    }
    
    func updateTask(_ task: Task, syncToWatch: Bool = true) {
        // Update local storage
        updateTaskLocally(task)
        
        // Sync to watch if enabled
        if syncToWatch {
            WatchSessionManager.shared.updateTask(task)
        }
    }
    
    func deleteTask(withId id: UUID, syncToWatch: Bool = true) {
        // Delete from local storage
        deleteTaskLocally(withId: id)
        
        // Sync to watch if enabled
        if syncToWatch {
            WatchSessionManager.shared.deleteTask(id)
        }
    }
}
```

### Sync Features
1. **Real-time Sync**: Changes appear immediately when devices are connected
2. **Offline Queue**: Changes are stored and synced when connection is restored
3. **Conflict Resolution**: Last-write-wins with timestamp comparison
4. **Efficient Updates**: Only changed data is transmitted
5. **Error Recovery**: Robust handling of connectivity issues

### Performance Optimizations
- **Batch Updates**: Group multiple changes into single messages
- **Differential Sync**: Only send changes, not entire datasets
- **Compression**: Reduce message size for large task lists
- **Throttling**: Prevent message flooding during rapid changes

### Testing Scenarios
- Test sync with both devices connected
- Test offline changes and subsequent sync
- Test rapid task creation/modification
- Test conflict resolution with simultaneous edits
- Test sync performance with large task lists
- Test error recovery scenarios

## Definition of Done

- Tasks sync reliably between iPhone and Apple Watch
- Sync works in both online and offline scenarios
- Performance is acceptable with realistic task volumes
- Error handling manages all connectivity edge cases
- Code is well-documented and maintainable
- Sync behavior is consistent and predictable

## Related Issues

- Depends on: #008 - Set up basic watchOS app
- Completes: Phase 1 foundation
- Enables: #010 - Add App Intents extension for Siri integration
- Prepares for: #014 - Set up notifications for reminders

## Estimated Effort

**Time:** 4-6 hours  
**Complexity:** High  
**Prerequisites:** WatchConnectivity framework knowledge, understanding of device communication patterns 