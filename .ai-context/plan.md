To build your AI-powered personal assistant app for iOS and Apple Watch using Cursor and GitHub, I’ve created a detailed scope document broken into phases. Each phase includes small, testable issues that a developer or coding agent can easily pick up, ensuring you can verify progress step by step. Below is the plan, designed for implementation on your Mac with Xcode, Cursor for AI-assisted coding, and GitHub for version control.

---

## Phased Scope Document for AI-Powered Personal Assistant App

### Overview
- **Platforms**: iOS (iPhone), watchOS (Apple Watch)
- **Tools**: Xcode, Cursor (AI-assisted coding), GitHub (version control)
- **Key Features**: Quick task capture, organization, Siri integration, and cross-device syncing, tailored for managing chaotic thoughts (e.g., for ADHD users)
- **Approach**: Incremental phases with small, testable issues for steady progress

---

### Phase 1: Basic Task List
**Goal**: Build a foundational task list app that syncs between iPhone and Apple Watch.

#### Issues
1. **Create Xcode project with iOS and watchOS targets**  
   - **Description**: Set up a new Xcode project with an iOS app and a watchOS app extension.  
   - **Acceptance Criteria**:  
     - Project builds successfully for both platforms.  
     - iOS app launches on simulator/device.  
     - watchOS app launches on watch simulator.  
   - **Guidance**: Use Cursor to generate the project structure with both targets.

2. **Initialize GitHub repository**  
   - **Description**: Create a GitHub repository and link it to the Xcode project.  
   - **Acceptance Criteria**:  
     - Repository is created and connected.  
     - Initial commit includes the project setup.  
   - **Guidance**: Use Xcode’s source control or Git commands to initialize and push.

3. **Define Task model in Swift**  
   - **Description**: Create a `Task` struct with properties: `id`, `title`, `dueDate`, `priority`, `tags`, `isCompleted`.  
   - **Acceptance Criteria**:  
     - `Task` conforms to `Identifiable` and `Codable`.  
     - Properties are correctly typed (e.g., `dueDate: Date?`, `priority: Enum`).  
   - **Guidance**: Use Cursor to generate the struct.

4. **Implement task storage**  
   - **Description**: Use `UserDefaults` or `Core Data` to save and retrieve tasks.  
   - **Acceptance Criteria**:  
     - Tasks persist across app launches.  
     - Tasks can be added and fetched.  
   - **Guidance**: Start with `UserDefaults` for simplicity; Cursor can help with storage methods.

5. **Create task list view for iPhone**  
   - **Description**: Build a SwiftUI view to display tasks on the iPhone.  
   - **Acceptance Criteria**:  
     - Displays all tasks with title and completion status.  
     - Tapping a task toggles its completion.  
   - **Guidance**: Use Cursor to create a `List` view bound to task data.

6. **Add task creation form for iPhone**  
   - **Description**: Implement a form to add new tasks manually.  
   - **Acceptance Criteria**:  
     - Form includes fields for title, due date, priority, and tags.  
     - New tasks appear in the list and storage.  
   - **Guidance**: Use Cursor to generate a `Form` or `Sheet`.

7. **Add voice input for task creation on iPhone**  
   - **Description**: Add a microphone button for voice-to-text task entry.  
   - **Acceptance Criteria**:  
     - Tapping the button starts voice recognition.  
     - Spoken text becomes the task title and is added to the list.  
   - **Guidance**: Use Apple’s `Speech` framework; Cursor can assist with integration.

8. **Set up basic watchOS app**  
   - **Description**: Create a simple task list view for Apple Watch.  
   - **Acceptance Criteria**:  
     - Watch displays tasks with titles.  
     - Tasks match those on the iPhone.  
   - **Guidance**: Use Cursor to generate a watchOS `List` view.

