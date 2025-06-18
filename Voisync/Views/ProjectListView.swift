//
//  ProjectListView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/08.
//

import SwiftUI

struct ProjectListView: View {
    @EnvironmentObject var viewModel: ProjectListViewModel
    
    @State private var showingDeleteAlert = false
    @State private var deleteFilePath: String = ""
    
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
                                    .foregroundColor(.primary)
                                Spacer()
                                AudioTrimButton(filePath: documentsURL
                                    .appendingPathComponent(project.name)
                                    .appendingPathComponent("\(project.name).mp3")
                                    .path
                                )
                            }

                        ) {
                            ForEach(project.files) { file in
                                HStack {
                                    NavigationLink(
                                        destination: ShadowingView(
                                            filePath: documentsURL
                                            .appendingPathComponent(project.name)
                                            .appendingPathComponent("Edited")
                                            .appendingPathComponent(file.name)
                                            .path,
                                            fileName: file.name
                                        )
                                    ) {
                                        Text((file.name as NSString).deletingPathExtension)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteFilePath = documentsURL
                                            .appendingPathComponent(project.name)
                                            .appendingPathComponent("Edited")
                                            .appendingPathComponent(file.name)
                                            .path
                                        showingDeleteAlert = true
                                    } label: {
                                        Label("削除", systemImage: "trash")
                                    }
                                }
                                .alert("本当に削除しますか？", isPresented: $showingDeleteAlert) {
                                    Button("削除", role: .destructive) {
                                        do {
                                            try FileManager.default.removeItem(atPath: deleteFilePath)
                                            viewModel.loadProjects()
                                        } catch {
                                            print("❌ 削除エラー: \(error)")
                                        }
                                    }
                                    Button("キャンセル", role: .cancel) { }
                                } message: {
                                    Text("一度削除すると元に戻せません")
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
