//
//  Kagene_StudioApp.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/04.
//

import SwiftUI

@main
struct Kagene_StudioApp: App {
    @StateObject private var viewModel = ProjectListViewModel() // アプリ全体で1つだけ作る
    
    var body: some Scene {
        WindowGroup {
            ProjectListView()
                .environmentObject(viewModel) // ✅ ここで全体に共有
        }
    }
}