9. **Implement data syncing between iPhone and Apple Watch**  
   - **Description**: Use `WatchConnectivity` to sync tasks between devices.  
   - **Acceptance Criteria**:  
     - Tasks added on iPhone appear on watch.  
     - Completion updates sync both ways.  
   - **Guidance**: Cursor can help set up `WatchConnectivity`.

---

### Phase 2: Siri and Intelligence Integration
**Goal**: Add voice-driven task management and basic AI categorization.

#### Issues
1. **Add App Intents extension**  
   - **Description**: Set up an App Intents extension for Siri integration.  
   - **Acceptance Criteria**:  
     - Extension is added and builds successfully.  
   - **Guidance**: Use Cursor to generate the extension template.

2. **Define add task intent**  
   - **Description**: Create an intent for adding tasks via Siri.  
   - **Acceptance Criteria**:  
     - Intent is defined with parameters like task title.  
   - **Guidance**: Cursor can help define the intent schema.

3. **Implement intent handling**  
   - **Description**: Parse Siri input to create tasks.  
   - **Acceptance Criteria**:  
     - Commands like “Add task to call Mom” create a task.  
   - **Guidance**: Use Cursor to implement the handler.

4. **Use NLP for task categorization**  
   - **Description**: Extract categories or priorities from task descriptions.  
   - **Acceptance Criteria**:  
     - Tasks are tagged (e.g., “buy milk” → “Groceries”).  
   - **Guidance**: Use Apple’s NLP or keyword matching; Cursor can assist.

5. **Set up notifications for reminders**  
   - **Description**: Enable reminders for tasks with due dates.  
   - **Acceptance Criteria**:  
     - Notifications trigger at the specified time.  
   - **Guidance**: Use `UserNotifications`; Cursor can generate the setup.

---

### Phase 3: Advanced Features
**Goal**: Enhance with proactive features and deeper integration.

#### Issues
1. **Implement rule-based task prioritization**  
   - **Description**: Suggest task order based on due date and priority.  
   - **Acceptance Criteria**:  
     - Tasks are sorted or highlighted by urgency.  
   - **Guidance**: Use simple algorithms; Cursor can help with logic.

2. **Add location-based reminders**  
   - **Description**: Trigger reminders near relevant locations.  
   - **Acceptance Criteria**:  
     - Reminders like “buy milk” trigger near a store.  
   - **Guidance**: Use `Core Location`; Cursor can assist with geofencing.

3. **Integrate with calendar**  
   - **Description**: Schedule tasks in the user’s calendar.  
   - **Acceptance Criteria**:  
     - Tasks with due dates appear in the calendar.  
   - **Guidance**: Use `EventKit`; Cursor can generate the code.

4. **Create settings page**  
   - **Description**: Allow customization of notifications and categories.  
   - **Acceptance Criteria**:  
     - Users can adjust preferences.  
   - **Guidance**: Use SwiftUI; Cursor can design the view.

---

### Testing and Validation
- Each issue has **acceptance criteria** for easy testing.  
- Test after each phase using Xcode simulators or devices.  
- Verify features like task addition, syncing, and Siri input work as expected.

---

### Additional Notes
- **Cursor Usage**: Use Cursor to generate code, refactor, and debug. Each issue includes guidance to maximize its help.  
- **UI/UX**: Keep the interface clean and minimal to avoid overwhelming users, especially those with ADHD.  
- **Future Ideas**: Add machine learning for smarter suggestions later, but stick to Apple’s built-in tools for now.

```swift
struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var dueDate: Date?
    var priority: Priority
    var tags: [String]
    var isCompleted: Bool
    
    enum Priority: String, Codable {
        case low
        case medium
        case high
    }
    
    init(title: String, dueDate: Date? = nil, priority: Priority = .medium, tags: [String] = [], isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.tags = tags
        self.isCompleted = isCompleted
    }
}
```

This plan provides a clear roadmap for your app, with small, testable steps to keep development manageable. Let me know if you’d like to tweak any phase or add features!