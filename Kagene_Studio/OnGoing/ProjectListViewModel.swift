//
//  ProjectListViewModel.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/08.
//

import Foundation

class ProjectListViewModel: ObservableObject {
    @Published var projects: [AudioProject] = []

    func loadProjects() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found.")
            return
        }

        do {
            let projectFolders = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

            var loadedProjects: [AudioProject] = []

            for projectFolder in projectFolders where projectFolder.hasDirectoryPath {
                let editedFolder = projectFolder.appendingPathComponent("Edited")
                var audioFiles: [AudioFile] = []

                if FileManager.default.fileExists(atPath: editedFolder.path) {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: editedFolder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

                    for fileURL in fileURLs where fileURL.pathExtension == "m4a" {
                        let file = AudioFile(name: fileURL.lastPathComponent, url: fileURL)
                        audioFiles.append(file)
                    }
                }

                let project = AudioProject(name: projectFolder.lastPathComponent, files: audioFiles)
                loadedProjects.append(project)
            }

            DispatchQueue.main.async {
                self.projects = loadedProjects
            }
        } catch {
            print("Error loading projects: \(error)")
        }
    }
}
