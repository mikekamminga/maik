//
//  ContentView.swift
//  NeuroAssist
//
//  Created by Mike Kamminga on 29/05/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                VStack(spacing: 10) {
                    Text("NeuroAssist")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your AI-powered personal assistant")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 15) {
                    Text("Welcome to NeuroAssist! This app is designed to help you:")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Capture tasks quickly with voice input", systemImage: "mic.fill")
                        Label("Stay organized across iPhone and Apple Watch", systemImage: "applewatch")
                        Label("Get intelligent reminders and suggestions", systemImage: "lightbulb.fill")
                    }
                    .font(.callout)
                }
                
                Spacer()
                
                Text("Phase 1: Foundation Complete ✅")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()
            .navigationTitle("NeuroAssist")
        }
    }
}

#Preview {
    ContentView()
}
