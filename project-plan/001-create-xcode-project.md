# Issue #001: Create Xcode project with iOS and watchOS targets

**Labels:** `phase-1` `setup` `ios` `watchos` `priority-high`

## Description

Set up a new Xcode project with both iOS app and watchOS app extension targets to establish the foundation for the NeuroAssist personal assistant app. This project will serve as the base for all subsequent development phases.

## Background

NeuroAssist needs to work seamlessly across iPhone and Apple Watch to provide quick task capture and management for users with ADHD and neurodiverse traits. The project structure must support both platforms from the start.

## Acceptance Criteria

- [ ] New Xcode project is created with appropriate bundle identifier (e.g., `com.yourname.neuroassist`)
- [ ] iOS app target builds successfully for iPhone
- [ ] watchOS app target builds successfully for Apple Watch
- [ ] iOS app launches on iOS simulator/device without crashes
- [ ] watchOS app launches on watch simulator without crashes
- [ ] Project uses SwiftUI for both iOS and watchOS interfaces
- [ ] Deployment targets are set appropriately (iOS 16+, watchOS 9+)

## Implementation Guidance

### Using Cursor
- Use Cursor to help generate the initial project structure
- Ask Cursor to create boilerplate SwiftUI views for both platforms
- Use Cursor to ensure proper target configuration

### Technical Details
1. Create new Xcode project with "iOS" template
2. Add watchOS app target through "Add Target" → "watchOS" → "App"
3. Configure shared code between targets using a shared framework or group
4. Set up proper Info.plist files for both targets
5. Ensure WatchKit extension is properly configured

### Project Structure
```
NeuroAssist/
├── NeuroAssist (iOS)/
│   ├── ContentView.swift
│   ├── NeuroAssistApp.swift
│   └── Info.plist
├── NeuroAssist Watch App/
│   ├── ContentView.swift
│   ├── NeuroAssistApp.swift
│   └── Info.plist
└── Shared/
    └── (shared models and utilities)
```

## Definition of Done

- Both iOS and watchOS apps build without errors
- Apps can be run on simulators
- Project is ready for version control setup
- Basic "Hello World" interface is displayed on both platforms

## Related Issues

- Next: #002 - Initialize GitHub repository
- Blocks: All subsequent development issues

## Estimated Effort

**Time:** 1-2 hours  
**Complexity:** Low  
**Prerequisites:** Xcode installed, Apple Developer account (for device testing) 