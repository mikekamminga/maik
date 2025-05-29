# Issue #018: Create settings page

**Labels:** `phase-3` `ui` `settings` `customization` `priority-low`

## Description

Create a comprehensive settings page that allows users to customize NeuroAssist behavior, notification preferences, categorization rules, and accessibility options. This provides personalization essential for ADHD users with different needs and preferences.

## Acceptance Criteria

- [ ] Settings organized in logical sections (Notifications, Privacy, Appearance, etc.)
- [ ] Notification preferences with granular control
- [ ] Categorization rules can be customized
- [ ] Accessibility options (text size, contrast, reduced motion)
- [ ] Data export/import functionality
- [ ] Privacy controls for location and voice data
- [ ] ADHD-specific customizations (focus modes, reminder frequency)
- [ ] Settings sync across iPhone and Apple Watch
- [ ] Reset options for individual sections

## Technical Implementation
```swift
struct SettingsView: View {
    @StateObject private var settings = AppSettings.shared
    
    var body: some View {
        NavigationView {
            List {
                Section("Notifications") {
                    Toggle("Enable Reminders", isOn: $settings.notificationsEnabled)
                    Toggle("Location Reminders", isOn: $settings.locationRemindersEnabled)
                    Picker("Default Reminder Time", selection: $settings.defaultReminderInterval) {
                        ForEach(ReminderInterval.allCases) { interval in
                            Text(interval.displayName).tag(interval)
                        }
                    }
                }
                
                Section("Categorization") {
                    Toggle("Auto-categorize Tasks", isOn: $settings.autoCategorizeEnabled)
                    Toggle("Smart Priority Detection", isOn: $settings.smartPriorityEnabled)
                    NavigationLink("Manage Categories") {
                        CategoryManagementView()
                    }
                }
                
                Section("Accessibility") {
                    Toggle("Reduce Motion", isOn: $settings.reduceMotionEnabled)
                    Toggle("High Contrast", isOn: $settings.highContrastEnabled)
                    Picker("Text Size", selection: $settings.textSize) {
                        ForEach(TextSize.allCases) { size in
                            Text(size.displayName).tag(size)
                        }
                    }
                }
                
                Section("Privacy & Data") {
                    Toggle("Sync Across Devices", isOn: $settings.syncEnabled)
                    Button("Export Data") {
                        exportUserData()
                    }
                    Button("Reset All Settings") {
                        resetSettings()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @Published var notificationsEnabled = true
    @Published var locationRemindersEnabled = true
    @Published var autoCategorizeEnabled = true
    @Published var smartPriorityEnabled = true
    @Published var reduceMotionEnabled = false
    @Published var highContrastEnabled = false
    @Published var syncEnabled = true
    
    // Save settings to UserDefaults and sync to Watch
    func save() {
        // Implementation for persistence and sync
    }
}
```

## Related Issues

- Depends on: #017 - Integrate with calendar
- Completes: Final Phase 3 issue
- Enhances: All previous features with customization

## Estimated Effort

**Time:** 3-4 hours  
**Complexity:** Low-Medium 