//
//  ProjectListViewModel.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/08.
//

import Foundation

class ProjectListViewModel: ObservableObject {
    @Published var projects: [AudioProject] = []
    @Published var files: [AudioFile] = []

    func loadProjects() {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first!

        // 1) Find all project folders, grabbing their modification date
        let folderURLs = (try? fm.contentsOfDirectory(
            at: docs,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: .skipsHiddenFiles
        )) ?? []

        // 2) Sort by that date (newest first)
        let sorted = folderURLs.sorted { urlA, urlB in
            let dateA = (try? urlA.resourceValues(forKeys: [.contentModificationDateKey])
                             .contentModificationDate) ?? .distantPast
            let dateB = (try? urlB.resourceValues(forKeys: [.contentModificationDateKey])
                             .contentModificationDate) ?? .distantPast
            return dateA > dateB
        }

        // 3) Map into your model
        let loaded: [AudioProject] = sorted.map { folder in
            let name = folder.lastPathComponent
            let files = (try? fm.contentsOfDirectory(
                at: folder,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            ))?
            .filter { $0.pathExtension == "m4a" }
            .map { AudioFile(name: $0.lastPathComponent, url: $0) }
            ?? []
            return AudioProject(name: name, files: files)
        }
        
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
                    if FileManager.default.fileExists(atPath: editedFolder.path) {
                        // 1) Fetch all audio URLs, asking for their modification dates up-front
                        let fileURLs = try FileManager.default.contentsOfDirectory(
                            at: editedFolder,
                            includingPropertiesForKeys: [.contentModificationDateKey],
                            options: .skipsHiddenFiles
                        )

                        // 2) Filter to .m4a, then sort by date (newest first)
                        let sortedFileURLs = fileURLs
                            .filter { $0.pathExtension.lowercased() == "m4a" }
                            .sorted { a, b in
                                let da = (try? a.resourceValues(forKeys: [.contentModificationDateKey])
                                             .contentModificationDate) ?? .distantPast
                                let db = (try? b.resourceValues(forKeys: [.contentModificationDateKey])
                                             .contentModificationDate) ?? .distantPast
                                return da > db
                            }

                        // 3) Map into your model
                        for url in sortedFileURLs {
                            audioFiles.append(AudioFile(name: url.lastPathComponent, url: url))
                        }
                    }
                }

                let project = AudioProject(name: projectFolder.lastPathComponent, files: audioFiles)
                loadedProjects.append(project)
            }

            self.projects = loadedProjects
            print("✅ Reloaded projects: \(loadedProjects.count)")
            
        } catch {
            print("Error loading projects: \(error)")
        }
    }
}
