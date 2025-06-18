//
//  ProjectDeleteButton.swift
//  Voisync
//
//  Created by 本多真一朗 on 2025/06/19.
//
// ProjectDeleteButton.swift
// Kagene_Studio
//
// Created by 本多真一朗 on 2025/06/19.
//

import SwiftUI

struct ProjectDeleteButton: View {
    /// 削除対象のプロジェクト名
    let projectName: String
    @EnvironmentObject private var viewModel: ProjectListViewModel
    /// プロジェクトフォルダ直下の documentsURL
    private let documentsURL = FileManager.default.urls(
        for: .documentDirectory, in: .userDomainMask
    ).first!
    
    @State private var showingAlert = false
    
    var body: some View {
        Button(role: .destructive) {
            // アラート表示
            showingAlert = true
        } label: {
            Image(systemName: "trash")
                .font(.title2)
        }
        .alert(
            "本当にプロジェクト内の全ファイルを削除しますか？",
            isPresented: $showingAlert
        ) {
            Button("削除", role: .destructive) {
                let projectFolderURL = documentsURL.appendingPathComponent(projectName)
                do {
                    try FileManager.default.removeItem(at: projectFolderURL)
                    viewModel.loadProjects()
                    print("✅ Deleted project folder: \(projectFolderURL.path)")
                } catch {
                    print("❌ プロジェクト削除エラー: \(error)")
                }
            }
            Button("キャンセル", role: .cancel) { }
        } message: {
            Text("一度削除すると元に戻せません")
        }
    }
}

//struct ProjectDeleteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDeleteButton(projectName: "SampleProject")
//    }
//}
