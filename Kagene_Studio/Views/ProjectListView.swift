//
//  ProjectListView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/08.
//

import SwiftUI

struct ProjectListView: View {
    @EnvironmentObject var viewModel: ProjectListViewModel
    
    var body: some View {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        NavigationView {
            VStack {
                NewProjectButtonView {
                    viewModel.loadProjects()
                }
                List {
                    ForEach(viewModel.projects) { project in
                        Section(header:
                            HStack {
                                Text(project.name)
                                    .font(.headline)
                                Spacer()
                                AudioTrimButton(filePath: documentsURL
                                    .appendingPathComponent(project.name)
                                    .appendingPathComponent("\(project.name).mp3")
                                    .path)
                            }
                        ) {
                            ForEach(project.files) { file in
                                HStack {
                                    NavigationLink(
                                        destination: ShadowingView(filePath: documentsURL
                                            .appendingPathComponent(project.name)
                                            .appendingPathComponent("Edited")
                                            .appendingPathComponent(file.name)
                                            .path)
                                    ) {
                                        Text(file.name)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                }
                                .onAppear {
                                    let fullPath = documentsURL
                                        .appendingPathComponent(project.name)
                                        .appendingPathComponent("Edited")
                                        .appendingPathComponent(file.name)
                                        .path
                                    print("🔍 Loading audio from: \(fullPath)")
                                }
                            }
                        }
                    }
                }
                .navigationTitle("プロジェクト")
                .onAppear {
                    viewModel.loadProjects()
                }
            }
        }
    }
    
    private func projectOriginalFilePath(for project: AudioProject) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let originalFileURL = documentsURL
            .appendingPathComponent(project.name)
            .appendingPathComponent("\(project.name).mp3")
        
        print("🔍 Checking original file path: \(originalFileURL.path)")
        print("📄 File exists: \(FileManager.default.fileExists(atPath: originalFileURL.path))")
        
        return originalFileURL.path
    }
}

//#Preview {
//    ProjectListView()
//}
