//
//  menubarview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Focus Plug")
                .font(.headline.weight(.bold))
            
            Divider()
            
            if timerManager.isRunning {
                HStack {
                    Text("Session Active")
                        .foregroundColor(.green)
                    Spacer()
                    Text(timerManager.displayTime)
                        .font(.monospaced(.caption)())
                }
            } else {
                Text("Ready to focus")
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            Button("Open Focus Plug") {
                NSApp.activate(ignoringOtherApps: true)
            }
            
            Button("Quick 25min Session") {
                timerManager.setDuration(25 * 60)
                timerManager.start()
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 200)
    }
}
