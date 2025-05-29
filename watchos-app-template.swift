// NeuroAssist_Watch_AppApp.swift (watchOS)
import SwiftUI

@main
struct NeuroAssist_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// ContentView.swift (watchOS)
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                Text("NeuroAssist")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("AI Assistant")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    Label("Voice Tasks", systemImage: "mic.fill")
                        .font(.caption2)
                    Label("Quick Capture", systemImage: "plus.circle.fill")
                        .font(.caption2)
                    Label("Smart Sync", systemImage: "iphone")
                        .font(.caption2)
                }
                
                Spacer()
                
                Text("Ready ✅")
                    .font(.caption2)
                    .foregroundColor(.green)
                    .padding(8)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(6)
            }
            .padding()
            .navigationTitle("NeuroAssist")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
} 