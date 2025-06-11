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
        NavigationView {
            VStack {
                NewProjectButtonView(viewModel: viewModel)
                List {
                    ForEach(viewModel.projects) { project in
                        Section(header:
                            HStack {
                                Text(project.name)
                                    .font(.headline)
                                Spacer()
                                AudioTrimButton()
//                                Button(action: {
//                                    // Handle the add action for this project
//                                }) {
//                                    Image(systemName: "plus")
//                                }
                            }
                            .padding(.trailing)
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
}

#Preview {
    ProjectListView()
}
