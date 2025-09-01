//
//  blocklistview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI

struct BlockListView: View {
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @Environment(\.dismiss) var dismiss
    @State private var newWebsite = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Website Block List")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .font(.headline.weight(.medium))
                .foregroundColor(.orange)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                )
                .buttonStyle(PlainButtonStyle())
            }
            
            // Add new website
            VStack(alignment: .leading, spacing: 12) {
                Text("Add Website to Block")
                    .font(.headline.weight(.medium))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    TextField("Enter domain (e.g., twitter.com)", text: $newWebsite)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .foregroundColor(.white)
                    
                    Button("Add") {
                        if !newWebsite.isEmpty {
                            blockerService.addWebsiteToBlockList(newWebsite)
                            newWebsite = ""
                        }
                    }
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            // Website list
            VStack(alignment: .leading, spacing: 16) {
                Text("Blocked Websites")
                    .font(.headline.weight(.medium))
                    .foregroundColor(.white)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(blockerService.blockedWebsites, id: \.self) { website in
                            HStack(spacing: 16) {
                                Image(systemName: "shield.slash.fill")
                                    .foregroundColor(.red)
                                    .font(.title3)
                                
                                Text(website)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    blockerService.removeWebsiteFromBlockList(website)
                                }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                        .font(.subheadline)
                                        .frame(width: 32, height: 32)
                                        .background(
                                            Circle()
                                                .fill(Color.red.opacity(0.1))
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
            
            Spacer()
        }
        .padding(32)
        .frame(width: 500, height: 600)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.08, blue: 0.12),
                            Color(red: 0.05, green: 0.05, blue: 0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        )
    }
}
