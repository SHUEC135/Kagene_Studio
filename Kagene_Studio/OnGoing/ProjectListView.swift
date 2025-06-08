//
//  ProjectListView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/08.
//

import SwiftUI

struct ProjectListView: View {
    @ObservedObject private var viewModel = ProjectListViewModel()

    var body: some View {
        AudioTrimButton()
        NavigationView {
            VStack {
                NewProjectButtonView(viewModel: viewModel)
                List {
                    ForEach(viewModel.projects) { project in
                        Section(header: Text(project.name).font(.headline)) {
                            ForEach(project.files) { file in
                                HStack {
                                    Text(file.name)
                                        .lineLimit(1)
                                    Spacer()
                                    // Optional: add a play button or other actions
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
}

#Preview {
    ProjectListView()
}
