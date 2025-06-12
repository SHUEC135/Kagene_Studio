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
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let originalFileURL = documentsURL
                                    .appendingPathComponent(project.name)
                                    .appendingPathComponent("\(project.name).mp3")
                                AudioTrimButton(filePath: originalFileURL.path)
                                let originalFilePath = projectOriginalFilePath(for: project)
                            AudioTrimButton(filePath: originalFilePath)
//                                Button(action: {
//                                    // Handle the add action for this project
//                                }) {
//                                    Image(systemName: "plus")
//                                }
                            }
//                            .padding(.trailing)
                        ) {
                            ForEach(project.files) { file in
                                HStack {
                                    Text(file.name)
                                        .lineLimit(1)
                                    Spacer()
                                    Image(systemName: "play.circle")
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
