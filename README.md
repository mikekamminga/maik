# NeuroAssist - AI-Powered Personal Assistant

<div align="center">
  <img src="https://img.shields.io/badge/iOS-17.5+-blue.svg" alt="iOS 17.5+" />
  <img src="https://img.shields.io/badge/watchOS-10.5+-blue.svg" alt="watchOS 10.5+" />
  <img src="https://img.shields.io/badge/Swift-5.0+-orange.svg" alt="Swift 5.0+" />
  <img src="https://img.shields.io/badge/SwiftUI-Native-green.svg" alt="SwiftUI" />
</div>

## 🧠 Overview

NeuroAssist is an AI-powered personal assistant app specifically designed for neurodiverse individuals, particularly those with ADHD, who need help capturing chaotic thoughts and organizing them into actionable tasks. The app provides seamless task management across iPhone and Apple Watch with intelligent voice input and proactive organization.

## 🎯 Target Audience

This app is designed for individuals who:
- Have ADHD or other neurodiverse traits
- Struggle with organizing chaotic thoughts
- Need quick, frictionless task capture
- Benefit from intelligent reminders and categorization
- Use both iPhone and Apple Watch for productivity

## ✨ Key Features

### 📱 iPhone Features
- **Quick Task Capture**: Instant task creation with minimal friction
- **Voice Input**: Speech-to-text for rapid thought capture
- **Smart Categorization**: AI-powered task organization
- **Priority Management**: Intelligent priority suggestions
- **Beautiful Interface**: Clean, ADHD-friendly design

### ⌚ Apple Watch Features
- **Glanceable Tasks**: Quick view of important tasks
- **Voice Capture**: "Hey Siri" task creation
- **Complications**: Task count on watch face
- **Offline Sync**: Works independently, syncs when connected

### 🤖 AI Features
- **Siri Integration**: Natural language task creation
- **Smart Categorization**: Automatic task organization
- **Priority Detection**: Context-aware importance levels
- **Location Awareness**: Place-based reminders
- **Calendar Integration**: Seamless scheduling

## 🛠 Technology Stack

- **Language**: Swift 5.0+
- **UI Framework**: SwiftUI
- **Deployment Targets**: iOS 17.5+, watchOS 10.5+
- **Data Persistence**: Core Data / UserDefaults
- **Cross-device Sync**: WatchConnectivity
- **Voice Recognition**: Speech Framework
- **AI Integration**: App Intents + Natural Language
- **Location Services**: Core Location
- **Calendar**: EventKit

## 🚀 Getting Started

### Prerequisites
- Xcode 15.4+
- iOS 17.5+ device or simulator
- Apple Watch with watchOS 10.5+ (for watch features)
- Apple Developer account (for device testing)

### Installation
1. Clone this repository
   ```bash
   git clone https://github.com/mikekamminga/neuroassist-app.git
   cd neuroassist-app
   ```

2. Open `NeuroAssist.xcodeproj` in Xcode

3. Select your development team in project settings

4. Build and run on your device or simulator

### Running Tests
```bash
# Run iOS tests
xcodebuild test -scheme NeuroAssist -destination 'platform=iOS Simulator,name=iPhone 15'

# Run watchOS tests  
xcodebuild test -scheme 'NeuroAssist Watch App Watch App' -destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)'
```

## 📋 Development Phases

### Phase 1: Foundation (Complete ✅)
- [x] Basic task list functionality
- [x] Cross-device syncing (iPhone ↔ Apple Watch)
- [x] Voice input for task creation
- [x] Core data persistence

### Phase 2: Intelligence (In Progress 🚧)
- [ ] Siri integration with App Intents
- [ ] AI-powered task categorization
- [ ] Smart notifications and reminders
- [ ] Natural language processing

### Phase 3: Advanced Features (Planned 📋)
- [ ] Proactive task prioritization
- [ ] Location-based reminders
- [ ] Calendar integration
- [ ] Advanced settings and customization

## 🏗 Project Structure

```
NeuroAssist/
├── NeuroAssist/                     # iOS App Target
│   ├── NeuroAssistApp.swift        # App entry point
│   ├── ContentView.swift           # Main interface
│   └── Assets.xcassets/            # App icons and assets
├── NeuroAssist Watch App Watch App/ # watchOS App Target
│   ├── NeuroAssist_Watch_AppApp.swift
│   ├── ContentView.swift           # Watch interface
│   └── Assets.xcassets/            # Watch-specific assets
├── NeuroAssistTests/               # iOS Unit Tests
├── NeuroAssistUITests/             # iOS UI Tests
└── README.md                       # This file
```

## 🎨 Design Philosophy

NeuroAssist follows these principles:
- **Minimal Cognitive Load**: Reduce decisions and complexity
- **Frictionless Capture**: Get thoughts recorded in seconds
- **Intelligent Defaults**: Smart suggestions reduce manual work
- **Cross-Platform Consistency**: Seamless experience across devices
- **Accessibility First**: Built for neurodiverse users

## 🤝 Contributing

We welcome contributions! This project is designed to help the neurodiverse community, and we appreciate:

1. **Bug Reports**: Found an issue? Please open an issue
2. **Feature Requests**: Have an idea? We'd love to hear it
3. **Code Contributions**: Submit a pull request
4. **UX Feedback**: Especially from neurodiverse users

### Development Setup
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/mikekamminga/neuroassist-app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/mikekamminga/neuroassist-app/discussions)
- **Email**: support@neuroassist.app (when available)

## 🙏 Acknowledgments

- Designed with love for the ADHD and neurodiverse community
- Built with modern iOS development best practices
- Inspired by the need for truly accessible productivity tools

---

**Made with ❤️ for the neurodiverse community**
