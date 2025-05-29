# Issue #016: Add location-based reminders

**Labels:** `phase-3` `location` `geofencing` `reminders` `priority-medium`

## Description

Implement location-based reminders that trigger when users arrive at or leave specific locations relevant to their tasks. This helps ADHD users remember context-specific tasks when they're in the right place to complete them.

## Acceptance Criteria

- [ ] Geofencing triggers reminders at relevant locations
- [ ] Common locations are automatically detected (home, work, grocery stores)
- [ ] Custom location reminders can be set manually
- [ ] Smart suggestions for location-task associations
- [ ] Respects privacy and battery usage considerations
- [ ] Works with Apple Watch for discreet notifications
- [ ] Location permissions are handled appropriately
- [ ] Integration with task categories and NLP location detection

## Technical Implementation
```swift
import CoreLocation

class LocationReminderManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationReminderManager()
    
    private let locationManager = CLLocationManager()
    private var monitoredRegions: [String: CLCircularRegion] = [:]
    
    override init() {
        super.init()
        locationManager.delegate = self
        setupLocationServices()
    }
    
    func addLocationReminder(for task: Task, at location: CLLocationCoordinate2D, radius: Double = 100) {
        let region = CLCircularRegion(center: location, radius: radius, identifier: task.id.uuidString)
        region.notifyOnEntry = true
        
        locationManager.startMonitoring(for: region)
        monitoredRegions[task.id.uuidString] = region
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let taskId = UUID(uuidString: region.identifier) else { return }
        
        // Trigger location-based reminder
        NotificationManager.shared.sendLocationReminder(for: taskId)
    }
}
```

## Related Issues

- Depends on: #015 - Implement rule-based task prioritization
- Next: #017 - Integrate with calendar
- Enhances: #013 - Use NLP for task categorization

## Estimated Effort

**Time:** 6-8 hours  
**Complexity:** Medium-High 