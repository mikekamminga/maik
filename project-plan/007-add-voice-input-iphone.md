# Issue #007: Add voice input for task creation on iPhone

**Labels:** `phase-1` `voice-input` `ios` `accessibility` `priority-high`

## Description

Implement voice-to-text functionality for quick task capture on iPhone. This is a critical feature for ADHD users who need to capture thoughts immediately before they disappear, without the friction of typing.

## Background

Voice input is essential for NeuroAssist's core value proposition. Users with ADHD often have rapid, fleeting thoughts that need to be captured immediately. Voice input removes barriers and enables hands-free task creation while users are doing other activities.

## Acceptance Criteria

- [ ] Microphone button is added to the main task creation interface
- [ ] Tapping the microphone button starts voice recognition
- [ ] Speech is converted to text accurately
- [ ] Converted text appears in the task title field
- [ ] Voice input handles common task-related phrases naturally
- [ ] Error handling for speech recognition failures
- [ ] Proper permissions are requested for microphone access
- [ ] Visual feedback shows when recording is active
- [ ] Voice input works both in the main app and from shortcuts

## Implementation Guidance

### Using Cursor
- Use Cursor to generate Speech framework integration code
- Ask Cursor to create proper error handling for speech recognition
- Use Cursor to design the voice input UI components

### Technical Implementation
```swift
import Speech

class SpeechRecognizer: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var transcription = ""
    @Published var isRecording = false
    
    func startRecording() {
        // Implementation details
    }
    
    func stopRecording() {
        // Implementation details
    }
}
```

### Key Features
1. **Microphone Button**: Clear, accessible button in the UI
2. **Real-time Transcription**: Show text as it's being recognized
3. **Auto-stop**: Stop recording after pause or manual trigger
4. **Permission Handling**: Request and handle microphone permissions gracefully
5. **Error Recovery**: Handle network issues, permission denials

### Privacy Considerations
- Request permissions with clear explanation
- Handle permission denials gracefully
- Inform users about voice data processing
- Provide alternative text input method

### Testing Scenarios
- Test with various accents and speaking speeds
- Test with background noise
- Test permission flows (granted, denied, restricted)
- Test offline behavior
- Test with common task phrases like "Remind me to...", "Buy...", "Call..."

## Definition of Done

- Voice input is fully functional and accurate
- UI provides clear feedback during recording
- Error states are handled gracefully
- Voice input works in various environments
- Code is well-documented and tested
- Accessibility features are properly implemented

## Related Issues

- Depends on: #006 - Add task creation form for iPhone
- Next: #008 - Set up basic watchOS app
- Enhances: #005 - Create task list view for iPhone
- Connects to: #010 - Add App Intents extension (Siri)

## Estimated Effort

**Time:** 4-6 hours  
**Complexity:** High  
**Prerequisites:** Understanding of Speech framework, AVFoundation, microphone permissions 